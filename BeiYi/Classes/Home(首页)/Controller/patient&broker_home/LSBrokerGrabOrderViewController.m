//
//  LSBrokerGrabOrderViewController.m
//  BeiYi
//
//  Created by LiuShuang on 15/4/13.
//  Copyright (c) 2015年 LiuShuang. All rights reserved.
//
#define kPageSize 10 // 每页取数据的数量

#import "LSBrokerGrabOrderViewController.h"
#import "LSBrokerGrabOrderTableViewCell.h"
#import "LSBrokerOrderInfoViewController.h"
#import "LSTravelPriceViewController.h"
#import "LSRechargeViewController.h"
#import "LSCheckLoginView.h"
#import "GetOrderDetailController.h"
#import "LoginController.h"
#import "AccountInfo.h"

#import "LSGrabOrder.h"

#import "LSRefreshGifHeader.h"
#import "MJRefresh.h"
#import "Common.h"

@interface LSBrokerGrabOrderViewController ()<LSBrokerGrabOrderDelegate,UITableViewDataSource,UITableViewDelegate>

/** 抢单列表 */
@property (nonatomic, strong) UITableView *grabOrderTableView;
/** 未登录状态下的View */
@property (nonatomic, strong) LSCheckLoginView *checkLoginView;
/** NSMutableArray 抢单 数组*/
@property (nonatomic, strong) NSMutableArray *grabOrders;
/** NSDictionary 抢单 详情*/
@property (nonatomic, strong) NSDictionary *grabOrderInfos;
/** 我的余额 */
@property (nonatomic, assign) CGFloat use_balance;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation LSBrokerGrabOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"抢单";
    
    // 获取账号信息
    [AccountInfo getAccount];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_checkLoginView != nil) {
        [_checkLoginView removeFromSuperview];
    }
    
    if (myAccount) {

        [self setUI];
        // 加载数据
        [self loadHeadHttpRequest];
        
        // 获取余额
        [self getBalance];
    } else {
        self.checkLoginView = [[LSCheckLoginView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        [self.checkLoginView.checkLoginBtn addTarget:self action:@selector(checkLoginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_checkLoginView];
    }
}

#pragma mark - 设置UI
- (void)setUI {
    
    self.view.backgroundColor = ZZBackgroundColor;
    
    if (myAccount) { // 已登录
        // 添加tableView
        UITableView *orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStylePlain];
        orderTableView.backgroundColor = ZZBackgroundColor;
        orderTableView.delegate = self;
        orderTableView.dataSource = self;
        [self.view addSubview:orderTableView];
        self.grabOrderTableView = orderTableView;
        
        // 注册Cell
        [self.grabOrderTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LSBrokerGrabOrderTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LSBrokerGrabOrderTableViewCell class])];
        
        // 添加刷新控件
        [self addHeaderRefresh];
        [self addFooterRefresh];
    } else {
        // 未登录添加
        [self.view addSubview:_checkLoginView];
    }
}


- (void)checkLoginBtnAction:(UIButton *)sender {
    
    LoginController *loginVC = [[LoginController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark - 普通Header刷新
- (void)addHeaderRefresh {
    __weak typeof(self) weakSelf = self;
    
    self.grabOrderTableView.mj_header = [LSRefreshGifHeader headerWithRefreshingBlock:^{
        // 1.清除所有数据
        [weakSelf.grabOrders removeAllObjects];
        
        // 2.加载网络请求
        [weakSelf loadHeadHttpRequest];
        
        // 3.拿到当前的下拉刷新控件，结束刷新状态
        [weakSelf.grabOrderTableView.mj_header endRefreshing];
    }];
}

#pragma mark - 普通Footer刷新
- (void)addFooterRefresh {
    __weak typeof(self) weakSelf = self;
    
    self.grabOrderTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 1.加载网络请求
        [weakSelf loadFooterHttpRequest];
        
        // 2.拿到当前的上拉刷新控件，结束刷新状态
        [weakSelf.grabOrderTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 下拉加载网络请求
- (void)loadHeadHttpRequest {
    
    // 2.发送网络请求
    // 2.1准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/grab_list",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (myAccount) {
        [params setObject:myAccount.token forKey:@"token"]; // 登录传token
    } else {
        [params setObject:@"" forKey:@"token"]; // 未登录token传空
    }
    [params setObject:@1 forKey:@"pn"]; // 页码
    [params setObject:@-1 forKey:@"order_type"]; // 订单类型
    
    __weak typeof(self) weakSelf = self;
    
    // 2.2发送post请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"抢单-responseObj--%@",responseObj);
        
        NSArray *dataList = responseObj[@"result"][@"dataList"];
        
        if (!dataList.count) {
            // 隐藏遮盖
            [weakSelf.grabOrders removeAllObjects];
            [weakSelf.grabOrderTableView reloadData];
        }else {
            // 将字典数组转成模型数组
            weakSelf.grabOrders = [LSGrabOrder mj_objectArrayWithKeyValuesArray:dataList];
            
            // 隐藏遮盖
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.grabOrderTableView reloadData];
        }
    } failure:^(NSError *error) {
        ZZLog(@"---%@",error);
        
        // 隐藏遮盖
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
    }];
}

#pragma mark - 没有订单时的提示view
- (void)addDoctorTipView {
    
    // 添加未下单图片
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.frame];
    bgView.backgroundColor = ZZBackgroundColor;
    [self.view addSubview:bgView];
    self.bgView = bgView;
    // 添加图片
    UIImageView *addDoctorImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_doctor"]];
    addDoctorImg.contentMode = UIViewContentModeScaleAspectFill;
    addDoctorImg.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 3);
    [bgView addSubview:addDoctorImg];
    
    // 添加按钮
    UIButton *addDoctorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    addDoctorBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addDoctorBtn setTitle:@"去添加" forState:UIControlStateNormal];
    [addDoctorBtn setBackgroundColor:ZZButtonColor];
}

#pragma mark - 上拉加载网络请求
- (void)loadFooterHttpRequest {
    
    // 2.发送网络请求
    // 2.1准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/grab_list",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (myAccount) {
        [params setObject:myAccount.token forKey:@"token"];// 登录传token
    } else {
        [params setObject:@"" forKey:@"token"];// 未登录token传空
    }
    
    /** 当前页码 */
    NSUInteger currentPage = 0;
    if (self.grabOrders.count <10) {// 当首页显示的数量少于10就说明数据已经取光，直接让current的数值超过1
        currentPage = 2;
        
    }else {
        currentPage = self.grabOrders.count/10 +1;
        
    }
    
    [params setObject:[NSString stringWithFormat:@"%lu",(unsigned long)currentPage] forKey:@"pn"];// 页码
    
    __weak typeof(self) weakSelf = self;
    
    // 2.2发送post请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"抢单-responseObj--%@",responseObj);
        
        NSArray *dataList = responseObj[@"result"][@"dataList"];
        
        if (!dataList.count) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.grabOrderTableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            
            NSMutableArray *tempArr = [NSMutableArray array];
            // 将字典数组转成模型数组
            tempArr = [LSGrabOrder mj_objectArrayWithKeyValuesArray:dataList];
            
            [weakSelf.grabOrders addObjectsFromArray:tempArr];
            
            [weakSelf.grabOrderTableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        ZZLog(@"---%@",error);
        
        // 隐藏遮盖
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
    }];
}

#pragma mark - 获取余额
- (void)getBalance {
    
    // 获取我的余额
    // 1. 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/trader/account",BASEURL];
    
    // 2. 创建请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"token"] = myAccount.token;
    
    // 3. 发送post请求
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"---余额---%@",responseObj);
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            CGFloat balance = [responseObj[@"result"][@"use_balance"] floatValue];
            weakSelf.use_balance = balance;
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"%@",error);
    }];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.grabOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSBrokerGrabOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LSBrokerGrabOrderTableViewCell class]) forIndexPath:indexPath];
    
    tableView.tableFooterView = [[UIView alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;// 取消选中状态
    
    if (indexPath.row<self.grabOrders.count) {
        
        cell.grabOrder = self.grabOrders[indexPath.row];
    }
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 71;
}

#pragma mark  - 抢单按钮监听
- (void)grabOrderCell:(LSBrokerGrabOrderTableViewCell *)grabOrderCell didClickedGrabBtn:(UIButton *)grabBtn {
    
    if (myAccount) {// 已经登陆(允许抢单)
        
        CGFloat orderPrice = [[grabOrderCell.priceLabel.text substringFromIndex:1] floatValue];
        
        if (self.use_balance - orderPrice > 0 || self.use_balance - orderPrice == 0) { // 余额够
            
            [MBProgressHUD showMessage:@"抢单中..." toView:self.view];
            // 1. 准备请求接口
            NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/grab",BASEURL];// 抢单接口
            
            // 2. 创建请求体
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:grabOrderCell.grabOrder.order_code forKey:@"order_code"];// 订单编号
            [params setObject:myAccount.token forKey:@"token"];
            
            // 3. 发送post请求
            __weak typeof(self) weakSelf = self;
            [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                ZZLog(@"抢单---%@",responseObj);
                
                if ([responseObj[@"code"] isEqual:@"0000"]) {// 在提供者范围内
                    
                    // 1.抢单成功
                    [MBProgressHUD showSuccess:@"抢单成功" toView:weakSelf.view];
                    // 2.推出订单详情界面
                    LSBrokerOrderInfoViewController *brokerOrderInfoVC = [LSBrokerOrderInfoViewController new];
                    
                    brokerOrderInfoVC.order_code = grabOrderCell.grabOrder.order_code;
                    
                    [self.navigationController pushViewController:brokerOrderInfoVC animated:YES];
                    
                } else if ([responseObj[@"code"] isEqualToString:@"0005"]) { // 提供差旅费
                    
                    LSTravelPriceViewController *travelPriceVC = [LSTravelPriceViewController new];
                    
                    travelPriceVC.grabOrder = grabOrderCell.grabOrder;
                    travelPriceVC.orderPrice = grabOrderCell.priceLabel.text;
                    
                    [self.navigationController pushViewController:travelPriceVC animated:YES];
                } else { // 该提供者不为此医院提供服务
                    
                    [MBProgressHUD showError:responseObj[@"message"] toView:weakSelf.view];
                }
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [MBProgressHUD showError:@"发生异常，请重试..." toView:weakSelf.view];
                
            }];
        } else {
            
            // 提示余额不足
            [self rechargeAlert];
        }
    }else {// 未登陆,跳转到登陆界面
        LoginController *loginVc = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVc animated:YES];
    }
}

#pragma mark - 弹出是否充值提示框
- (void)rechargeAlert {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您的余额不足，是否前去充值" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LSRechargeViewController *rechargeVC = [LSRechargeViewController new];
        [self.navigationController pushViewController:rechargeVC animated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
