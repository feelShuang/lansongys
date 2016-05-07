//
//  LSPatientOrderViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/3/28.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSPatientOrderViewController.h"
#import "LSPatientOrderInfoViewController.h"
#import "LSOrderTableViewCell.h"
#import "LSPatientOrder.h"
#import "LSCheckLoginView.h"
#import "LoginController.h"
#import "OrderInfo.h"
#import <MJRefresh.h>
#import "Common.h"

#import "LSRefreshGifHeader.h"


@interface LSPatientOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) LSCheckLoginView *checkLoginView;
// 分段控制器
@property (nonatomic, strong) UISegmentedControl *orderSegment;
// 订单列表
@property (nonatomic, strong) UITableView *orderTableView;
// 存放订单的数组
@property (nonatomic, strong) NSMutableArray *orders;

/** 刷新标记 */
@property (nonatomic, copy) NSString *refreshFlag;

// 背景视图
@property (nonatomic, strong) UIView *bgView;

@end

@implementation LSPatientOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.refreshFlag = @"1";
    
    [OrderInfo shareInstance].isUpLoading = NO;
    
    // 设置UI
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_checkLoginView removeFromSuperview];
    
    // 登录状态下
    if (myAccount) {
        
        // 登录成功重新加载界面
        [self setUI];
        
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
            
            // 处理中的订单
            [self loadHeadHttpRequestWithFlag:@"1"];
        } else {
         
            // 已完成的订单
            [self loadHeadHttpRequestWithFlag:@"2"];
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
    
    // 1. 添加segmentControl
    NSArray *itemArr = @[@"处理中",@"已完成"];
    
    UISegmentedControl *orderSeg = [[UISegmentedControl alloc] initWithItems:itemArr];
    orderSeg.frame = CGRectMake(0, 0, 65, 25);
    orderSeg.tintColor = [UIColor whiteColor];
    orderSeg.selectedSegmentIndex = 0;
    orderSeg.alpha = 0.9;
    [orderSeg addTarget:self action:@selector(segmentClickAction:) forControlEvents:UIControlEventValueChanged];
    self.orderSegment = orderSeg;
    self.navigationItem.titleView = orderSeg;
    
    if (myAccount) {
        
        // 添加tableView
        UITableView *orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64) style:UITableViewStylePlain];
        orderTableView.backgroundColor = ZZBackgroundColor;
        orderTableView.delegate = self;
        orderTableView.dataSource = self;
        [self.view addSubview:orderTableView];
        self.orderTableView = orderTableView;
        
        // 注册Cell
        [self.orderTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LSOrderTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LSOrderTableViewCell class])];
        
        // 添加刷新控件
        [self addHeaderRefreshWithFlag:_refreshFlag];
        [self addFooterRefreshWithFlag:_refreshFlag];
    } else {
        
        [self.view addSubview:_checkLoginView];
    }
}

- (void)checkLoginBtnAction:(UIButton *)sender {
    
    LoginController *loginVC = [[LoginController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark - 分段控制器点击事件
- (void)segmentClickAction:(UISegmentedControl *)sender {
    
    if (myAccount) {
        
        if (sender.selectedSegmentIndex == 0) {
            self.refreshFlag = @"1";
            // 处理中的订单
            [self loadHeadHttpRequestWithFlag:_refreshFlag];
        } else {
            self.refreshFlag = @"2";
            // 已完成的订单
            [self loadHeadHttpRequestWithFlag:_refreshFlag];
        }
        // 添加刷新控件
        [self addHeaderRefreshWithFlag:_refreshFlag];
        [self addFooterRefreshWithFlag:_refreshFlag];
    } else {
        [self.view addSubview:_checkLoginView];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.orders.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LSOrderTableViewCell class]) forIndexPath:indexPath];

    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.orders.count) {
        cell.patientOrder = self.orders[indexPath.row];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSPatientOrderInfoViewController *orderInfoVC = [[LSPatientOrderInfoViewController alloc] init];
    
    LSPatientOrder *order = self.orders[indexPath.row];
    orderInfoVC.order_code = order.order_code;
    
    [self.navigationController pushViewController:orderInfoVC animated:YES];
}

// cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 175;
}

#pragma mark - 普通Header刷新
- (void)addHeaderRefreshWithFlag:(NSString *)flag {
    
    __weak typeof(self) weakSelf = self;
    self.orderTableView.mj_header = [LSRefreshGifHeader headerWithRefreshingBlock:^{
        
        // 1.清除所有数据
        [weakSelf.orders removeAllObjects];
        
        // 2.加载网络请求
        [weakSelf loadHeadHttpRequestWithFlag:flag];
        
        // 3.拿到当前的下拉刷新控件，结束刷新状态
        [weakSelf.orderTableView.mj_header endRefreshing];
    }];
}

#pragma mark - 普通Footer刷新
- (void)addFooterRefreshWithFlag:(NSString *)flag {
    
    __weak typeof(self) weakSelf = self;
    self.orderTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 1.加载网络请求
        [weakSelf loadFooterHttpRequestWithFlag:flag];
        
        // 2.拿到当前的上拉刷新控件，结束刷新状态
        [weakSelf.orderTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 下拉刷新网络请求
- (void)loadHeadHttpRequestWithFlag:(NSString *)flag {
    
    // 1. 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/publish_order_list",BASEURL];
    
    // 2. 创建请求体
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:myAccount.token forKey:@"token"];
    [paras setObject:@1 forKey:@"pn"]; // 页码
    [paras setObject:flag forKey:@"flag"]; // 1-处理中 2-已完成
    
    // 3. 发送post请求
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:paras success:^(NSDictionary *responseObj) {
        ZZLog(@"订单-responseObj--%@",responseObj);
        
        NSArray *dataList = responseObj[@"result"][@"dataList"];
        
        if (!dataList.count) {
            [weakSelf.orders removeAllObjects];
            [weakSelf.orderTableView reloadData];
            // 添加未下单图片
            UIView *bgView = [[UIView alloc] initWithFrame:self.view.frame];
            bgView.backgroundColor = ZZBackgroundColor;
            [self.view addSubview:bgView];
            self.bgView = bgView;
            UIImageView *noOrderIamgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wei_xia_dan"]];
            noOrderIamgeView.contentMode = UIViewContentModeScaleAspectFill;
            noOrderIamgeView.center = self.view.center;
            [bgView addSubview:noOrderIamgeView];
        }else {
            
            if (self.bgView) {
                [self.bgView removeFromSuperview];
            }
            
            NSMutableArray *tempArr = [NSMutableArray array];
            
            tempArr = [LSPatientOrder mj_objectArrayWithKeyValuesArray:dataList];
            
            weakSelf.orders = tempArr;
            
            [weakSelf.orderTableView reloadData];
        }
    } failure:^(NSError *error) {
        ZZLog(@"---%@",error);
        
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
    }];
    
}

#pragma mark - 上拉加载网络请求
- (void)loadFooterHttpRequestWithFlag:(NSString *)flag {
    
    // 2.发送网络请求
    // 2.1准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/publish_order_list",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];// 登录传token
    [params setObject:flag forKey:@"flag"]; // 1-处理中 2-已完成
    /** 当前页码 */
    NSUInteger currentPage = 0;
    ZZLog(@"%ld",(unsigned long)self.orders.count);
    if (self.orders.count <10) {// 当首页显示的数量少于10就说明数据已经取光，直接让current的数值超过1
        currentPage = 2;
        
    }else {
        
        if ((((CGFloat)(self.orders.count) / (CGFloat)10)) - (self.orders.count / 10) >= 0) {
            currentPage = self.orders.count / 10 + 1;
            ZZLog(@"%lu",(unsigned long)currentPage);
        }        
    }
    
    [params setObject:[NSString stringWithFormat:@"%lu",(unsigned long)currentPage] forKey:@"pn"];// 页码
    
    __weak typeof(self)weakSelf = self;
    // 2.2发送post请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"%@",params);
        
        NSArray *dataList = responseObj[@"result"][@"dataList"];
        
        if (!dataList.count) {
            
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            
            NSMutableArray *tempArr = [NSMutableArray array];
            
            tempArr = [LSPatientOrder mj_objectArrayWithKeyValuesArray:dataList];
            
            [weakSelf.orders addObjectsFromArray:tempArr];
            
            [weakSelf.orderTableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        ZZLog(@"---%@",error);
        
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
    }];
}

- (void)loadOrderStatisticData {
    
    // 1. 准备请求网址
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/order_statistic",BASEURL];
    
    // 2. 创建请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:ROLESTYLE?@1:@2 forKey:@"flag"];
    
    // 3.网络请求
    [ZZHTTPTool post:urlStr params:params success:^(id responseObj) {
        ZZLog(@"---responseObj = %@",responseObj);
        
        
//        NSMutableArray *temp = [OrderStatistic mj_objectArrayWithKeyValuesArray:responseObj[@"result"]];
//        ZZLog(@"ahahahaaaa = %@",temp);
//        OrderStatistic *orderStatiStic = [OrderStatistic new];
//        OrderStatistic *allOrderType = [OrderStatistic new];
//        for (orderStatiStic in temp) {
//            if ([orderStatiStic.type isEqualToString:@"-1"]) {
//                allOrderType = orderStatiStic;
//                // 全部分类从数组中移除
//                [temp removeObject:orderStatiStic];
//                // 解决一个bug找到全部类型后删除数组，数组元素少了一个，崩溃。找到之后直接跳出循环解决问题
//                break;
//            }
//        }
//        for (int i = 0; i < temp.count - 1; i ++) {
//            for (int j = 0; j < temp.count - 1 - i; j ++) {
//                // 新建两个OrderStatistic对象
//                OrderStatistic *orderStatiStic_j = temp[j];
//                OrderStatistic *orderStaticStic_k = temp[j + 1];
//                if ([orderStatiStic_j.type integerValue] > [orderStaticStic_k.type integerValue]) {
//                    [temp exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
//                }
//                
//            }
//        }
//        
//        [temp addObject:allOrderType];
//        // 把订单统计数量放进数组
//        for (int i = 0; i < temp.count; i ++) {
//            OrderStatistic *orders = temp[i];
//            [self.order_statistic addObject:orders.count];
//            
//        }
        
    } failure:^(NSError *error) {
        
    }];
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

#pragma 懒加载
- (NSMutableArray *)orders {
    
    if (_orders == nil) {
        self.orders = [NSMutableArray array];
    }
    return _orders;
    
}

//- (NSArray *)orderstatistic {
//    
//    return self.order_statistic;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
