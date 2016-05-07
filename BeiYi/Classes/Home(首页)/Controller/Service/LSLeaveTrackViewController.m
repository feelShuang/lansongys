//
//  LSLeaveTrackViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/3/30.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSLeaveTrackViewController.h"
#import "LSPatientHomeController.h"
#import "LSPatientOrderInfoViewController.h"
#import "LSManagePatientViewController.h"
#import "LSFamousDoctorViewController.h"
#import "LSDoctorDetailViewController.h"
#import "LSDoctorDetail.h"
#import "OrderInfo.h"
#import "UIBarButtonItem+Extension.h"
#import <UIImageView+WebCache.h>
#import "Common.h"

@interface LSLeaveTrackViewController ()<LSManagePatientDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

/** content topLayout */
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
/** 选择医生提示Label */
@property (weak, nonatomic) IBOutlet UILabel *selectDoctorLabel;
/** 右箭头 */
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightArrowTrailLayout;


/*------------------------Time View-------------------------*/
/** 服务周期选择器 */
@property (nonatomic, strong) UIPickerView *monthPicker;
/** 服务周期 */
@property (weak, nonatomic) IBOutlet UILabel *servicePeriodLabel;
/** 出院时间 */
@property (weak, nonatomic) IBOutlet UILabel *overTimeLabel;
/** 病历号 */
@property (weak, nonatomic) IBOutlet UITextField *patientNumTextField;


/*------------------------Visit person View-------------------------*/
@property (weak, nonatomic) IBOutlet UILabel *visitPersonNameLabel;


/*------------------------Contact View-------------------------*/
@property (weak, nonatomic) IBOutlet UIView *contactBgView;
// 联系人姓名
@property (weak, nonatomic) IBOutlet UITextField *contactNameTextField;
// 联系人号码
@property (weak, nonatomic) IBOutlet UITextField *contactPhoneNumTextField;


/*------------------------Price View-------------------------*/
// 服务价格
@property (weak, nonatomic) IBOutlet UILabel *servicePriceLabel;


/*------------------------Pay View-------------------------*/
@property (weak, nonatomic) IBOutlet UILabel *payPriceLabel;



/*------------------------UIView 时间选择控制器的背景视图-------------------------*/
/** 时间选择picker */
@property (nonatomic, strong) UIDatePicker *datePicker;
/** 月份选择picker */
@property (nonatomic, strong) UIView *pickerView;

@property (nonatomic, assign) NSString *timeStr;
@property (nonatomic, assign) BOOL isAppear;

/** 拦截touch的按钮 */
@property (nonatomic, strong) UIButton *touchView;

@end

@implementation LSLeaveTrackViewController

{
    CGFloat _curTextFieldToBottom;   // 输入框当前的高度
    CGFloat _offset;     // 偏移量
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"预约离院跟踪";
    
    // 注册通知
    [self registerNotification];
    
    // 从名医选项卡和名医推荐列表（仅需一次判断就可以）
    if ([self.navigationController.viewControllers[1] isKindOfClass:[LSDoctorDetailViewController class]]) {
        // 直接设置医生数据
        [self setDoctorDetailData];
        // 获取价格
        [self getPrice];
    }
    
    // 设置UI
    [self setUI];
    
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
            // 获取价格
            [self getPrice];
            
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
    
    if (textField == _patientNumTextField) {
        _curTextFieldToBottom = SCREEN_HEIGHT - 64 - (self.contactBgView.y - 44 - 20);
    } else if (textField == _contactNameTextField) {
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

#pragma mark - 按钮事件 监听
- (IBAction)btnClickedAction:(UIButton *)sender {
    
    if (sender.tag == 599) {
        
        if ([self.navigationController.viewControllers[0] isKindOfClass:[LSPatientHomeController class]] && self.buttonPush) {
            LSFamousDoctorViewController *famousDocVC = [LSFamousDoctorViewController new];
            famousDocVC.order_type = @"5";
            [self.navigationController pushViewController:famousDocVC animated:YES];
        }
    } else if (sender.tag == 600) {
        [self addTimeSelecterWithTag:0];
    } else if (sender.tag == 601) {
        [self addTimeSelecterWithTag:1];
    } else {
        LSManagePatientViewController *manageVC = [LSManagePatientViewController new];
        manageVC.delegate = self;
        [self.navigationController pushViewController:manageVC animated:YES];
    }
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
    
    NSString *orderType = nil;
    if ([[OrderInfo shareInstance].service_type isEqualToString:@"0"]) {
        orderType = self.order_type;
    } else {
        orderType = [OrderInfo shareInstance].service_type;
    }
    [params setObject:orderType forKey:@"order_type"];// 订单类型
    
    
    // 3. 发送post请求
    __weak typeof(self) weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"--getPrise--%@",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            
            self.servicePriceLabel.text = [NSString stringWithFormat:@"￥%@",responseObj[@"result"][@"price"]];
            self.payPriceLabel.text = [NSString stringWithFormat:@"￥%@",responseObj[@"result"][@"price"]];
        }
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"发生错误，请重试。" toView:weakSelf.view];
        ZZLog(@"~~~%@~~~",error);
        
    }];
}

#pragma mark - Did End ON Edit
- (IBAction)textFieldReturnEditing:(UITextField *)sender {
    
    [sender resignFirstResponder];
}

#pragma mark - 预约按钮 监听
- (IBAction)appointCommit:(UIButton *)sender {
    

    if (self.servicePeriodLabel.text.length == 0) {
        [MBProgressHUD showError:@"请选择服务周期"];
        return;
    }
    if (self.overTimeLabel.text.length == 0) {
        [MBProgressHUD showError:@"请选择出院时间"];
        return;
    }
    if (self.patientNumTextField.text.length == 0) {
        [MBProgressHUD showError:@"请填写病例号"];
        return;
    }
    if (self.visitPersonNameLabel.text.length == 0) {
        [MBProgressHUD showError:@"请选择就诊人"];
        return;
    }
//    if (self.contactNameTextField.text.length == 0) {
//        [MBProgressHUD showError:@"请填写联系人姓名"];
//        return;
//    }
//    if (self.contactPhoneNumTextField.text.length == 0) {
//        [MBProgressHUD showError:@"请填写联系人手机号码"];
//        return;
//    }
    
    // 加载网络请求
    [self loadHttpRequest];
}

#pragma mark - 加载网络请求--提交订单
- (void)loadHttpRequest {
    // 1.显示遮盖
    [MBProgressHUD showMessage:@"请稍后..."];
    
    // 2.发送网络请求
    NSString *urlStr = [[NSString alloc] init];
    NSDictionary *params = [NSDictionary dictionary];
    
    // 判断是那种服务类型
    
    urlStr = [NSString stringWithFormat:@"%@/uc/order/create_out_hospital",BASEURL];
    params = [self setLeaveTrackRequestBody];
    
    
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

#pragma mark - 设置离院跟踪服务请求体
- (NSDictionary *)setLeaveTrackRequestBody {
    // 2.1准备参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:myAccount.token forKey:@"token"]; // 1.登录token
    [params setObject:_doctorInfo.hospital_id forKey:@"hospital_id"]; // 2.医院ID
    [params setObject:_doctorInfo.department_id forKey:@"department_id"]; // 3.科室ID
    [params setObject:_doctorInfo.hospital_name forKey:@"hospital_name"]; // 4.医院名称
    [params setObject:_doctorInfo.department_name forKey:@"department_name"]; // 5.科室名称
    [params setObject:_doctorInfo.doctor_id forKey:@"doctor_id"]; // 6.医生ID
    [params setObject:_doctorInfo.name forKey:@"doctor_name"]; // 7.医生名称
    [params setObject:[OrderInfo shareInstance].patient_id forKey:@"visit_human_id"]; // 8.就诊人ID
    [params setObject:self.patientNumTextField.text forKey:@"record_number"]; // 9.病案号
    [params setObject:self.overTimeLabel.text forKey:@"out_hospital_time"]; // 10.出院时间
    NSString *servicePeriod = @"";
    if (self.servicePeriodLabel.text.length == 3) {
        NSRange range = NSMakeRange(0,1);
        servicePeriod = [self.servicePeriodLabel.text substringWithRange:range];
    } else {
        NSRange range = NSMakeRange(0, 2);
        servicePeriod = [self.servicePeriodLabel.text substringWithRange:range];
    }
    [params setObject:servicePeriod forKey:@"month_number"]; // 11.购买月数
    [params setObject:[self.servicePriceLabel.text substringFromIndex:1] forKey:@"init_month_price"]; // 12.月费
    
    ZZLog(@"params = %@",params);
    
    return params;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 12;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [NSString stringWithFormat:@"%ld个月",row + 1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.servicePeriodLabel.text = [NSString stringWithFormat:@"%ld个月",row + 1];
}

#pragma mark - manageDelegate
- (void)passPatientName:(NSString *)name {
    self.visitPersonNameLabel.text = name;
}

#pragma mark - 添加时间控制器
/**
 * 添加时间控制器
 * Tag:(NSInteger)tag 0：开始时间 1：结束时间
 */
- (void)addTimeSelecterWithTag:(NSInteger)tag {
    
    
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
    
    SEL cancle;
    if (tag == 0) {
        cancle = @selector(cancelBtnAction);
    } else {
        cancle = @selector(cancelItemClicked);
    }
    
    // 2.添加toolBar
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ZZBtnHeight)];
    bar.barTintColor = [UIColor whiteColor];
    
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:cancle];
    [item0 setTitleTextAttributes:@{NSForegroundColorAttributeName :
                                        ZZBaseColor} forState:UIControlStateNormal];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];// 控制距离的item
    
    
    SEL selector;
    if (tag == 0) {
        selector = @selector(determineItemGetBeginTime);
    }else {
        selector = @selector(determineItemGetEndTime);
    }
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:selector];
    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName :
                                        ZZBaseColor} forState:UIControlStateNormal];
    bar.items = @[item0,item1,item2];
    [pickerView addSubview:bar];
    
    CGRect frame = CGRectMake(0, ZZBtnHeight, SCREEN_WIDTH, height - 40);
    
    if (tag == 0) {
        UIPickerView *monthPicker = [[UIPickerView alloc]initWithFrame:frame];
        monthPicker.backgroundColor = [UIColor whiteColor];
        // 设置pickerView的代理
        monthPicker.delegate = self;
        monthPicker.dataSource = self;
        [pickerView addSubview:monthPicker];
        self.monthPicker = monthPicker;
        // 需要给textField赋初值
        self.servicePeriodLabel.text = @"1个月";
        
    } else {
        // 3.添加时间选择器
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:frame];
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:OneDay];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        [pickerView addSubview:datePicker];
        self.datePicker = datePicker;
    }
}

#pragma mark 点击toolBar的取消按钮
- (void)cancelBtnAction {
    
    self.servicePeriodLabel.text = @"";
    // 移除时间选择控制器
    [self cancelItemClicked];
}

- (void)cancelItemClicked {
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
 ** tag 0：开始时间 1：结束时间
 */
- (void)determineItemGetBeginTime {

    
    // 移除时间选择控制器
    [self cancelItemClicked];
    
}

- (void)determineItemGetEndTime {
    // 1、显示时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.overTimeLabel.text = [formatter stringFromDate:self.datePicker.date];
    
    // 2、移除时间选择控制器
    [self cancelItemClicked];
    
}

#pragma mark 时间改变
- (void) dateChange:(UIDatePicker *)picker{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    self.timeStr = [dateFormat stringFromDate:picker.date];
}

- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
