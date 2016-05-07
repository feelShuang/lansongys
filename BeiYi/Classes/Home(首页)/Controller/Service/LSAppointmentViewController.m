//
//  LSAppointmentViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/3/28.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#define BASETAG 200

#import "LSAppointmentViewController.h"
#import "LSTimeSelectViewController.h"
#import "LSPatientOrderInfoViewController.h"
#import "LSManagePatientViewController.h"
#import "LSPatientHomeController.h"
#import "LSFamousDoctorViewController.h"
#import "LSDoctorDetailViewController.h"
#import "LSDoctorDetail.h"
#import "OrderInfo.h"
#import "Service.h"
#import "UIBarButtonItem+Extension.h"
#import <UIImageView+WebCache.h>
#import "Common.h"

@interface LSAppointmentViewController ()<LSManagePatientDelegate,LSTimeSelectDelegate,UITextFieldDelegate>

// contentView  topLayout
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTopLayout;

/*------------------------医生详情-------------------------*/
/** 医生头像 */
@property (weak, nonatomic) IBOutlet UIImageView *doctorHeadImageView;
/** 医生姓名 */
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
/** 医生级别 */
@property (weak, nonatomic) IBOutlet UILabel *doctorLevelLabel;
/** 医生所属医院 */
@property (weak, nonatomic) IBOutlet UILabel *doctorHospitalLabel;
/** 就诊人数 */
@property (weak, nonatomic) IBOutlet UILabel *visitNumLabel;
/** 选择医生Label */
@property (weak, nonatomic) IBOutlet UILabel *selectDoctorLabel;
/** 右箭头 */
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightArrowTrailLayout;


/*------------------------Time View-------------------------*/
/** 预约时间 */
@property (weak, nonatomic) IBOutlet UILabel *appointTimeLabel;
/** 优质服务价格 */
@property (weak, nonatomic) IBOutlet UILabel *qualityServicePriceLabel;
/** 优质服务按钮 */
@property (weak, nonatomic) IBOutlet UIButton *qualityServiceButton;

/*------------------------Visit person View-------------------------*/
@property (weak, nonatomic) IBOutlet UILabel *visitPersonNameLabel;

/*------------------------Contact View-------------------------*/

@property (weak, nonatomic) IBOutlet UIView *contactBgView;
/** 联系人姓名 */
@property (weak, nonatomic) IBOutlet UITextField *contactNameTextField;
/** 联系人号码 */
@property (weak, nonatomic) IBOutlet UITextField *contactPhoneNumTextField;


/*------------------------Price View-------------------------*/
/** 基本服务价格 */
@property (weak, nonatomic) IBOutlet UILabel *servicePriceLabel;


/*------------------------Pay View-------------------------*/
/** 需要支付的价格 */
@property (weak, nonatomic) IBOutlet UILabel *payPriceLabel;

/** 预约时间数组 */
@property (nonatomic, strong) NSArray *timeArray;
/** 订单类型 */
@property (nonatomic, copy) NSString *orderType;

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, copy) NSString *basePrice;
@property (nonatomic, copy) NSString *attach_price;

/** 拦截touch的按钮 */
@property (nonatomic, strong) UIButton *touchView;

@end

@implementation LSAppointmentViewController

{
    CGFloat _curTextFieldToBottom;   // 输入框当前的高度
    CGFloat _offset;     // 偏移量
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"预约专家";
    
    // 注册通知
    [self registerNotification];
    
    // 设置UI
    [self setUI];
    
    // 从名医选项卡和名医推荐列表（仅需一次判断就可以）
    if ([self.navigationController.viewControllers[1] isKindOfClass:[LSDoctorDetailViewController class]]) {
        // 直接设置医生数据
        [self setDoctorDetailData];
        // 直接检查是否能够提供优质服务，并默认选中
        [self selectQualityService];
    }
    
    // 获取个人信息
    [self getUserInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 从首页按钮进入
    if (_buttonPush) {
        
        self.doctorInfo = [OrderInfo shareInstance].doctorInfo;
        self.selectDoctorLabel.text = @"选择医生";
        
        // 选择完医生后获取能否提供优质服务
        if ([OrderInfo shareInstance].doctorInfo != nil) {
            
            self.selectDoctorLabel.text = @"";
            // 直接设置医生数据
            [self setDoctorDetailData];
            // 直接检查是否能够提供优质服务，并默认选中
            [self selectQualityService];
            // 设置赞分数
            [self priseScore];
        }
    } else {
        self.selectDoctorLabel.text = @"";
        // 设置赞分数
        [self priseScore];
    }
    
    // 设置statusBar的字体颜色 为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 设置navigationBar的颜色
    [self.navigationController.navigationBar setBarTintColor:ZZBaseColor];
}

#pragma mark - 设置赞分数
- (void)priseScore {
    
    // 赞分数
    for (int i = 1; i <= 5; i ++) {
        UIImageView *imgView = [self.view viewWithTag:i];
        imgView.image = [UIImage imageNamed:@"zan_mo_ren"];
    }
    
    NSInteger zanTag = [self.doctorInfo.avg_score integerValue];
    for (int i = 1; i <= zanTag; i ++) {
        UIImageView *imgView = [self.view viewWithTag:i];
        imgView.image = [UIImage imageNamed:@"zan_xuan_zhong"];
    }
    
    CGFloat score = [self.doctorInfo.avg_score floatValue];
    NSInteger score_point = [[[NSString stringWithFormat:@"%.1f",score] substringFromIndex:2] integerValue];
    
    if (score_point > 0) {
        UIImageView *imageV = [self.view viewWithTag:zanTag + 1];
        if (score_point <= 5) {
            imageV.image = [UIImage imageNamed:@"zan_banxin"];
        }
        if (score_point > 5) {
            imageV.image = [UIImage imageNamed:@"zan_xuan_zhong"];
        }
    }
}

#pragma mark - 注册键盘 弹出/隐藏 通知
- (void)registerNotification {
    
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden)
                                                 name:UIKeyboardDidHideNotification object:nil];
}

// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification {
    UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    touchBtn.frame = [UIScreen mainScreen].bounds;
    [touchBtn addTarget:self action:@selector(keyboardDisAppear) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:touchBtn];
    self.touchView = touchBtn;
    
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    _offset = _curTextFieldToBottom - keyboardHeight;
    
    if (_offset < 0) {
        self.contentTopLayout.constant = _offset;
    }
    
}

- (void)keyboardDisAppear {
    
    [self.view endEditing:YES];
}

//键盘消失时
-(void)keyboardDidHidden {
    [self.touchView removeFromSuperview];
    if (_offset < 0) {
        self.contentTopLayout.constant = 0;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == _contactNameTextField) {
        _curTextFieldToBottom = SCREEN_HEIGHT - 64 - (self.contactBgView.y + 44);
    } else {
        _curTextFieldToBottom = SCREEN_HEIGHT - 64 - (self.contactBgView.y + 88);
    }
}
                                           
#pragma mark - 设置UI
- (void)setUI {
    
    // 重写navigation返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:nil target:self action:@selector(leftBtnClicked)];
    
    // 医生头像
    self.doctorHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.doctorHeadImageView.layer.cornerRadius = self.doctorHeadImageView.height / 2;
    self.doctorHeadImageView.layer.masksToBounds = YES;
    
    // 设置医生右箭头的显示隐藏
    if (([self.navigationController.viewControllers[0] isKindOfClass:[LSFamousDoctorViewController class]] || [self.navigationController.viewControllers[0] isKindOfClass:[LSPatientHomeController class]]) && !self.buttonPush) {
        [self.rightArrowImageView setImage:nil];
        self.rightArrowTrailLayout.constant = 0;
    }
}

#pragma mark - 监听导航栏左侧按钮点击
- (void)leftBtnClicked {
    
    // 点击返回按钮将订单对象置空
    [OrderInfo shareInstance].doctorInfo = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取个人信息
- (void)getUserInfo {
    
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/my",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];
    
    // 2.发送请求
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"确认%@成功",responseObj);

        if (![responseObj[@"result"][@"realname"] isKindOfClass:[NSNull class]]) {
            weakSelf.contactNameTextField.text = responseObj[@"result"][@"realname"];
        }
        weakSelf.contactPhoneNumTextField.text = responseObj[@"result"][@"mobile"];
    } failure:^(NSError *error) {
        ZZLog(@"确认%@成功",error);
    }];
}

#pragma mark - 设置医生详情页面数据
- (void)setDoctorDetailData {
    
    /** 医生简介 */
    // 头像
    [self.doctorHeadImageView sd_setImageWithURL:[NSURL URLWithString:_doctorInfo.avator] placeholderImage:[UIImage imageNamed:@"personal_tou_xiang"]];
    // 名字
    self.doctorNameLabel.text = _doctorInfo.name;
    // 级别
    NSString *levelStr = [[NSString alloc] init];
    switch ([_doctorInfo.level integerValue]) {
        case 1:
            levelStr = @"医师";
            break;
        case 2:
            levelStr = @"主治医师";
            break;
        case 3:
            levelStr = @"副主任医师";
            break;
        case 4:
            levelStr = @"主任医师";
            break;
    }
    self.doctorLevelLabel.text = levelStr;
    // 就诊人数
    self.visitNumLabel.text = [NSString stringWithFormat:@"%@人就诊",_doctorInfo.visit_count];
    // 所属医院
    self.doctorHospitalLabel.text = [NSString stringWithFormat:@"%@  %@",_doctorInfo.hospital_name,_doctorInfo.department_name];
}

#pragma mark - 优质服务按钮监听
- (IBAction)goodServiceBtnAction:(UIButton *)sender {
    
    if ([OrderInfo shareInstance].assure_flag) {
        
        [self.qualityServiceButton setImage:[UIImage imageNamed:@"service_zhuan_jia1"] forState:UIControlStateNormal];
    } else {
        [self.qualityServiceButton setImage:[UIImage imageNamed:@"service_zhuan_jia"] forState:UIControlStateNormal];
    }
    [OrderInfo shareInstance].assure_flag = ![OrderInfo shareInstance].assure_flag;
    ZZLog(@"%d",[OrderInfo shareInstance].assure_flag);
}

#pragma mark - 按钮事件 监听
- (IBAction)btnClickAction:(UIButton *)sender {
    
    if (sender.tag == 199) {
        if ([self.navigationController.viewControllers[0] isKindOfClass:[LSPatientHomeController class]] && self.buttonPush) {
            LSFamousDoctorViewController *famousDocVC = [LSFamousDoctorViewController new];
            famousDocVC.order_type = @"1";
            [self.navigationController pushViewController:famousDocVC animated:YES];
        }
    } else if (sender.tag == 200) {
        LSTimeSelectViewController *timeSelectVC = [LSTimeSelectViewController new];
        timeSelectVC.delegate = self;
        [self.navigationController pushViewController:timeSelectVC animated:YES];
    } else {
        LSManagePatientViewController *manageVC = [LSManagePatientViewController new];
        manageVC.delegate = self;
        [self.navigationController pushViewController:manageVC animated:YES];
    }
}

#pragma mark - 检查医生是否能够提供优质服务
- (void)selectQualityService {
    
    for (Service *service in _doctorInfo.services) {
        
        if ([service.service_type isEqualToString:@"1"] && [service.open_flag isEqualToString:@"3"]) {
            // 默认选中提供优质服务
            // 单例传值
            [OrderInfo shareInstance].assure_flag = YES;
            
            // 设置按钮图片
            [self.qualityServiceButton setImage:[UIImage imageNamed:@"service_zhuan_jia"] forState:UIControlStateNormal];
            
            // 获取价格
            [self getPrice];
        } else {
            // 获取价格
            [self getPrice];
        }
    }
}

#pragma mark - 添加是否选择15分钟优质服务的提醒
- (void)addAlertView {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"保证提供15分钟的优质服务" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self)weakSelf = self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 单例传值
        [OrderInfo shareInstance].assure_flag = YES;
        
        // 设置按钮图片
        [weakSelf.qualityServiceButton setImage:[UIImage imageNamed:@"service_zhuan_jia"] forState:UIControlStateNormal];
        
        // 获取价格
        [self getPrice];
        ZZLog(@"点击了是按钮");
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 单例传值
        [OrderInfo shareInstance].assure_flag = NO;
        
        // 获取价格
        [self getPrice];
        ZZLog(@"点击了否按钮");
    }];
    [alert addAction:okAction];
    [alert addAction:cancleAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - 获取价格
- (void)getPrice {
    
    // 1. 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/init_price",BASEURL];// 获取订单价格
    
    // 2. 创建请求体
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"]; // 1.登陆token
    [params setObject:_doctorInfo.doctor_id forKey:@"doctor_id"]; // 医生ID
    [params setObject:_doctorInfo.hospital_id forKey:@"hospital_id"];// 医院ID
    if ([[OrderInfo shareInstance].service_type isEqualToString:@"0"]) {
        self.orderType = _order_type;
    } else {
        self.orderType = [OrderInfo shareInstance].service_type;
    }
    [params setObject:_orderType forKey:@"order_type"];// 订单类型
    [params setObject:[NSString stringWithFormat:@"%d",[OrderInfo shareInstance].assure_flag]  forKey:@"flag"]; // 是否提供优质服务
    
    ZZLog(@"%@",params);
    
    // 3. 发送post请求
    __weak typeof(self) weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        
        ZZLog(@">_> LookHere>>>>%d,%s,\nresponseObj = %@<<<<<<",__LINE__,__func__,responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            self.basePrice = responseObj[@"result"][@"price"];
            // 如果字段值对应的值为<null>,
            if ([responseObj[@"result"][@"attach_price"] isKindOfClass:[NSNull class]]) {
                
                self.attach_price = @"0";
            } else {
                
                self.attach_price = responseObj[@"result"][@"attach_price"];
            }
            
            // 设置优质服务价格
            self.qualityServicePriceLabel.text = [NSString stringWithFormat:@"￥%@",_attach_price];
            // 设置基本价格
            self.servicePriceLabel.text = [NSString stringWithFormat:@"￥%@",_basePrice];
            // 设置需要支付的价格
            CGFloat servicePrice = [_basePrice integerValue] + [_attach_price integerValue];
            self.payPriceLabel.text = [NSString stringWithFormat:@"￥%.0f",servicePrice];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:@"发生错误，请重试。" toView:weakSelf.view];
        ZZLog(@"~~~%@~~~",error);
        
    }];
}

#pragma mark - Did End ON Exit
- (IBAction)textFieldReturnEditing:(UITextField *)sender {
    
    [sender resignFirstResponder];
}

#pragma mark - 提交订单
- (IBAction)commitAppoint:(UIButton *)sender {
    
    ZZLog(@">_> Look>>>>>>%d,%s,点击了提交订单按钮<<<<<<",__LINE__,__func__);
    
    if (self.appointTimeLabel.text.length == 0) {
        [MBProgressHUD showError:@"请选择预约时间"];
        return;
    }
    if (self.visitPersonNameLabel.text.length == 0) {
        [MBProgressHUD showError:@"请选择就诊人"];
        return;
    }
    if (self.contactNameTextField.text.length == 0) {
        [MBProgressHUD showError:@"请填写联系人姓名"];
        return;
    }
    if (self.contactPhoneNumTextField.text.length == 0) {
        [MBProgressHUD showError:@"请填写联系人手机号码"];
        return;
    }
    // 加载网络请求
    [self loadHttpRequest];
}

#pragma mark - 加载网络请求--提交订单
- (void)loadHttpRequest {
    
    // 2.发送网络请求
    NSString *urlStr = [[NSString alloc] init];
    NSDictionary *params = [NSDictionary dictionary];
    
    urlStr = [NSString stringWithFormat:@"%@/uc/order/create_reg",BASEURL];
    params = [self setAppiontmentRequestBody];
    
    __weak typeof(self) weakSelf = self;
    // 2.2发送post请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"提交订单---%@",responseObj);
        
        // 隐藏遮盖
        [MBProgressHUD hideHUD];
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"订单提交成功"];
            [OrderInfo shareInstance].doctor_name = nil;// 清空所选医生
            LSPatientOrderInfoViewController *orderInfoVC = [[LSPatientOrderInfoViewController alloc] init];
            orderInfoVC.order_code = responseObj[@"result"][@"order_code"];
            [weakSelf.navigationController pushViewController:orderInfoVC animated:YES];
            
            // 提交成功刷新标志开启
            [OrderInfo shareInstance].isUpLoading = YES;
            
        }else {
            [MBProgressHUD showError:@"发生异常，请重试"];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"发布订单---%@",error);
        
        // 隐藏遮盖
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"发生错误，请重试"];
    }];
}

#pragma mark - 设置预约专家的请求体
- (NSDictionary *)setAppiontmentRequestBody {
    
    // 2.1准备参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:myAccount.token forKey:@"token"]; // 1.登录token
    [params setObject:self.timeArray.firstObject forKey:@"visit_start_time"]; // 2.就诊开始时间
    [params setObject:self.timeArray.lastObject forKey:@"visit_end_time"]; // 3.就诊截至时间
    [params setObject:_doctorInfo.hospital_id forKey:@"hospital_id"]; // 4.医院ID
    [params setObject:_doctorInfo.department_id forKey:@"department_id"]; // 5.科室ID
    [params setObject:_doctorInfo.hospital_name forKey:@"hospital_name"]; // 6.医院名称
    [params setObject:_doctorInfo.department_name forKey:@"department_name"]; // 7.科室名称
    [params setObject:_doctorInfo.doctor_id forKey:@"doctor_id"]; // 8.医生ID
    [params setObject:_doctorInfo.name forKey:@"doctor_name"]; // 9.医生名称
    [params setObject:[OrderInfo shareInstance].patient_id forKey:@"visit_human_id"]; // 10.就诊人ID
    [params setObject:self.basePrice forKey:@"init_service_price"]; // 11.单服务价格
    [params setObject:[NSString stringWithFormat:@"%d",[OrderInfo shareInstance].assure_flag] forKey:@"assure_flag"]; // 12.是否使用担保服务
    [params setObject:self.attach_price forKey:@"init_assure_price"]; // 13.担保服务价格
    [params setObject:self.contactNameTextField.text forKey:@"link_name"]; // 14.联系人姓名
    [params setObject:self.contactPhoneNumTextField.text forKey:@"link_mobile"]; // 15.联系人电话
    ZZLog(@"%@",[NSNumber numberWithBool:[OrderInfo shareInstance].assure_flag]);
    ZZLog(@">_> Look>>>>>>%d,%s,\n%@<<<<<<",__LINE__,__func__,params);
    return params;
}

#pragma mark - LSTimeSelectDelegate
- (void)timeSelect:(LSTimeSelectViewController *)timeSelect selectTimeWithTimeArray:(NSArray *)timeArray {
    
    self.timeArray = timeArray;
    self.appointTimeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",timeArray.firstObject,timeArray.lastObject];
}

#pragma mark - manageDelegate
- (void)passPatientName:(NSString *)name {
    self.visitPersonNameLabel.text = name;
}

- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
