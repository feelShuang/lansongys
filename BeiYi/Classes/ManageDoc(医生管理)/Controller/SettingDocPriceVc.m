//
//  SettingDocPriceVc.m
//  BeiYi
//
//  Created by Joe on 15/12/30.
//  Copyright © 2015年 Joe. All rights reserved.
//

#import "SettingDocPriceVc.h"
#import "LSBrokerDoctor.h"
#import "OrderInfo.h"
#import "RegisteOfferController.h"
#import "Common.h"

@interface SettingDocPriceVc ()

// 第一行的textField
@property (nonatomic, strong) UITextField *txPrice1;

// 第二行的textField
@property (nonatomic, strong) UITextField *txPrice2;

// 服务数组
@property (nonatomic, strong) NSMutableArray *serviceArray;


@end

@implementation SettingDocPriceVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZZBackgroundColor;
    
    // 设置界面UI
    [self setUpUI];
    
}

- (void)setUpUI {
    
    // 2.设置导航栏右侧按钮
    UIButton *delegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delegateBtn.frame = CGRectMake(0, 0, 50, 30);
    [delegateBtn setTitle:@"删除" forState:UIControlStateNormal];
    delegateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [delegateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delegateBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [delegateBtn addTarget:self action:@selector(delegateDoctorServicePrice) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:delegateBtn];
    
    if ([self.typeNum isEqualToString:@"1"]) {
        [self addPriceUIWithRect:CGRectMake(0, 64 + 10, SCREEN_WIDTH, ZZBtnHeight) text:self.price1 title:@"基本价格"];
        [self addPriceUIWithRect:CGRectMake(0, 64 + 10 + ZZBtnHeight, SCREEN_WIDTH, ZZBtnHeight) text:self.price2 title:@"优质服务价格"];
    }
    else if ([self.typeNum isEqualToString:@"2"] || [self.typeNum isEqualToString:@"3"]) {
        [self addPriceUIWithRect:CGRectMake(0, 64 + 10, SCREEN_WIDTH, ZZBtnHeight) text:self.price1 title:@"基本价格"];
    }
    else if ([self.typeNum isEqualToString:@"4"]) {
        [self addPriceUIWithRect:CGRectMake(0, 64 + 10, SCREEN_WIDTH, ZZBtnHeight) text:self.price1 title:@"基本价格"];
    }
    else {
        [self addPriceUIWithRect:CGRectMake(0, 64 + 10, SCREEN_WIDTH, ZZBtnHeight) text:self.price1 title:@"每月服务费"];
    }
    
    // 删除按钮的显示或隐藏
    if ([self.open_flag isEqualToString:@"0"]) {
        delegateBtn.hidden = YES;
    }
    
    // 添加保存按钮
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    saveBtn.backgroundColor = [UIColor whiteColor];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveBtn setTitleColor:ZZTitleColor forState:UIControlStateNormal];
    [saveBtn setTitle:@"保   存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveDoctorServicePrice) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.typeNum isEqualToString:@"1"]) {
        saveBtn.frame = CGRectMake(0, 64 + 10 + ZZBtnHeight * 2 + 50, SCREEN_WIDTH, ZZBtnHeight);
    } else {
        saveBtn.frame = CGRectMake(0, 64 + 25 + ZZBtnHeight + 50, SCREEN_WIDTH, ZZBtnHeight);
    }
    [self.view addSubview:saveBtn];
    
    
    // 添加分割线
    if ([self.typeNum isEqualToString:@"1"]) {
        [ZZUITool linehorizontalWithPosition:CGPointMake(0, 64 + 10) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:self.view];
        [ZZUITool linehorizontalWithPosition:CGPointMake(15, 64 + 10 + ZZBtnHeight) width:SCREEN_WIDTH - 15 backGroundColor:ZZSeparateLineColor superView:self.view];
        [ZZUITool linehorizontalWithPosition:CGPointMake(0, 64 + 10 + ZZBtnHeight * 2) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:self.view];
    }
    else {
        [ZZUITool linehorizontalWithPosition:CGPointMake(0, 64 + 10) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:self.view];
        [ZZUITool linehorizontalWithPosition:CGPointMake(0, 64 + 10 + ZZBtnHeight) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:self.view];
    }
    
    
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, 0) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:saveBtn];
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, ZZBtnHeight) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:saveBtn];
}

- (void)addPriceUIWithRect:(CGRect)rect text:(NSString *)text title:(NSString *)title {
    
    // 2.1 背景-UIView
    UIView *bgView = [ZZUITool viewWithframe:rect backGroundColor:[UIColor whiteColor] superView:self.view];
    
    
    // 2.2 提示图片-UIImageView
    CGFloat labelX = 15;
    CGFloat labelY = labelX;
    CGFloat labelH = ZZBtnHeight -labelY*2;
    
    // 2.3 提示文字-UILabel
    UILabel *lblTips = [ZZUITool labelWithframe:CGRectMake(labelX, labelY, SCREEN_WIDTH/3, labelH) Text:title textColor:[UIColor blackColor] fontSize:15 superView:bgView];
    
    // 2.4 输入金额-UITextField
    CGFloat txPriceX = CGRectGetMaxX(lblTips.frame)+ZZMarins;
    CGFloat txPriceW = SCREEN_WIDTH - txPriceX -ZZMarins;
    UITextField *txPrice = [ZZUITool textFieldWithframe:CGRectMake(txPriceX, labelY, txPriceW, labelH) text:text fontSize:14 placeholder:@"请输入金额" backgroundColor:[UIColor whiteColor] superView:bgView];
    txPrice.keyboardType = UIKeyboardTypeNumberPad;
    txPrice.textAlignment = NSTextAlignmentRight;
    if ([title isEqualToString:@"基本价格"] || [title isEqualToString:@"每月服务费"]) {
        self.txPrice1 = txPrice;
    }
    else {
        self.txPrice2 = txPrice;
    }
}

#pragma mark - 监听右侧删除按钮点击
- (void)delegateDoctorServicePrice {
    
    [self aletViewDeleteServiceWithServiceType:_typeNum];
}

#pragma mark - 删除医生服务提示
- (void)aletViewDeleteServiceWithServiceType:(NSString *)service_type {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否删除该服务？" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteDoctorServiceWithServiceType:service_type];
    }];
    UIAlertAction *canlceAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:canlceAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 删除服务
- (void)deleteDoctorServiceWithServiceType:(NSString *)service_type {
    
    // 1. 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/offer/delete_service",BASEURL];
    
    // 2. 创建请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:service_type forKey:@"service_type"];
    [params setObject:_doctor.doctor_id forKey:@"doctor_id"];
    
    // 3. 请求
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(id responseObj) {
        ZZLog(@"responseObj = %@",responseObj);
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:responseObj[@"message"] toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 保存按钮 监听
- (void)saveDoctorServicePrice {
    ZZLog(@"---%@",self.txPrice1.text);
    
    // 1.判断输入的字符是不是数字，如果不是，弹框提示
    if (!self.txPrice1.text.length) {
        [MBProgressHUD showError:@"请输入价格!"];
        
    } // 不用判断是否为纯数字，以为键盘格式只能输入纯数字
    else if ([self.txPrice1.text floatValue] == 0.f){// 输入价格为0
        ZZLog(@"--纯数字！--输入价格为0");
        [MBProgressHUD showError:@"价格必须大于0"];
        
    }
    else {
        ZZLog(@"--纯数字！--%@",self.txPrice1.text);
        if (_controllerID == 10) {
            [self loadHospitalHttpRequest];
        }
        else {
            [self loadHTTPRequest];
        }
    }
    
    
}

- (void)loadHTTPRequest {
    /*
     服务类型数据字典 1-预约专家 2-主刀医生服务价格 3-会诊服务4-病情分析会5-离院跟踪服务6-服务担保7-差旅费
     
     "services": [{
     "price": "300",
     "type": "1"
     },
     {
     "price": "100",
     "type": "6"
     }]
     */
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/offer/set_doctor",BASEURL];
    
    NSMutableDictionary *servicesDict1 = [NSMutableDictionary dictionary];
    NSMutableDictionary *servicesDict2 = [NSMutableDictionary dictionary];
    
    [self.serviceArray removeAllObjects];
    
    if ([self.typeNum isEqualToString:@"1"]) {
        [servicesDict1 setObject:self.typeNum forKey:@"type"];
        [servicesDict1 setObject:self.txPrice1.text forKey:@"price"];
        [self.serviceArray addObject:servicesDict1];
        
        [servicesDict2 setObject:@"6" forKey:@"type"];
        if (self.txPrice2.text.length) {
            [servicesDict2 setObject:self.txPrice2.text forKey:@"price"];
        } else {
            [servicesDict2 setObject:@"0" forKey:@"price"];
        }
        [self.serviceArray addObject:servicesDict2];
    } else {
        [servicesDict1 setObject:self.typeNum forKey:@"type"];
        [servicesDict1 setObject:self.txPrice1.text forKey:@"price"];
        [self.serviceArray addObject:servicesDict1];
    }
    
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:_doctor.hospital_id forKey:@"hospital_id"]; // 医院ID
    [params setObject:_doctor.department_id forKey:@"department_id"]; // 科室ID
    [params setObject:_doctor.doctor_id forKey:@"doctor_id"]; // 医生ID
    [params setObject:self.serviceArray forKey:@"services"];
    
    ZZLog(@"---params = %@",params);
    __weak typeof(self) weakSelf = self;
    
    // 2.发送网络请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"~~~responseObj = %@~~~",responseObj);
        
        [OrderInfo shareInstance].isUpLoading = YES;
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {// 如果操作成功
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            });
            
        }else {
            [MBProgressHUD showError:@"发生未知错误."];
            
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"~~~error = %@~~~",error);
        
    }];
}

#pragma mark - 设置医院价格
- (void)loadHospitalHttpRequest {
    
    // 1. 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/offer/set_hospital",BASEURL];
    
    // 2. 准备请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:self.hospital_id forKey:@"hospital_id"];
    [params setObject:self.txPrice1.text forKey:@"price"];
    
    // 3. 网络请求
    [ZZHTTPTool post:urlStr params:params success:^(id responseObj) {
        ZZLog(@"responseObj = %@",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 判断是不是纯数字
/**
 *  判断是不是纯数字
 */
- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)serviceArray {
    if (_serviceArray == nil) {
        self.serviceArray = [NSMutableArray array];
    }
    return _serviceArray;
}

#pragma mark - 拦截背景触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
