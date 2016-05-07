//
//  RegisteOfferController.m
//  BeiYi
//
//  Created by Joe on 15/6/19.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "RegisteOfferController.h"
#import "Common.h"
#import "Hospital.h"
#import "ZZTagList.h"
#import "ZZHttpTool.h"
#import "OfferHospitalTableViewCell.h"
#import "AddHospitalTableViewController.h"
#import "SettingDocPriceVc.h"

@interface RegisteOfferController ()<UITableViewDataSource,UITableViewDelegate>

// 医院列表
@property (nonatomic, strong) UITableView *serviceHospitalTableView;

// 医院
@property (nonatomic, strong) NSMutableArray *hospitalArray;

/** 存放 网络接收来的 医院列表 的数组 */
@property (nonatomic, strong) NSMutableArray *tags;

/** 存放选择好的标签的 NSIndexSet */
@property (nonatomic, strong) NSIndexSet *set;

/** 存放选择好的医院id集合 NSString */
@property (nonatomic, copy) NSString *changedHosID;

@end

@implementation RegisteOfferController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.添加服务者医院tableView
    [self addHosipitalList];
    
    // 2. 注册cell
    [self.serviceHospitalTableView registerNib:[UINib nibWithNibName:NSStringFromClass([OfferHospitalTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OfferHospitalTableViewCell class])];
    
    // 3.设置UI
    [self setUI];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadHttpRequest];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _hospitalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OfferHospitalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OfferHospitalTableViewCell class]) forIndexPath:indexPath];
    
    Hospital *hospital = _hospitalArray[indexPath.row];
    cell.hospital = hospital;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Hospital *hospital = _hospitalArray[indexPath.row];
    SettingDocPriceVc *setHospital = [SettingDocPriceVc new];
    setHospital.typeNum = @"4";
    setHospital.controllerID = 10;
    setHospital.hospital_id = hospital.hospital_id;
    setHospital.price1 = [NSString stringWithFormat:@"%@.00",hospital.price];
    [self.navigationController pushViewController:setHospital animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZLog(@"--删除所选医院--");
    Hospital *hospital = _hospitalArray[indexPath.row];
    [self loadHttpRequestWithHospital:hospital indexPath:indexPath];
}

#pragma mark - 提供者医院tableView
- (void)addHosipitalList {
    
    UITableView *hospitalList = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    hospitalList.backgroundColor = ZZBackgroundColor;
    hospitalList.delegate = self;
    hospitalList.dataSource = self;
    [self.view addSubview:hospitalList];
    _serviceHospitalTableView = hospitalList;
}

#pragma mark - 设置UI
- (void)setUI {
    
    self.view.backgroundColor = ZZBackgroundColor;
    self.title = @"服务的医院";
    
    // 1.设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self btnWithFrame:CGRectMake(SCREEN_WIDTH - 40 -10, 25, 50, 40)]];
}

#pragma mark - 创建导航栏右侧按钮
- (UIButton *)btnWithFrame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:@"添加" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

#pragma mark - 监听 导航栏右侧按钮 点击事件
- (void)confirmBtnClicked {
    
    AddHospitalTableViewController *addHosTVC = [AddHospitalTableViewController new];
    [self.navigationController pushViewController:addHosTVC animated:YES];
}

#pragma mark - 加载网络请求
- (void)loadHttpRequest {
    [MBProgressHUD showMessage:@"请稍后..."];
    
    // 准备请求网址
    NSString *urlString = [NSString stringWithFormat:@"%@/uc/offer/offer_hospitals",BASEURL];
    // 2.1创建请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:myAccount.token forKey:@"token"]; // 1.登录token
    
    
    // 2.2发送post请求
    __weak typeof(self) weakSelf = self;
    [ZZHTTPTool post:urlString params:params success:^(id responseObj) {
        ZZLog(@"医院列表——————%@",responseObj);
        
        // 隐藏遮盖
        [MBProgressHUD hideHUD];
        
        self.hospitalArray = [Hospital mj_objectArrayWithKeyValuesArray:responseObj[@"result"]];
        
        [_serviceHospitalTableView reloadData];
        
    } failure:^(NSError *error) {
        ZZLog(@"---%@",error);
        
        // 隐藏遮盖
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
        
    }];
}

#pragma mark - 删除医院
- (void)loadHttpRequestWithHospital:(Hospital *)hospital
                          indexPath:(NSIndexPath *)indexPath {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/offer/delete",BASEURL];// 删除服务医生接口
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:hospital.hospital_id forKey:@"hospital_id"];
    [params setObject:@"-1" forKey:@"doctor_id"];// 医生ID
    ZZLog(@"%@",params);
    
    __weak typeof(self) weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"---responseObj = %@",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {// 操作成功
            [weakSelf.hospitalArray removeObjectAtIndex:indexPath.row];
            [weakSelf.serviceHospitalTableView reloadData];
            
        }else {
            [MBProgressHUD showError:responseObj[@"message"]];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"%@",error);
    }];

    
}



@end
