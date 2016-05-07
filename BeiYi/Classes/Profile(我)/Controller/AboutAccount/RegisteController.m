//
//  RegisteController.m
//  BeiYi
//
//  Created by Joe on 15/4/21.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "RegisteController.h"
#import "LSSetPwdViewController.h"
#import "ResourcesController.h"
#import "LSRegularEx.h"
#import "MBProgressHUD+MJ.h"
#import "JKCountDownButton.h"
#import "Common.h"

@interface RegisteController ()<UITextFieldDelegate,TagsDelegate>
/** UITextField 昵称 */
@property (nonatomic, strong) UITextField *textName;
/** UITextField 手机号 */
@property (nonatomic, strong) UITextField *textPhone;
/** UITextField 密码 */
@property (nonatomic, strong) UITextField *textNewCode;
/** UITextField 密码确认 */
@property (nonatomic, strong) UITextField *textRepeat;
/** UITextField 验证码 */
@property (nonatomic, strong) UITextField *textIDCode;
/** UIButton 获取验证码按钮 */
@property (nonatomic, strong) JKCountDownButton *btnGetCode;
/** UIButton 注册按钮 */
@property (nonatomic, strong) UIButton *btnRegist;
/** UIView 手机号码下面的分割线 */
@property (nonatomic, strong) UIView *phoneLine;

// 蓝松医生协议同意标志
@property (nonatomic, assign) BOOL isClicked;

@end

@implementation RegisteController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZZBackgroundColor;
    
    // 设置导航条
    [self setNavigation];
    
    // 设置UI界面
    [self setUpUI];
}

- (void)setNavigation {
    
    // 1. 设置标题
    UILabel *registerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    registerLabel.text = @"注册";
    registerLabel.textColor = ZZTitleColor;
    registerLabel.textAlignment = NSTextAlignmentCenter;
    registerLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = registerLabel;
    
    // 2. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
    
    // 3.设置导航栏右侧按钮
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRegister.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 45, 30);
    [btnRegister setTitle:@"下一步" forState:UIControlStateNormal];
    btnRegister.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnRegister setTitleColor:[UIColor colorWithHexString:@"#0099ff"] forState:UIControlStateNormal];
    [btnRegister setTitleColor:[UIColor colorWithHexString:@"#5bbdfe"] forState:UIControlStateHighlighted];
    [btnRegister addTarget:self action:@selector(nextRegisterAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRegister];
}

#pragma mark - 监听 返回按钮
- (void)navBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 监听 下一步按钮
- (void)nextRegisterAction {

    // 验证填写的信息
    // 1.确认输入的电话号码正确
    if (self.textPhone.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }
    
    if (self.textPhone.text.length != 11) {
        [MBProgressHUD showError:@"请输入正确的手机号码"];
        return;
    }
    
    // 2.确认选中同意协议按钮
    if (_isClicked) {
        [MBProgressHUD showError:@"请同意蓝松医生用户协议" toView:self.view];
        return;
    }
    
    // 1. 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/validate_code/check",BASEURL];
    
    // 2. 创建请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"mobile"] = self.textPhone.text;
    params[@"auth_code"] = self.textIDCode.text;
    
    // 3. 发送post请求
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(id responseObj) {
        ZZLog(@"--短信验证码验证--%@",responseObj);

        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
    
            LSSetPwdViewController *setPwdVC = [LSSetPwdViewController new];
            setPwdVC.mobile = self.textPhone.text;
            setPwdVC.validate_code = self.textIDCode.text;
            [weakSelf.navigationController pushViewController:setPwdVC animated:YES];
        } else if ([responseObj[@"code"] isEqualToString:@"0001"]) {
            [MBProgressHUD showError:@"短信验证码不正确" toView:weakSelf.view];
        } else {
            [MBProgressHUD showError:responseObj[@"message"]];
        }
    } failure:^(NSError *error) {
        ZZLog(@"%@",error);
    }];
}

#pragma mark - 设置UI界面
- (void)setUpUI {
    
    
    
    CGFloat backViewY = 79;
    CGFloat backViewW = SCREEN_WIDTH;
    CGFloat backViewH = 44;
    
    // 0.背景View
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, backViewY, backViewW, backViewH * 2)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    CGFloat lblX = 15;
    CGFloat lblY = 7;
    CGFloat lblWidth = 50;
    CGFloat lblHeight = 30;
    
    
    // 1.1 手机号label
    UILabel *lblPhone = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, lblWidth, lblHeight)];
    lblPhone.text = @"账    号";
    lblPhone.textColor = ZZTitleColor;
    lblPhone.font = [UIFont systemFontOfSize:14];
    [backView addSubview:lblPhone];
    
    // textField的X值
    CGFloat txFieldX = CGRectGetMaxX(lblPhone.frame) + 2 * lblX;
    // textField的W值
    CGFloat txFieldW = SCREEN_WIDTH - txFieldX - 15;
    
    // 1.2 手机号textField
    _textPhone = [[UITextField alloc] initWithFrame:CGRectMake(txFieldX , lblY, txFieldW, lblHeight)];
    _textPhone.placeholder = @"请输入手机号";
    _textPhone.textAlignment = NSTextAlignmentLeft;
    _textPhone.keyboardType = UIKeyboardTypeNumberPad;
    _textPhone.delegate = self;
    _textPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textPhone.font = [UIFont systemFontOfSize:14];
    [backView addSubview:_textPhone];
    
    // 2.1 验证码label
    UILabel *lblIDCode = [[UILabel alloc] initWithFrame:CGRectMake(lblX, backViewH +lblY, lblWidth, lblHeight)];
    lblIDCode.text = @"验证码";
    lblIDCode.textColor = ZZTitleColor;
    lblIDCode.font = [UIFont systemFontOfSize:14];
    [backView addSubview:lblIDCode];
    
    // 2.2 验证码textField
    _textIDCode = [[UITextField alloc] initWithFrame:CGRectMake(txFieldX , backViewH +lblY, backViewW/3*2 -txFieldX -ZZMarins, lblHeight)];
    _textIDCode.placeholder = @"请输入验证码";
    _textIDCode.font = [UIFont systemFontOfSize:14];
    _textIDCode.textAlignment = NSTextAlignmentLeft;
    _textIDCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textIDCode.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:_textIDCode];
    
    // 6.获取验证按钮
    self.btnGetCode = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    CGFloat marinY = 5;
    CGFloat btnGetCodeY = backViewH+marinY;
    CGFloat btnGetCodeH = 34;
    
    self.btnGetCode.frame = CGRectMake(SCREEN_WIDTH - 15 - (ZZMarins * 4.6), btnGetCodeY, ZZMarins * 4.6,  btnGetCodeH);
    self.btnGetCode.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.btnGetCode setTitle:@"点击获取" forState:UIControlStateNormal];
    [self.btnGetCode setTitleColor:ZZColor(0, 153, 255, 1) forState:UIControlStateNormal];
    self.btnGetCode.layer.borderWidth = 1.0f;
    self.btnGetCode.layer.borderColor = ZZColor(0, 153, 255, 1).CGColor;
    self.btnGetCode.layer.cornerRadius = 5.0f;

    // 监听  获取验证码按钮  点击
    [self clickedGetIDCodeButton];
    [backView addSubview:self.btnGetCode];
    
    
    // 7.分割线
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, 0) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:backView];
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, backViewH) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:backView];
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, backViewH * 2) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:backView];
    
    // 8.蓝松医生用户协议
    CGFloat btnW = 120;
    CGFloat btnX = SCREEN_WIDTH - btnW - 15;
    CGFloat btnY = CGRectGetMaxY(backView.frame) + 21;
    CGFloat btnH = 12;
    UIButton *lansongProtocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    lansongProtocolBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    lansongProtocolBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [lansongProtocolBtn setTitle:@"《蓝松医生用户协议》" forState:UIControlStateNormal];
    [lansongProtocolBtn setTitleColor:ZZColor(0, 153, 255, 1) forState:UIControlStateNormal];
    [lansongProtocolBtn addTarget:self action:@selector(lansongProtocolAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:lansongProtocolBtn];
    
    // 9.已阅读并同意
    CGFloat labW = 75;
    UILabel *lansongProtocolLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lansongProtocolBtn.frame) - labW, CGRectGetMinY(lansongProtocolBtn.frame), labW, CGRectGetHeight(lansongProtocolBtn.frame))];
    
    lansongProtocolLab.text = @"已阅读并同意";
    lansongProtocolLab.textColor = ZZDetailStrColor;
    lansongProtocolLab.font = [UIFont systemFontOfSize:12];
    
    [self.view addSubview:lansongProtocolLab];
    
    // 10.同意协议按钮
    CGFloat agreeBtnW = 14;
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    agreeBtn.frame = CGRectMake(CGRectGetMinX(lansongProtocolLab.frame) - agreeBtnW - 5, CGRectGetMinY(lansongProtocolLab.frame) - 1, agreeBtnW, agreeBtnW);
    [agreeBtn setBackgroundImage:[UIImage imageNamed:@"iocn_xuan_ze"] forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(agreeProtocolAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:agreeBtn];
}

#pragma mark - 蓝松医生用户协议 监听
- (void)lansongProtocolAction {
    
#warning 添加跳转到蓝松用户协议
}

#pragma mark - 同意蓝松协议按钮 监听
- (void)agreeProtocolAction:(UIButton *)sender {
    
    if (_isClicked) { // 设置图片为选择样式
        [sender setBackgroundImage:[UIImage imageNamed:@"iocn_xuan_ze"] forState:UIControlStateNormal];
    } else {
        [sender setBackgroundImage:[UIImage imageNamed:@"iocn_yuan"] forState:UIControlStateNormal];
    }
    self.isClicked = !_isClicked;
}

#pragma mark - 监听  获取验证码按钮  点击
- (void)clickedGetIDCodeButton {
    __weak typeof(self) wSelf = self;
    
    [self.btnGetCode addToucheHandler:^(JKCountDownButton *sender, NSInteger tag) {
        sender = wSelf.btnGetCode;
        
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
        [wSelf getIDCodeRequest];// 在 getIDCodeRequest 方法里执行剩下的关于按钮的操作（倒计时等）
        
    }];
}

#pragma mark - 获取验证码 网络请求
- (void)getIDCodeRequest {
    
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/validate_code",BASEURL] ;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.textPhone.text forKey:@"mobile"];
    [params setObject:@"0" forKey:@"exists_flag"];// 手机号是否允许重复1-是 0-否
    
    [MBProgressHUD showMessage:@"验证码获取中..."];

    // 2.发送post请求
    __weak typeof(self) wSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseDict) {
        ZZLog(@"%@",responseDict);
        
        CGFloat marinY = 5;
        CGFloat btnGetCodeY = 44+marinY;
        CGFloat btnGetCodeH = 34;
        
        if ([responseDict[@"code"] isEqual:@"0001"]) {
            // 隐藏遮盖
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:responseDict[@"message"]];
        } else {
            // 隐藏遮盖
            [MBProgressHUD hideHUD];
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
            
            [MBProgressHUD showSuccess:responseDict[@"message"]];
        }
    } failure:^(NSError *error) {
        // 隐藏遮盖
        [MBProgressHUD hideHUD];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
