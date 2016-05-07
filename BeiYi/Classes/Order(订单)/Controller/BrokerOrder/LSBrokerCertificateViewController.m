//
//  LSBrokerCertificateViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/15.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSBrokerCertificateViewController.h"
#import "LSPatientOrderDetail.h"
#import "Common.h"

@interface LSBrokerCertificateViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

/** 病人姓名 */
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
/** 病人性别 */
@property (weak, nonatomic) IBOutlet UILabel *patientSexLabel;
/** 医生姓名 */
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
/** 医院名称 */
@property (weak, nonatomic) IBOutlet UILabel *visitHospitalNameLabel;
/** 就诊科室 */
@property (weak, nonatomic) IBOutlet UILabel *departmentNameLabel;
/** 就诊时间 */
@property (weak, nonatomic) IBOutlet UILabel *visitTimeLabel;
/** 选择的时间 */
@property (weak, nonatomic) IBOutlet UILabel *selectVisitTimeLabel;
/** 就诊时间选择器背景 */
@property (nonatomic, strong) UIView *pickerView;
/** 就诊时间选择器 */
@property (nonatomic, strong) UIPickerView *datePicker;
/** 就诊时间列表 */
@property (nonatomic, strong) NSArray *timeListArray;
/**
 */
@property (nonatomic, assign) BOOL isAppear;

@end

@implementation LSBrokerCertificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"提交凭证";
    
    // 设置导航条右侧按钮
    [self setUI];
    
    // 设置证书数据
    [self setCertificateData];
    
    // 请求就诊时间列表
    [self loadVisitTimeList];
}

- (void)setUI {
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(0, 0, 40, 30);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnItemAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

#pragma mark - 提交按钮事件
- (void)rightBtnItemAction {
    
    // 1. 准备请求网址
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/offer_complete",BASEURL];
    
    // 2. 创建请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:myAccount.token forKey:@"token"]; // 登陆标记
    [params setObject:self.brokerOrderDetail.order_code forKey:@"order_code"]; // ding
    [params setObject:@"请在就医时出示此凭证" forKey:@"memo"]; // 凭证描述

    
    if ([_brokerOrderDetail.order_type_str isEqualToString:@"预约专家"]) {
        
        [params setObject:[self.visitTimeLabel.text substringFromIndex:3] forKey:@"over_visit_time"]; // 取号日期
        [params setObject:@"1" forKey:@"over_exact_type"]; // 就诊具体时间1-上午 2-下午
    } else if ([_brokerOrderDetail.order_type_str isEqualToString:@"主刀医生服务"]) {
        
        [params setObject:[self.visitTimeLabel.text substringFromIndex:3] forKey:@"over_visit_time"]; // 就诊时间
        [params setObject:@"12345678910" forKey:@"over_visit_day"]; // 服务天数
    } else if ([_brokerOrderDetail.order_type_str isEqualToString:@"会诊服务"] ) {
        
        [params setObject:[self.visitTimeLabel.text substringFromIndex:3] forKey:@"over_visit_time"]; // 就诊时间
    } else if ([_brokerOrderDetail.order_type_str isEqualToString:@"病情分析会"]) {
        
        [params setObject:[self.visitTimeLabel.text substringFromIndex:3] forKey:@"over_visit_time"]; // 取号日期
        [params setObject:@"1" forKey:@"over_exact_type"]; // 取号具体时间 1.上午 2.下午
    } else {
        
        [params setObject:@"12345678910" forKey:@"over_weixin"]; // 取号日期
        [params setObject:[self.visitTimeLabel.text substringFromIndex:3] forKey:@"over_start_time"]; // 跟踪开始时间
    }

    ZZLog(@"params = %@",params);
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(id responseObj) {
        ZZLog(@"---responseObj = %@",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            // 添加遮盖
            [MBProgressHUD showSuccess:responseObj[@"message"] toView:weakSelf.view];
        }
        else {
            // 添加遮盖
            [MBProgressHUD showError:responseObj[@"message"] toView:weakSelf.view];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"--error = %@",error);
        // 隐藏遮盖
        [MBProgressHUD hideHUDForView:weakSelf.view  animated:YES];
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
    }];
}


#pragma mark - 设置证书数据
- (void)setCertificateData {
    
    // 病人姓名
    self.patientNameLabel.text = _brokerOrderDetail.human.name;
    // 病人性别
    if ([_brokerOrderDetail.human.sex isEqualToString:@"1"]) {
        
        self.patientSexLabel.text = @"性别：男";
    } else {
        
        self.patientSexLabel.text = @"性别：女";
    }
    // 医生姓名
    self.doctorNameLabel.text = [NSString stringWithFormat:@"医生：%@",_brokerOrderDetail.doctor_name];
    // 就诊医院
    self.visitHospitalNameLabel.text = [NSString stringWithFormat:@"就诊医院：%@",_brokerOrderDetail.hospital_name];
    // 就诊科室
    self.departmentNameLabel.text = [NSString stringWithFormat:@"就诊科室：%@",_brokerOrderDetail.department_name];
}

#pragma mark - 加载网络请求，获取时间列表
- (void)loadVisitTimeList {
    
    // 1. 准备请求网址
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/order_dates",BASEURL];
    
    // 2. 准备请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:_brokerOrderDetail.order_code forKey:@"order_code"];
    
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(id responseObj) {
        ZZLog(@"--responseObj = %@",responseObj);
        
        // 隐藏遮盖
        [MBProgressHUD hideHUDForView:weakSelf.view  animated:YES];
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            NSArray *temp = responseObj[@"result"];
            
            self.timeListArray = temp;
        }
        else {
            // 添加遮盖
            [MBProgressHUD showError:responseObj[@"message"] toView:weakSelf.view];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"--error = %@",error);
        // 隐藏遮盖
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
    }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return _timeListArray.count;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [_timeListArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.selectVisitTimeLabel.text = [_timeListArray objectAtIndex:row];
}

#pragma mark - 默认选中第一个


- (IBAction)selectVisitTimeBtnAction:(UIButton *)sender {
    
    [self addTimeSelecter];
}

#pragma mark - 添加时间控制器
/**
 * 添加时间控制器
 * Tag:(NSInteger)tag 0：开始时间 1：结束时间
 */
- (void)addTimeSelecter {
    
    
    // 1.添加背景视图
    
    // datePicker控制器高度和Y值
    CGFloat height = 250;
    CGFloat datePickerY = SCREEN_HEIGHT - height;
    
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height)];
    pickerView.backgroundColor = [UIColor whiteColor];
    
    if (!_isAppear) { // 判断datePicker是否出现
        [self.view addSubview:pickerView];
        self.pickerView = pickerView;
        
        [UIView animateWithDuration:0.45f animations:^{
            self.pickerView.frame = CGRectMake(0, datePickerY, SCREEN_WIDTH, height);
        } completion:^(BOOL finished) {
            _isAppear = YES;
        }];
    }
    
    // 2.添加toolBar
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ZZBtnHeight)];
    bar.barTintColor = [UIColor whiteColor];
    
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemClicked)];
    [item0 setTitleTextAttributes:@{NSForegroundColorAttributeName :
                                        ZZBaseColor} forState:UIControlStateNormal];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];// 控制距离的item
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(determineItemGetBeginTime)];
    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName :
                                        ZZBaseColor} forState:UIControlStateNormal];
    bar.items = @[item0,item1,item2];
    [pickerView addSubview:bar];
    
    CGRect frame = CGRectMake(0, ZZBtnHeight, SCREEN_WIDTH, height - 40);
    
    UIPickerView *datePicker = [[UIPickerView alloc]initWithFrame:frame];
    datePicker.backgroundColor = [UIColor whiteColor];
    // 设置pickerView的代理
    datePicker.delegate = self;
    datePicker.dataSource = self;
    [pickerView addSubview:datePicker];
    self.datePicker = datePicker;
    
    self.selectVisitTimeLabel.text = _timeListArray[0];
}

#pragma mark 点击toolBar的取消按钮
- (void)cancelItemClicked {
    
    self.selectVisitTimeLabel.text = @"";
    
    // 移除时间选择控制器
    [UIView animateWithDuration:0.45f animations:^{
        
        self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.pickerView.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            _isAppear = NO;
            [self.pickerView removeFromSuperview];
        }
    }];
}

#pragma mark 点击toolBar的确定按钮
/*
 *  点击toolBar的确定按钮
 */
- (void)determineItemGetBeginTime {
    
    self.visitTimeLabel.text = [NSString stringWithFormat:@"时间：%@",_selectVisitTimeLabel.text];
    
    // 移除时间选择控制器
    // 移除时间选择控制器
    [UIView animateWithDuration:0.45f animations:^{
        
        self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.pickerView.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            _isAppear = NO;
            [self.pickerView removeFromSuperview];
        }
    }];
    
}

#pragma mark - 懒加载
- (NSArray *)timeListArray {
    
    if (_timeListArray == nil) {
        self.timeListArray = [NSArray array];
    }
    return _timeListArray;
}


@end
