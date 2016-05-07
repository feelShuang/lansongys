//
//  LSBrokerDoctorTableViewController.m
//  BeiYi
//
//  Created by LiuShuang on 15/8/31.
//  Copyright (c) 2015年 LiuShuang. All rights reserved.
//

#import "LSBrokerDoctorTableViewController.h"
#import "LSBrokerDoctorTableViewCell.h"
#import "LSBrokerSelectDoctorViewController.h"
#import "LSBrokerAddDoctorViewController.h"
#import "LSBrokerDoctorDetailViewController.h"
#import "LSBrokerDoctor.h"
#import "OrderInfo.h"

#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"

#import "Common.h"
#import "ManageDepts.h"
#import "DeptsCell.h"
#import "BedPriceVc.h"

@interface LSBrokerDoctorTableViewController ()
<UITableViewDataSource,UITableViewDelegate>

/** UITableView - 医生管理 */
@property (nonatomic, strong) UITableView *tableManageDoctor;
/** NSMutableArray - 存放 医生管理 模型 数组 */
@property (nonatomic, strong) NSMutableArray *doctors;
/** NSString - 被选中医生的ids */
@property (nonatomic, copy) NSString *selected_doctor_ids;

@end

@implementation LSBrokerDoctorTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([OrderInfo shareInstance].isUpLoading) {
        // 请求已经添加的医生
        [self loadHTTPForManagingDoctor];
        
        [OrderInfo shareInstance].isUpLoading = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleTextField.text = @"医生管理";
    titleTextField.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleTextField;
    
    // 1.设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self btnWithFrame:CGRectMake(0, 0, 20, 20)]];
    
    // 2.添加医生管理 tableView
    [self addTableManageDoctor];
    
    // 3.注册cell
    [self.tableManageDoctor registerNib:[UINib nibWithNibName:NSStringFromClass([LSBrokerDoctorTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LSBrokerDoctorTableViewCell class])];
    
    [OrderInfo shareInstance].isUpLoading = YES;
    
}

#pragma mark - 创建导航栏右侧按钮
- (UIButton *)btnWithFrame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:@"doctor_tian_jia"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(AddBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

#pragma mark - 监听添加按钮点击
- (void)AddBtnClicked {
    
    NSMutableArray *obj = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [self titles].count; i++) {
        
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.image = [self images][i];
        info.title = [self titles][i];
        [obj addObject:info];
    }
    
    [[WBPopMenuSingleton shareManager]showPopMenuSelecteWithFrame:130 item:obj action:^(NSInteger index) {
        
        if (index == 0) {
            LSBrokerSelectDoctorViewController *selectDoctorVC = [LSBrokerSelectDoctorViewController new];
            [self.navigationController pushViewController:selectDoctorVC animated:YES];
        } else {
            LSBrokerAddDoctorViewController * addDoctorVC = [LSBrokerAddDoctorViewController new];
            [self.navigationController pushViewController:addDoctorVC animated:YES];
        }
    }];
}

#pragma mark - 创建 医生管理 tableView
- (void)addTableManageDoctor {
    self.tableManageDoctor = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStylePlain];
    self.tableManageDoctor.backgroundColor = ZZBackgroundColor;
    self.tableManageDoctor.tableFooterView = [[UIView alloc] init];
    self.tableManageDoctor.dataSource = self;
    self.tableManageDoctor.delegate = self;
    [self.view addSubview:self.tableManageDoctor];
}


#pragma mark - 下拉刷新-网络请求（获取-医生管理-信息）
- (void)loadHTTPForManagingDoctor {
    
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/offer/offer_doctors",BASEURL];// 服务医院或医生接口
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];// 登录token
    
    __weak typeof(self) weakSelf = self;
    
    // 2.发送post请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"---医生管理--responseObj＝%@",responseObj);

        // 2.2 展示订单信息
        NSArray *dataList = responseObj[@"result"];
        
        NSMutableArray *arrOffTemp = [NSMutableArray array];
        for (NSDictionary *dict in dataList) {
            LSBrokerDoctor *doctor = [LSBrokerDoctor mj_objectWithKeyValues:dict];
            [arrOffTemp addObject:doctor];
        }
        
        // 2.3 获取数据，刷新数组
        weakSelf.doctors = arrOffTemp;
        [weakSelf.tableManageDoctor reloadData];
        
        
        if (arrOffTemp.count) {
            // 2.4 获取已经添加的医生的id,拼接成字符串
            NSString *tempIDs = [NSString string];
            for (LSBrokerDoctor *doctor in arrOffTemp) {
                tempIDs = [tempIDs stringByAppendingString:[NSString stringWithFormat:@"%@,",doctor.doctor_id]];
            }
            
            // 截取掉最后一个字符串
            weakSelf.selected_doctor_ids = [tempIDs substringWithRange:NSMakeRange(0, [tempIDs length] -1)];
        
        }else {
            [MBProgressHUD showError:@"暂无医生，请添加"];

            weakSelf.selected_doctor_ids = @"";
            
        }
        
        ZZLog(@"---医生管理--tempIDs＝%@",weakSelf.selected_doctor_ids);

    } failure:^(NSError *error) {
        ZZLog(@"医生管理---%@",error);
        
        // 隐藏遮盖
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.doctors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSBrokerDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LSBrokerDoctorTableViewCell class]) forIndexPath:indexPath];
    if (indexPath.row < self.doctors.count) {
        cell.broker_doctor = self.doctors[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 71;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LSBrokerDoctorDetailViewController *doctorDetailVC = [[LSBrokerDoctorDetailViewController alloc] init];
    doctorDetailVC.doctor = self.doctors[indexPath.row];
    
    [self.navigationController pushViewController:doctorDetailVC animated:YES];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZLog(@"--删除所选医生--");
    LSBrokerDoctor *doctor = self.doctors[indexPath.row];
    [self loadHttpRequestWithDoctor:doctor indexPath:indexPath];

}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @" 删 除 ";
}

#pragma mark - 删除医生 根据医生ID加载网络请求 根据indexPath删除本地数组的医生
- (void)loadHttpRequestWithDoctor:(LSBrokerDoctor *)doctor indexPath:(NSIndexPath *)indexPath {
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/offer/delete",BASEURL];// 删除服务医生接口
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:doctor.hospital_id forKey:@"hospital_id"];
    [params setObject:doctor.doctor_id forKey:@"doctor_id"];// 医生ID
    ZZLog(@"%@",params);
    __weak typeof(self) weakSelf = self;
    
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"---responseObj = %@",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {// 操作成功
            [weakSelf.doctors removeObjectAtIndex:indexPath.row];
            [weakSelf.tableManageDoctor reloadData];
            
        }else {
            [MBProgressHUD showError:responseObj[@"message"]];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"%@",error);
    }];
}

- (NSArray *) titles {
    return @[@"选择医生",
             @"新增医生"
            ];
}

- (NSArray *) images {
    return @[@"xuan_ze",
             @"xin_zeng"];
}

@end
