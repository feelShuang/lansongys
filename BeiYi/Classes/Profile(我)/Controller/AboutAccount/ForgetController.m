//
//  ForgetController.m
//  BeiYi
//
//  Created by Joe on 15/4/21.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ForgetController.h"
#import "ZZTabBarController.h"
#import "JKCountDownButton.h"
#import "LSRegularEx.h"
#import "MBProgressHUD+MJ.h"
#import "Md5Coder.h"
#import "Common.h"

@interface ForgetController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textPhone; // 手机号
@property (nonatomic, strong) UITextField *textNewCode; // 新密码
@property (nonatomic, strong) UITextField *textRepeat; // 密码确认
@property (nonatomic, strong) UITextField *textIDCode; // 验证码
@property (nonatomic, strong) JKCountDownButton *btnGetCode;

@end

@implementation ForgetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view .backgroundColor = ZZBackgroundColor;
    
    // 设置导航条的内容
    [self setNavigation];
    
    [self setUpUI];
}

- (void)setNavigation {
    
    // 设置title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.text = @"找回密码";
    titleLabel.textColor = ZZTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    // 3. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
}

- (void)navBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpUI {
    CGFloat backViewY = 79;
    CGFloat backViewW = SCREEN_WIDTH;
    CGFloat backViewH = 44;
    
    // 1.背景View
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, backViewY, backViewW, backViewH *4)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    CGFloat lblX = 15;
    CGFloat lblY = 7;
    CGFloat lblWidth = ZZMarins * 3.4;
    CGFloat lblHeight = 30;
    
    // textField的X值
    CGFloat txFieldX = lblWidth +2*lblX;
    // textField的W值
    CGFloat txFieldW = backViewW -txFieldX - 15;

    // 2.1 手机号label
    UILabel *lblPhone = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, lblWidth, lblHeight)];
    lblPhone.text = @"手机号";
    lblPhone.textColor = ZZTitleColor;
    lblPhone.font = [UIFont systemFontOfSize:14];
    [backView addSubview:lblPhone];
    
    // 2.2 手机号textField
    _textPhone = [[UITextField alloc] initWithFrame:CGRectMake(txFieldX, lblY, txFieldW, lblHeight)];
    _textPhone.placeholder = @"请输入手机号";
    _textPhone.textAlignment = NSTextAlignmentLeft;
    _textPhone.keyboardType = UIKeyboardTypeNumberPad;
    _textPhone.delegate = self;
    _textPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textPhone.font = [UIFont systemFontOfSize:14];
    [backView addSubview:_textPhone];
    
    // 3.1 新密码label
    UILabel *lblNewCode = [[UILabel alloc] initWithFrame:CGRectMake(lblX, backViewH +lblY, lblWidth, lblHeight)];
    lblNewCode.text = @"新密码";
    lblNewCode.textColor = ZZTitleColor;
    lblNewCode.font = [UIFont systemFontOfSize:14];
    [backView addSubview:lblNewCode];
    
    // 3.2 新密码textField
    _textNewCode = [[UITextField alloc] initWithFrame:CGRectMake(txFieldX , backViewH +lblY, txFieldW, lblHeight)];
    _textNewCode.placeholder = @"请输入新密码";
    _textNewCode.textAlignment = NSTextAlignmentLeft;
    _textNewCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textNewCode.clearsOnBeginEditing = YES;
    _textNewCode.keyboardType = UIKeyboardTypeEmailAddress;
    _textNewCode.secureTextEntry = YES;
    _textNewCode.font = [UIFont systemFontOfSize:14];
    [backView addSubview:_textNewCode];
    
    // 4.1 密码确认label
    UILabel *lblRepeat = [[UILabel alloc] initWithFrame:CGRectMake(lblX, 2*backViewH +lblY, lblWidth, lblHeight)];
    lblRepeat.text = @"确认密码";
    lblRepeat.textColor = ZZTitleColor;
    lblRepeat.font = [UIFont systemFontOfSize:14];
    [backView addSubview:lblRepeat];
    
    // 4.2 密码确认textField
    _textRepeat = [[UITextField alloc] initWithFrame:CGRectMake(txFieldX, 2*backViewH +lblY, txFieldW, lblHeight)];
    _textRepeat.placeholder = @"请重新输入密码";
    _textRepeat.textAlignment = NSTextAlignmentLeft;
    _textRepeat.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textRepeat.clearsOnBeginEditing = YES;
    _textRepeat.keyboardType = UIKeyboardTypeEmailAddress;
    _textRepeat.secureTextEntry = YES;
    _textRepeat.font = [UIFont systemFontOfSize:14];
    [backView addSubview:_textRepeat];
    
    // 5.1 验证码label
    UILabel *lblIDCode = [[UILabel alloc] initWithFrame:CGRectMake(lblX, 3*backViewH +lblY, lblWidth, lblHeight)];
    lblIDCode.text = @"验证码";
    lblIDCode.textColor = ZZTitleColor;
    lblIDCode.font = [UIFont systemFontOfSize:14];
    [backView addSubview:lblIDCode];
    
    // 5.2 验证码textField
    _textIDCode = [[UITextField alloc] initWithFrame:CGRectMake(txFieldX , 3*backViewH +lblY, backViewW/3*2 -txFieldX -ZZMarins, lblHeight)];
    _textIDCode.placeholder = @"请输入验证码";
    _textIDCode.font = [UIFont systemFontOfSize:14];
    _textIDCode.textAlignment = NSTextAlignmentLeft;
    _textIDCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textIDCode.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:_textIDCode];
    
    // 6.获取验证按钮
    self.btnGetCode = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    

    CGFloat btnGetCodeY = 5;
    CGFloat btnGetCodeH = 34;
    
    
    self.btnGetCode.frame = CGRectMake(SCREEN_WIDTH - 15 - (ZZMarins * 4.6), backViewH * 3 + btnGetCodeY, ZZMarins * 4.6, btnGetCodeH);
    self.btnGetCode.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.btnGetCode setTitle:@"点击获取" forState:UIControlStateNormal];
    [self.btnGetCode setTitleColor:ZZColor(0, 153, 255, 1) forState:UIControlStateNormal];
    self.btnGetCode.layer.borderWidth = 1.0f;
    self.btnGetCode.layer.borderColor = ZZColor(0, 153, 255, 1).CGColor;
    self.btnGetCode.layer.cornerRadius = 5.0f;

    // 监听  获取验证码按钮  点击
    [self clickedGetIDCodeButton];
    [backView addSubview:self.btnGetCode];
    
    
    // 7.确定按钮
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogin.frame = CGRectMake(15, CGRectGetMaxY(backView.frame) + 50, SCREEN_WIDTH -30, ZZBtnHeight);
    btnLogin.backgroundColor = [UIColor colorWithHexString:@"#30a5fc"];
    [btnLogin addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    btnLogin.layer.cornerRadius = 5.0f;
    [btnLogin setTitle:@"确   定" forState:UIControlStateNormal];
    btnLogin.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:btnLogin];
    
    // 8.分割线
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, 0) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:backView];
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, backViewH) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:backView];
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, backViewH * 2) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:backView];
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, backViewH * 3) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:backView];
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, backViewH * 4) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:backView];
}

#pragma mark - 监听获取验证码按钮点击
#pragma mark - 监听  获取验证码按钮  点击
- (void)clickedGetIDCodeButton {
    __weak typeof(self) wSelf = self;
    
    [self.btnGetCode addToucheHandler:^(JKCountDownButton *sender, NSInteger tag) {
        // 1.退出键盘
        [wSelf.view endEditing:YES];
        
        // 2.确认输入的电话号码正确
        if (wSelf.textPhone.text.length == 0) {
            [MBProgressHUD showError:@"请输入手机号码"];
            return;
        }
        
        if (wSelf.textPhone.text.length != 11) {
            [MBProgressHUD showError:@"请输入正确的手机号码"];
            return;
        }
        
        // 3.监听  获取验证码按钮  点击
        [wSelf getIDCodeRequest];
        
    }];
}

#pragma mark - 获取验证码 网络请求
- (void)getIDCodeRequest {
    
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/validate_code",BASEURL] ;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.textPhone.text forKey:@"mobile"];
    [params setObject:@"1" forKey:@"exists_flag"];// 手机号是否允许重复1-是 0-否
    
    [MBProgressHUD showMessage:@"验证码获取中..."];
    
    __weak typeof(self) wSelf = self;
    // 2.发送post请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseDict) {
        ZZLog(@"%@",responseDict);
        
        CGFloat marinY = 5;
        CGFloat btnGetCodeY = 44 * 3 + marinY;
        CGFloat btnGetCodeH = 34;
        if ([responseDict[@"code"] isEqual:@"0001"]) {
            // 隐藏遮盖
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:responseDict[@"message"]];
        }else {
            // 隐藏遮盖
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:responseDict[@"message"]];
            
            // 4.按钮不可选中
            wSelf.btnGetCode.enabled = NO;
            
            // 5.开始倒计时
            [wSelf.btnGetCode startWithSecond:60];
            
            // 6.倒计时中
            [wSelf.btnGetCode didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                NSString *title = [NSString stringWithFormat:@"%d秒后可重发",second];
                countDownButton.frame = CGRectMake(SCREEN_WIDTH - 15 - (ZZMarins * 5.5), btnGetCodeY, ZZMarins * 5.5,  btnGetCodeH);
                countDownButton.backgroundColor = ZZBorderColor;
                countDownButton.layer.borderColor = ZZBorderColor.CGColor;
                [countDownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                return title;
            }];
            
            // 7.倒计时结束
            [wSelf.btnGetCode didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                countDownButton.enabled = YES;
                countDownButton.frame = CGRectMake(SCREEN_WIDTH - 15 - (ZZMarins * 4.6), btnGetCodeY, ZZMarins * 4.6,  btnGetCodeH);
                countDownButton.backgroundColor = [UIColor whiteColor];
                countDownButton.layer.borderColor = ZZColor(39, 202, 255, 1).CGColor;
                [countDownButton setTitleColor:ZZColor(39, 202, 255, 1) forState:UIControlStateNormal];
                return @"点击获取";
            }];
        }
    } failure:^(NSError *error) {
        // 隐藏遮盖
        [MBProgressHUD hideHUD];
        ZZLog(@"%@",error);
    }];
}

#pragma mark - 监听 确定 按钮点击
- (void)confirm {
    ZZLog(@"确认成功");
    
    if (self.textPhone.text.length ==0) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }else if (self.textNewCode.text.length ==0) {
        [MBProgressHUD showError:@"请输入新的密码"];
        return;
    }else if (self.textRepeat.text.length ==0) {
        [MBProgressHUD showError:@"请确认您的新密码"];
        return;
    }else if(self.textIDCode.text.length ==0){
        [MBProgressHUD showError:@"请输入您的验证码"];
        return;
    }else if(![self.textNewCode.text isEqualToString:self.textRepeat.text]){
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    
    
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/forget/reset",BASEURL] ;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.textPhone.text forKey:@"mobile"];
    [params setObject:[Md5Coder md5:self.textNewCode.text] forKey:@"password"];
    [params setObject:self.textIDCode.text forKey:@"auth_code"];

    [MBProgressHUD showMessage:@"请稍后..."];
    
    // 2.发送post请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseDict) {
        ZZLog(@"%@",responseDict);
        if ([responseDict[@"message"] isEqual:@"操作成功！"]) {
            // 隐藏遮盖
            [MBProgressHUD hideHUD];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[ZZTabBarController alloc] init];
            
            [MBProgressHUD showSuccess:@"操作成功！"];
        }else {
            // 隐藏遮盖
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"发生异常"];
        }
    } failure:^(NSError *error) {
        // 隐藏遮盖
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"发生错误"];
        ZZLog(@"%@",error);
    }];

}

#pragma mark -  UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == _textPhone && [LSRegularEx validatePhoneNum:textField.text] == NO) {
        
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
    }
}

// 限定号码只能输入11位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.textPhone == textField)
    {
        if ([toBeString length] > 11) {
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 退出键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
