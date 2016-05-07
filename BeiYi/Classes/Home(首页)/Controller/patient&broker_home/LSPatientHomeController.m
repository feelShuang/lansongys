//
//  LSPatientHomeController.m
//  BeiYi
//
//  Created by LiuShuang on 15/4/13.
//  Copyright (c) 2015年 LiuShuang. All rights reserved.
//

#define ZZADScrollViewH [UIScreen mainScreen].bounds.size.height * 0.25 // 广告栏高度
#define HomeBGViewH littleBtnW*2 +3*ZZMarins // 功能按钮背景高度

#import "LSPatientHomeController.h"
#import "Common.h"
#import "LSFamousDoctorViewController.h"
#import "LSDoctorDetailViewController.h"
#import "LSBrokerDoctorTableViewCell.h"
#import "LSRecommendDoctor.h"

#import "LSAppointmentViewController.h"
#import "LSOperationViewController.h"
#import "LSConsultationViewController.h"
#import "LSIllnessAnalyzeViewController.h"
#import "LSLeaveTrackViewController.h"

#import "ZZTabBarController.h"

#import "LoginController.h"

#import "ZZActionBtn.h"
#import "ADInfo.h"

#import "AccountInfo.h"
#import "OrderInfo.h"

#import "LSPatientHomeView.h"

#import <AdSupport/ASIdentifierManager.h>
#import "UIButton+WebCache.h"
#import "SDCycleScrollView.h"
#import "Masonry.h"



@interface LSPatientHomeController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
// 主页视图
@property (nonatomic, strong) LSPatientHomeView *patientHomeView;

/** NSMutableArray 广告信息 数组 */
@property (nonatomic, strong) NSMutableArray *adArray;
/** NSMutableArray 优质医生 数组 */
@property (nonatomic, strong) NSMutableArray *docArray;

@end

@implementation LSPatientHomeController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [OrderInfo shareInstance].service_type = @"0";
    
    // 获取账号信息
    [AccountInfo getAccount];
    
    // 请求主页数据
    [self loadHomeData];
    
    // 设置statusBar的字体颜色 为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 设置导航条颜色
    [self.navigationController.navigationBar setBarTintColor:ZZBaseColor];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [OrderInfo shareInstance].doctorInfo = nil;
    
    UIViewController *VC = self.navigationController.topViewController;
    if ([VC isKindOfClass:[LoginController class]]) {// 在视图返回到 AViewContoller 或者 BViewController 时将颜色改回 A
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#f5f6f7"]];
    }
}

- (void)loadView {
    
    self.patientHomeView = [[LSPatientHomeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.patientHomeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZZBackgroundColor;
    
    // 1. 设置tabView代理
    _patientHomeView.docTableView.delegate = self;
    _patientHomeView.docTableView.dataSource = self;
    _patientHomeView.docTableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    // 注册cell
    [_patientHomeView.docTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LSBrokerDoctorTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LSBrokerDoctorTableViewCell class])];
    
    // 2. 添加全部按钮事件
    [self setTargetAction];

#warning 检测版本
    // 3. 检测版本
//    [self checkVersion];
}

#pragma mark - 设置button事件
- (void)setTargetAction {
    
    // 预约专家
    [_patientHomeView.appointmentExpertsButton addTarget:self action:@selector(functionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 主刀医生
    [_patientHomeView.surgeonButton addTarget:self action:@selector(functionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 会诊服务
    [_patientHomeView.consultationServiceButton addTarget:self action:@selector(functionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 病情分析
    [_patientHomeView.conditionAnalysisButton addTarget:self action:@selector(functionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 离院跟踪
    [_patientHomeView.leaveTrackButton addTarget:self action:@selector(functionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 请求首页数据
- (void)loadHomeData {
    
    // 1. 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/resource/app_start_up",BASEURL];
    
    // 2. 准备请求体
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    
    if (myAccount) {
        [paras setObject:myAccount.token forKey:@"token"];
    } else {

    }
    // 3. 发送post请求
    __weak typeof(self) weakSelf = self;
    [ZZHTTPTool post:urlStr params:paras success:^(NSDictionary *responseObj) {
        ZZLog(@"--首页数据--%@",responseObj);
        
        // 1. 顶部滚动图数据
        self.adArray = responseObj[@"result"][@"spread_list"];
        
        NSMutableArray *temp1 = [NSMutableArray array];// 存放图片地址：image_url
        NSMutableArray *temp2 = [NSMutableArray array];// 存放标题：name
        
        for (NSDictionary *dict in self.adArray) {
            ADInfo *adInfo = [ADInfo adInfoWithDict:dict];
            [temp1 addObject:adInfo.image_url];
            [temp2 addObject:adInfo.name];
        }
        
        // 1.1 添加广告栏视图
        [weakSelf.patientHomeView addCycleScrollViewWithImageUrls:temp1 titles:temp2];
        weakSelf.patientHomeView.cycleScrollView.delegate = self;
        
        
        // 2. 优质医生数据
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dict in responseObj[@"result"][@"recommend_doctors"]) {
            LSRecommendDoctor *doctor = [LSRecommendDoctor mj_objectWithKeyValues:dict];
            [temp addObject:doctor];
        }
        
        // 2.2 获取数据，刷新数组
        weakSelf.docArray = temp;
        [weakSelf.patientHomeView.docTableView reloadData];
        
    } failure:^(NSError *error) {
        ZZLog(@"%@",error);
        
    }];

}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.docArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSBrokerDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LSBrokerDoctorTableViewCell class]) forIndexPath:indexPath];
    
    tableView.tableFooterView = [[UIView alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.recommend_doctor = self.docArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 71;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    
    // 添加边框
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, 0) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:headerView];
    [ZZUITool linehorizontalWithPosition:CGPointMake(15, CGRectGetHeight(headerView.frame)) width:SCREEN_WIDTH backGroundColor:ZZSeparateLineColor superView:headerView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"优质医生";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = ZZTitleColor;
    titleLabel.font = [UIFont systemFontOfSize:13];
    
    [headerView addSubview:titleLabel];
    
    // 添加约束
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        CGSize titleSize = CGSizeMake(SCREEN_WIDTH, 30);
        CGSize size = [titleLabel.text boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
        // size
        make.size.mas_equalTo(size);
        // centerY
        make.centerY.mas_equalTo(headerView);
        // leading
        make.leading.mas_equalTo(headerView).with.offset(10);
    }];
    
    UIButton *allDoctorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [allDoctorBtn setImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
    [allDoctorBtn addTarget:self action:@selector(showAllRecommendDoctor) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:allDoctorBtn];
    
    // 添加约束
    [allDoctorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        // size
        make.size.mas_equalTo(CGSizeMake(30, 30));
        // centerY
        make.centerY.mas_equalTo(headerView);
        // trailing
        make.trailing.mas_equalTo(headerView).with.offset(-5);
    }];
    
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    LSDoctorDetailViewController *doctorDetailVC = [[LSDoctorDetailViewController alloc] init];
    
    LSRecommendDoctor *doctor = self.docArray[indexPath.row];
    doctorDetailVC.doctor_id = doctor.doctor_id;
    
    [self.navigationController pushViewController:doctorDetailVC animated:YES];
}

#pragma mark - 全部按钮
- (void)showAllRecommendDoctor {
    
    // 选择tabBar名医选项卡
    self.tabBarController.selectedIndex = 1;
}

#pragma mark -  监听 功能按钮 点击
- (void)functionBtnClicked:(UIButton *)btn {

    /**
     *  订单类型：1-预约专家 2-主刀医生服务价格 3-会诊服务4-病情分析会5-离院跟踪服务6-服务担保7-差旅费
     */
    // 通过读取账号信息，判断是否登陆
    if (myAccount) { // 已经登陆
    
        [OrderInfo shareInstance].service_type = [NSString stringWithFormat:@"%ld",btn.tag - 100];

        if (btn.tag == 101) {
            LSAppointmentViewController *appointmentVC = [LSAppointmentViewController new];
            appointmentVC.buttonPush = YES;
            [self.navigationController pushViewController:appointmentVC animated:YES];
        } else if (btn.tag == 102) {
            LSOperationViewController *operationVC = [LSOperationViewController new];
            operationVC.buttonPush = YES;
            [self.navigationController pushViewController:operationVC animated:YES];
        } else if (btn.tag == 103) {
            LSConsultationViewController *consultationVC = [LSConsultationViewController new];
            consultationVC.buttonPush = YES;
            [self.navigationController pushViewController:consultationVC animated:YES];
        } else if (btn.tag == 104) {
            LSIllnessAnalyzeViewController *illnessAnalyzeVC = [LSIllnessAnalyzeViewController new];
            illnessAnalyzeVC.buttonPush = YES;
            [self.navigationController pushViewController:illnessAnalyzeVC animated:YES];
        } else {
            LSLeaveTrackViewController *leaveTrackVC = [LSLeaveTrackViewController new];
            leaveTrackVC.buttonPush = YES;
            [self.navigationController pushViewController:leaveTrackVC animated:YES];
        }
    }else { // 未登陆
        LoginController *loginVc = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVc animated:YES];
    }
    
}

#pragma mark - 检查更新
- (void)checkVersion {
    
    // 检查当前版本
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    // 保存当前版本号
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    ZZLog(@"%@",currentVersion);
    
    // 准备应用URL
    NSString *urlStr = APP_URL;
    
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:nil success:^(id responseObj) {
        ZZLog(@"&&&&&&&&%@",responseObj);
        
        NSArray *results = responseObj[@"results"];
        // 获取最新版本号
        NSString *lastVersion = [results firstObject][@"version"];
        ZZLog(@"%@",lastVersion);
        
        if (![lastVersion isEqualToString:currentVersion]) {
            // 有新版本弹框提示更新
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"客户端有新的版本啦，是否前往更新？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *trackViewUrl = [results firstObject][@"trackViewUrl"];
                NSURL *urlApp = [NSURL URLWithString:trackViewUrl];
                // 打开Apple Stroe
                [[UIApplication sharedApplication] openURL:urlApp];
            }];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:okAction];
            [alertController addAction:cancleAction];
            
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    ZZLog(@"---点击了第%ld张图片", (long)index);
}

@end
