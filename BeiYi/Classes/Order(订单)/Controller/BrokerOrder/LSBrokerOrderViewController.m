//
//  LSBrokerOrderViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/5.
//  Copyright © 2016年 Joe. All rights reserved.
//

#define kOrderAllPriceHeight 40

#import "LSBrokerOrderViewController.h"
#import "LSBrokerOrderInfoViewController.h"
#import "LSSearchOrderViewController.h"
#import "LSTravelPriceViewController.h"
#import "LSOrderTableViewCell.h"
#import "LSCheckLoginView.h"
#import "LoginController.h"
#import "LSBrokerOrder.h"
#import "Common.h"
#import "LSRefreshGifHeader.h"
#import <MJRefresh.h>
#import <Masonry.h>

@interface LSBrokerOrderViewController ()<UITableViewDataSource,UITableViewDelegate,LSSearchOrderDelegate>

@property (nonatomic, strong) LSSearchOrderViewController *searchOrderVC;
// 检查网络视图
@property (nonatomic, strong) LSCheckLoginView *checkLoginView;
// 分段控制器
@property (nonatomic, strong) UISegmentedControl *orderSegment;
// 订单列表
@property (nonatomic, strong) UITableView *brokerOrderTableView;
// 存放订单的数组
@property (nonatomic, strong) NSMutableArray *brokerOrders;
/** 关键字 */
@property (nonatomic, copy) NSString *keyword;
/** 订单状态 */
@property (nonatomic, copy) NSString *order_status;
/** 订单类型 */
@property (nonatomic, copy) NSString *order_type;
/** 订单开始时间 */
@property (nonatomic, copy) NSString *start;
/** 订单结束时间 */
@property (nonatomic, copy) NSString *end;

/** 总金额 */
@property (nonatomic, strong) UILabel *totalPriceLabel;

/** 刷新标记 */
@property (nonatomic, copy) NSString *refreshFlag;

@end

@implementation LSBrokerOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.keyword = @"";
    self.order_status = @"0";
    self.order_type = @"0";
    self.start = @"";
    self.end = @"";
    
    self.refreshFlag = @"1";
    
    // 设置UI
    [self setUI];
    
    // 注册Cell
    [self.brokerOrderTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LSOrderTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LSOrderTableViewCell class])];
    
    // 添加刷新控件
    [self addHeaderRefreshWithFlag:_refreshFlag];
    [self addFooterRefreshWithFlag:_refreshFlag];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 登录状态下
    if (myAccount) {
        
        // 登录成功删除登录页面
        [_checkLoginView removeFromSuperview];
    } else { // 未登录状态下添加跳转登录的界面
        
        self.checkLoginView = [[LSCheckLoginView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        [self.checkLoginView.checkLoginBtn addTarget:self action:@selector(checkLoginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_checkLoginView];
    }
    
    // 设置navigationBar的颜色
    [self.navigationController.navigationBar setBarTintColor:ZZBaseColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 登录状态下请求订单数据
    if (myAccount) {
        if (self.orderSegment.selectedSegmentIndex == 0) {
            // 普通Header刷新
            [self loadHeadHttpRequestWithFlag:_refreshFlag];
        } else {
            // 普通Header刷新
            [self loadHeadHttpRequestWithFlag:_refreshFlag];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    UIViewController *VC = self.navigationController.topViewController;
    if ([VC isKindOfClass:[LoginController class]]) {// 在视图返回到 AViewContoller 或者 BViewController 时将颜色改回 A
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#f5f6f7"]];
    }
}

#pragma mark - 设置UI
- (void)setUI {
    
    self.view.backgroundColor = ZZBackgroundColor;
    
    // 1. 添加segmentControlr
    NSArray *itemArr = @[@"处理中",@"已完成"];
    
    UISegmentedControl *orderSeg = [[UISegmentedControl alloc] initWithItems:itemArr];
    orderSeg.frame = CGRectMake(0, 0, 65, 25);
    orderSeg.tintColor = [UIColor whiteColor];
    orderSeg.selectedSegmentIndex = 0;
    orderSeg.alpha = 0.9;
    [orderSeg addTarget:self action:@selector(segmentClickAction:) forControlEvents:UIControlEventValueChanged];
    self.orderSegment = orderSeg;
    self.navigationItem.titleView = orderSeg;
    
    
    // 2. 设置导航栏右侧按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"famousDoc_sousuo"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchBrokerOrder) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    // 添加总金额
    UIView *total_priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, kOrderAllPriceHeight)];
    total_priceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:total_priceView];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.textColor = ZZColor(255, 38, 38, 1);
    [total_priceView addSubview:priceLabel];
    self.totalPriceLabel = priceLabel;
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       //
        make.centerY.mas_equalTo(total_priceView);
        make.trailing.mas_equalTo(total_priceView).offset = -15;
    }];
    
    // 添加tableView
    UITableView *orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + kOrderAllPriceHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64 - kOrderAllPriceHeight) style:UITableViewStylePlain];
    orderTableView.backgroundColor = ZZBackgroundColor;
    orderTableView.delegate = self;
    orderTableView.dataSource = self;
    [self.view addSubview:orderTableView];
    self.brokerOrderTableView = orderTableView;
}

- (void)searchBrokerOrder {
    
    LSSearchOrderViewController *searchOrderVC = [LSSearchOrderViewController new];
    searchOrderVC.delegate = self;
    [self.navigationController pushViewController:searchOrderVC animated:YES];
}

#pragma mark - 分段控制器点击事件
- (void)segmentClickAction:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        self.refreshFlag = @"1";
        // 普通Header刷新
        [self loadHeadHttpRequestWithFlag:_refreshFlag];
    } else {
        self.refreshFlag = @"2";
        // 普通Header刷新
        [self loadHeadHttpRequestWithFlag:_refreshFlag];
    }
    // 添加刷新控件
    [self addHeaderRefreshWithFlag:_refreshFlag];
    [self addFooterRefreshWithFlag:_refreshFlag];
}

- (void)checkLoginBtnAction:(UIButton *)sender {
    
    LoginController *loginVC = [[LoginController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.brokerOrders.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LSOrderTableViewCell class]) forIndexPath:indexPath];
    
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.brokerOrders.count) {
        
        cell.brokerOrder = self.brokerOrders[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSOrderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.brokerOrder.travel_submit_flag isEqualToString:@"0"]) {
        
        LSTravelPriceViewController *travelPriceVC = [LSTravelPriceViewController new];
        travelPriceVC.brokerOrder = cell.brokerOrder;
        travelPriceVC.orderPrice = [NSString stringWithFormat:@"￥%@",cell.brokerOrder.price];
        [self.navigationController pushViewController:travelPriceVC animated:YES];
    } else {
        
        LSBrokerOrderInfoViewController *orderInfoVC = [[LSBrokerOrderInfoViewController alloc] init];
        
        LSBrokerOrder *brokerOrder = self.brokerOrders[indexPath.row];
        orderInfoVC.order_code = brokerOrder.order_code;
        
        [self.navigationController pushViewController:orderInfoVC animated:YES];
    }
}

// cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 175;
}

#pragma mark - 普通Header刷新
- (void)addHeaderRefreshWithFlag:(NSString *)flag {
    
    __weak typeof(self) weakSelf = self;
    self.brokerOrderTableView.mj_header = [LSRefreshGifHeader headerWithRefreshingBlock:^{
        // 1.清除所有数据
        [weakSelf.brokerOrders removeAllObjects];
        
        // 2.加载网络请求
        [weakSelf loadHeadHttpRequestWithFlag:flag];
        
        // 3.拿到当前的下拉刷新控件，结束刷新状态
        [weakSelf.brokerOrderTableView.mj_header endRefreshing];
    }];
}

#pragma mark - 普通Footer刷新
- (void)addFooterRefreshWithFlag:(NSString *)flag {
    
    __weak typeof(self) weakSelf = self;
    self.brokerOrderTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 1.加载网络请求
        [weakSelf loadFooterHttpRequestWithFlag:flag];
        
        // 2.拿到当前的上拉刷新控件，结束刷新状态
        [weakSelf.brokerOrderTableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - 下拉刷新网络请求
- (void)loadHeadHttpRequestWithFlag:(NSString *)flag {
    
    // 1. 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/offer_order_list",BASEURL];
    
    // 2. 创建请求体
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:myAccount.token forKey:@"token"];
    [paras setObject:@1 forKey:@"pn"]; // 页码
    [paras setObject:flag forKey:@"flag"]; // 1-处理中 2-已完成
    [paras setObject:_keyword forKey:@"keyword"];
    [paras setObject:_order_status forKey:@"order_status"];
    [paras setObject:_order_type forKey:@"order_type"];
    [paras setObject:_start forKey:@"start"];
    [paras setObject:_end forKey:@"end"];
    
    // 3. 发送post请求
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:paras success:^(NSDictionary *responseObj) {
        ZZLog(@"%@",paras);
        ZZLog(@"订单-responseObj--%@",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            
            NSArray *dataList = responseObj[@"result"][@"page"][@"dataList"];
            
            if (!dataList.count) {
                // 隐藏遮盖
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [weakSelf.brokerOrders removeAllObjects];
                [weakSelf.brokerOrderTableView reloadData];
                [MBProgressHUD showError:@"还没有订单" toView:weakSelf.view];
            }else {
                // 设置总金额
                NSString *titString = [NSString stringWithFormat:@"总金额：￥%@",responseObj[@"result"][@"total_price"]];
                [self differentColorWithLabel:self.totalPriceLabel titleStr:titString];
                
                NSMutableArray *tempArr = [NSMutableArray array];
                
                tempArr = [LSBrokerOrder mj_objectArrayWithKeyValuesArray:dataList];
                
                weakSelf.brokerOrders = tempArr;
                
                // 隐藏遮盖
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [weakSelf.brokerOrderTableView reloadData];
            }
        } else {
            [MBProgressHUD showError:responseObj[@"message"] toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        ZZLog(@"---%@",error);
        
        // 隐藏遮盖
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
    }];
    
}

#pragma mark - 上拉加载网络请求
- (void)loadFooterHttpRequestWithFlag:(NSString *)flag {
    
    // 2.发送网络请求
    // 2.1准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/offer_order_list",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];// 登录传token
    [params setObject:flag forKey:@"flag"]; // 1-处理中 2-已完成
    [params setObject:_keyword forKey:@"keyword"];
    [params setObject:_order_status forKey:@"order_status"];
    [params setObject:_order_type forKey:@"order_type"];
    [params setObject:_start forKey:@"start"];
    [params setObject:_end forKey:@"end"];
    
    /** 当前页码 */
    NSUInteger currentPage = 0;
    ZZLog(@"%ld",(unsigned long)self.brokerOrders.count);
    if (self.brokerOrders.count <10) {// 当首页显示的数量少于10就说明数据已经取光，直接让current的数值超过1
        currentPage = 2;
    }else {
        
        if ((((CGFloat)(self.brokerOrders.count) / (CGFloat)10)) - (self.brokerOrders.count / 10) >= 0) {
            currentPage = self.brokerOrders.count / 10 + 1;
            ZZLog(@"%lu",(unsigned long)currentPage);
        }
    }
    
    [params setObject:[NSString stringWithFormat:@"%lu",(unsigned long)currentPage] forKey:@"pn"];// 页码
    
    __weak typeof(self)weakSelf = self;
    // 2.2发送post请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"%@",params);
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        NSArray *dataList = responseObj[@"result"][@"dataList"];
        
        if (!dataList.count) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.brokerOrderTableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            
            NSMutableArray *tempArr = [NSMutableArray array];
            
            tempArr = [LSBrokerOrder mj_objectArrayWithKeyValuesArray:dataList];
            
            [weakSelf.brokerOrders addObjectsFromArray:tempArr];
            
            [weakSelf.brokerOrderTableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        ZZLog(@"---%@",error);
        
        // 隐藏遮盖
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
    }];
}

#pragma mark - 改变Label字体颜色
- (void)differentColorWithLabel:(UILabel *)label titleStr:(NSString *)titlStr {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:titlStr];
    
    [str addAttribute:NSForegroundColorAttributeName value:ZZTitleColor range:NSMakeRange(0,4)];
    
    label.attributedText = str;
}

- (void)checkNetworkStatus {
    // 检测网络连接状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 连接状态回调处理
    /* AFNetworking的Block内使用self须改为weakSelf, 避免循环强引用, 无法释放 */
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         /**
          * AFNetworkReachabilityStatusUnknown	未知
          * AFNetworkReachabilityStatusNotReachable	无网络连接
          * AFNetworkReachabilityStatusReachableViaWWAN	手机自带网络
          * AFNetworkReachabilityStatusReachableViaWiFi	WIFI
          */
         //         if (status == AFNetworkReachabilityStatusUnknown) {
         //
         //         }
         //         else if (status == AFNetworkReachabilityStatusNotReachable) {
         //
         //             UIView *noNetWorkView = [[UIView alloc] initWithFrame:weakSelf.orderTableView.frame];
         //             noNetWorkView.backgroundColor = [UIColor orangeColor];
         //             [weakSelf.orderTableView addSubview:noNetWorkView];
         //         }
         //         else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
         //             // 有网络请求数据
         //             [weakSelf loadHeadHttpRequest];
         //         }
         //         else {
         //             // 有网络请求数据
         //             [weakSelf loadHeadHttpRequest];
         //         }
         
     }];
}

#pragma mark - LSSearchOrderDelegate
- (void)searchOrderController:(LSSearchOrderViewController *)searchOrderVC keyWord:(NSString *)keyword order_status:(NSString *)order_status order_type:(NSString *)order_type startTime:(NSString *)start endTime:(NSString *)end {
    
    
    self.keyword = @"郑伟";
    self.order_status = order_status;
    self.order_type = order_type;
    self.start = start;
    self.end = end;
    ZZLog(@"%@,%@,%@,%@,%@",keyword,order_status,order_type,start,end);
}

#pragma 懒加载
- (NSMutableArray *)brokerOrders {
    
    if (_brokerOrders == nil) {
        self.brokerOrders = [NSMutableArray array];
    }
    return _brokerOrders;
    
}

@end
