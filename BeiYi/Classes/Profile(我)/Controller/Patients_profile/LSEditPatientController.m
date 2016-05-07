//
//  LSEditPatientController.m
//  BeiYi
//
//  Created by LiuShuang on 15/6/16.
//  Copyright (c) 2015年 LiuShuang. All rights reserved.
//

#import "LSEditPatientController.h"
#import "Common.h"

@interface LSEditPatientController ()<UITextFieldDelegate>
/** 性别标记:1男 2女 */
@property (nonatomic, assign) int sex;
/** 就诊人姓名 */
@property (weak, nonatomic) IBOutlet UITextField *patientNameTextField;
/** 就诊人身份证 */
@property (weak, nonatomic) IBOutlet UITextField *patientIDCodeTextField;
/** 就诊人性别按钮 */
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womenButton;
/** 就诊人手机号 */
@property (weak, nonatomic) IBOutlet UITextField *patientMobileTextField;

/** 拦截touch的按钮 */
@property (nonatomic, strong) UIButton *touchView;

@end

@implementation LSEditPatientController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册通知
    [self registerNotification];
    
    // 界面布局
    [self setupUI];
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
}

- (void)keyboardDisAppear {
    
    [self.view endEditing:YES];
}

//键盘消失时
-(void)keyboardDidHidden {
    [self.touchView removeFromSuperview];
}

#pragma mark - 界面布局
- (void)setupUI {
    
    // 2.设置患者数据
    // 患者姓名
    self.patientNameTextField.text = _patient.name;
    // 患者身份证号
    self.patientIDCodeTextField.text = _patient.id_card;
    // 按钮图片
    if ([_patient.sex isEqualToString:@"1"]) { // 男
        
        [self.manButton setImage:[UIImage imageNamed:@"service_xuan_ze"] forState:UIControlStateNormal];
        [self.womenButton setImage:[UIImage imageNamed:@"service_mo_ren"] forState:UIControlStateNormal];
        self.sex = 1;
    } else { // 女
        
        [self.manButton setImage:[UIImage imageNamed:@"service_mo_ren"] forState:UIControlStateNormal];
        [self.womenButton setImage:[UIImage imageNamed:@"service_xuan_ze"] forState:UIControlStateNormal];
        self.sex = 2;
    }
    self.patientMobileTextField.text = _patient.mobile;
    
    // 3.设置导航栏右侧按钮
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame = CGRectMake(0, 0, 40, 30);
    [btnSave setTitle:@"删除" forState:UIControlStateNormal];
    btnSave.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnSave setTitleColor:[UIColor colorWithHexString:@"#0099ff"] forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor colorWithHexString:@"#5bbdfe"] forState:UIControlStateHighlighted];
    [btnSave addTarget:self action:@selector(deletePatient) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    
    // 3.设置导航栏按钮
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.text = @"修改就诊人信息";
    titleLabel.textColor = ZZTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    // 4. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
}

- (void)navBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 删除就诊人
- (void)deletePatient {
    
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/visit_human/delete",BASEURL];
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:self.patient.patient_id forKey:@"id"];// 就诊人ID
    
    // 2.发送网络请求
    __weak typeof(self) weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"~~~%@~~~",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            [weakSelf deletePatientAlert];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"~~~%@~~~",error);
        
    }];
}

#pragma mark - 删除就诊人提示
- (void)deletePatientAlert {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否删除就诊人？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 性别按钮 监听
- (IBAction)choseSexBtnAction:(UIButton *)sender {
    
    if (sender.tag == 100) { // 男性
        
        self.sex = 1;
        
        // 设置按钮图片
        [self.manButton setImage:[UIImage imageNamed:@"service_xuan_ze"] forState:UIControlStateNormal];
        [self.womenButton setImage:[UIImage imageNamed:@"service_mo_ren"] forState:UIControlStateNormal];
    } else { // 女性
        
        self.sex = 2;
        
        // 设置按钮图片
        [self.manButton setImage:[UIImage imageNamed:@"service_mo_ren"] forState:UIControlStateNormal];
        [self.womenButton setImage:[UIImage imageNamed:@"service_xuan_ze"] forState:UIControlStateNormal];
    }
}

#pragma mark - 保存编辑
- (IBAction)deletePatientBtnAction:(UIButton *)sender {

    if (self.patientMobileTextField.text.length == 0) {
        [MBProgressHUD showError:@"请填写有效的手机号码" toView:self.view];
        return;
    }
    
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/visit_human/update",BASEURL];
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:self.patient.patient_id forKey:@"id"];// 就诊人ID
    [params setObject:@"12314" forKey:@"address"];// 必要参数:地址
    [params setObject:self.patientNameTextField.text forKey:@"name"];
    [params setObject:self.patientIDCodeTextField.text forKey:@"id_card"];
    [params setObject:[NSString stringWithFormat:@"%d",self.sex] forKey:@"sex"];
    [params setObject:self.patientMobileTextField.text forKey:@"mobile"];
    
    __weak typeof(self) weakSelf = self;
    
    // 2.发送网络请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"~~~%@~~~",responseObj);
        
        [MBProgressHUD showSuccess:responseObj[@"message"] toView:weakSelf.view];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        ZZLog(@"~~~%@~~~",error);
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.patientIDCodeTextField)    {
        if ([toBeString length] > 18) {// 身份证号码只能输入11位
            textField.text = [toBeString substringToIndex:18];
            return NO;
        }
        
    }else if (textField == self.patientMobileTextField) {// 电话号码只能输入11位
        if ([toBeString length] >11) {
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
        
    }
    return YES;
}

- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
