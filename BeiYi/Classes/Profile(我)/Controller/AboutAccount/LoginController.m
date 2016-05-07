//
//  LoginController.m
//  BeiYi
//
//  Created by Joe on 15/4/20.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "LoginController.h"
#import "RegisteController.h"
#import "ForgetController.h"
#import "ZZTabBarController.h"
#import "ProfileController.h"
#import "UIBarButtonItem+Extension.h"
#import "LSRegularEx.h"
#import "LSAccount.h"
#import "Avatar.h"
#import <AdSupport/ASIdentifierManager.h>
#import "UIImageView+WebCache.h"
#import "JPUSHService.h"
#import "Md5Coder.h"
#import "Common.h"

@interface LoginController()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textPhone;
@property (nonatomic, strong) UITextField *textPwd;

@end
@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.设置导航栏右侧按钮
    [self setRightButton];
    
    // 2.设置剩下的UI
    [self setUpLeftUI];
    
    // 3.更改状态栏的文字颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 给账号和密码textField赋值
    self.textPhone.text = [LSAccount sharedInstance].user;
    self.textPwd.text = [LSAccount sharedInstance].pwd;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#f5f6f7"]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 页面将要消失的时候设置状态条文字颜色为白色
//    [[UIApplication ¡sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - 设置导航栏右侧按钮
- (void)setRightButton {
    // 1.设置基本信息
    self.view .backgroundColor = ZZBackgroundColor;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    titleLabel.text = @"登录";
    titleLabel.textColor = ZZTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    // 2.设置导航栏右侧按钮
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRegister.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 40, 30);
    [btnRegister setTitle:@"注册" forState:UIControlStateNormal];
    btnRegister.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnRegister setTitleColor:[UIColor colorWithHexString:@"#0099ff"] forState:UIControlStateNormal];
    [btnRegister setTitleColor:[UIColor colorWithHexString:@"#5bbdfe"] forState:UIControlStateHighlighted];
    [btnRegister addTarget:self action:@selector(gotoRegist) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRegister];
    
    // 3. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
}

- (void)navBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 监听按钮点击---跳转到注册界面
- (void)gotoRegist {
    RegisteController *registeVc = [[RegisteController alloc] init];
    [self.navigationController pushViewController:registeVc animated:YES];
}

#pragma mark - 设置余下的UI
- (void)setUpLeftUI {
    
    // 1.主视图
    CGFloat loginViewY = 79;
    CGFloat loginViewWidth = SCREEN_WIDTH;
    CGFloat loginViewHeight = 88;
    UIView *loginView = [[UIView alloc] initWithFrame:CGRectMake(0, loginViewY, loginViewWidth, loginViewHeight)];
    loginView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:loginView];
    
    
    // 2.1 账号Label
    CGFloat labelX = 15;
    CGFloat labelY = 7;
    CGFloat labelW = 50;
    CGFloat labelH = 30;
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
    userLabel.text = @"账    号";
    userLabel.font = [UIFont systemFontOfSize:14];
    userLabel.textColor = ZZTitleColor;
    userLabel.textAlignment = NSTextAlignmentCenter;
    [loginView addSubview:userLabel];
    
    // 2.2 密码Label
    UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, loginViewHeight / 2 + labelY, labelW, labelH)];
    pwdLabel.text = @"密    码";
    pwdLabel.textColor = ZZTitleColor;
    pwdLabel.font = [UIFont systemFontOfSize:14];
    pwdLabel.textAlignment = NSTextAlignmentCenter;
    [loginView addSubview:pwdLabel];
    
    // 3.textField:输入号码，密码
    UITextField *textPhone = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userLabel.frame) + 30, labelY, loginView.frame.size.width - CGRectGetMaxX(userLabel.frame) - 30 - 15, labelH)];
    textPhone.delegate = self;
    textPhone.font = [UIFont systemFontOfSize:14];
    textPhone.placeholder = @"请输入手机号";
    textPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    textPhone.keyboardType = UIKeyboardTypeNumberPad;
    [loginView addSubview:textPhone];
    self.textPhone = textPhone;
    
    UITextField *textPwd = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(textPhone.frame), CGRectGetMinY(pwdLabel.frame), CGRectGetWidth(textPhone.frame), labelH)];
    textPwd.font = [UIFont systemFontOfSize:14];
    textPwd.placeholder = @"请输入密码";
    textPwd.secureTextEntry = YES; // 密文显示
    textPwd.clearsOnBeginEditing = YES;// 再次编辑就清空
    textPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    textPwd.keyboardType = UIKeyboardTypeTwitter;
    [loginView addSubview:textPwd];
    self.textPwd = textPwd;
    
    
    // 5.登录按钮
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnLogin.frame = CGRectMake(15,  CGRectGetMaxY(loginView.frame) + 50, SCREEN_WIDTH -30, ZZBtnHeight);
    btnLogin.backgroundColor = [UIColor colorWithHexString:@"#30a5fc"];
    [btnLogin addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLogin setTitle:@"确   定" forState:UIControlStateNormal];
    btnLogin.titleLabel.font = [UIFont systemFontOfSize:16];
    btnLogin.layer.cornerRadius = 3.0f;
    [self.view addSubview:btnLogin];
    
    
    // 7 忘记密码按钮
    UIButton *btnForget = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnForgetW=55;
    CGFloat btnForgetX=SCREEN_WIDTH - btnForgetW - 15;
    CGFloat btnForgetY=CGRectGetMaxY(btnLogin.frame) + 10;
    CGFloat btnForgetH=ZZMarins;
    btnForget.frame = CGRectMake(btnForgetX, btnForgetY, btnForgetW, btnForgetH);
    [btnForget addTarget:self action:@selector(forgetPassWord) forControlEvents:UIControlEventTouchUpInside];
    btnForget.titleLabel.textAlignment = NSTextAlignmentRight;// 按钮文字右对齐
    [btnForget setTitle:@"忘记密码" forState:UIControlStateNormal];
    [btnForget setTitleColor:[UIColor colorWithHexString:@"#0099ff"] forState:UIControlStateNormal];
    [btnForget setTitleColor:[UIColor colorWithHexString:@"#5bbdfe"] forState:UIControlStateHighlighted];
    btnForget.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:btnForget];
    
    // 给navigationBar添加分割线
    
    // 添加边框
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, 0) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:loginView];
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, loginViewHeight / 2) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:loginView];
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, loginViewHeight) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:loginView];
}

#pragma mark - 监听登录按钮点击
- (void)loginBtnAction {
    [self.view endEditing:YES];
    
    // 1.获取输入的手机号码和密码
    NSString *phoneNum = self.textPhone.text;
    NSString *passWord = self.textPwd.text;
    NSString *md5Pwd = [Md5Coder md5:passWord];// md5加密后的密码
    
    // 2.判断是否输入||输入的手机号码是否正确
    if (phoneNum.length == 0) {
        [MBProgressHUD showError:@"请输入正确的电话号码" toView:self.view];
        return;
    }else if(passWord.length == 0) {
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        return;
    }
    
    // 4.发送网络请求
    // 4.1准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/login",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phoneNum forKey:@"mobile"];// 手机号码(必填)
    [params setObject:md5Pwd forKey:@"password"];// 登录密码(必填)
    [params setObject:@1 forKey:@"terminal_type"];// 终端类型(必填)1-ios 2-android 3-windows
    
    // 终端唯一标识(必填) / iOS7以上
    NSString *adid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    ZZLog(@"---终端唯一标识adid---%@",adid);
    
    [params setObject:adid forKey:@"terminal_code"];
    
    __weak typeof(self) wSelf = self;
    // 4.2发送post请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseDict) {
        ZZLog(@"%@",responseDict);
        
        // 4.4判断账号密码是否正确
        if ([responseDict[@"code"] isEqualToString:@"0000"]) {// 输入正确，成功登录并保存用户信息
            [MBProgressHUD showSuccess:@"登录成功" ];
            
            // 4.5存储账号信息
            ZZAccount *account = [ZZAccount mj_objectWithKeyValues:responseDict[@"result"]];
            [ZZAccountTool save:account];
#warning 极光推送发送的是经纪人医院信息 （旧接口）
            // 极光推送
            NSArray *offerHospitals = responseDict[@"result"][@"hospitalList"];

            ZZLog(@"---极光推送---%@",offerHospitals);

            NSMutableSet *tagsSet = [NSMutableSet set];
            
            if ([offerHospitals isEqual:[NSNull null]]) {
                tagsSet = nil;

            }else {
                for (NSDictionary *dict in offerHospitals) {
                    NSString *tags = [NSString stringWithFormat:@"%@%@",JPushTag,dict[@"id"]];
                    [tagsSet addObject:tags];
                    
                }
            }

            ZZLog(@"---set---%@",tagsSet);
#warning message sent to deallocated instance
            // tagsSet:为安装了应用程序的用户，打上标签。其目的主要是方便开发者根据标签，来批量下发 Push 消息
            // alias:为安装了应用程序的用户，取个别名来标识。以后给该用户 Push 消息时，就可以用此别名来指定。每个用户只能指定一个别名。
//            [JPUSHService setTags:tagsSet alias:myAccount.token callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:wSelf];
            
            // 置空账号和密码单例
            [LSAccount sharedInstance].user = nil;
            [LSAccount sharedInstance].pwd = nil;
            
            // 4.6 返回
            [self.navigationController popViewControllerAnimated:YES];
  
            // 4.7读取账号信息（为了保存头像路径）
            [wSelf getAccount];
            
        }else
            [MBProgressHUD showError:responseDict[@"message"] toView:wSelf.view];
        
    } failure:^(NSError *error) {

        ZZLog(@"%@",error);
    }];
}

- (void)getAccount {
    if (myAccount) {
        // 1.准备参数
        NSString *urlStr = [NSString stringWithFormat:@"%@/uc/my",BASEURL] ;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:myAccount.token forKey:@"token"];

        __weak typeof(self) wSelf = self;
        [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseDict) {
            ZZLog(@"%@",responseDict);
            if ([responseDict[@"code"] isEqual:@"0000"]) {
                
                // 把头像地址保存到单例
                [Avatar sharedInstance].avator = responseDict[@"result"][@"avator"];
                
                UIImageView *icon = [[UIImageView alloc] init];
                [icon sd_setImageWithURL:responseDict[@"result"][@"avator"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                }];
                
            }else { //账号不存在
                // 1.显示提示信息
                [MBProgressHUD showSuccess:@"读取账号信息失败" toView:wSelf.view];
                
                // 2.删除本地缓存
                [ZZAccountTool deleteAccount];
                
                // 3.跳转回到首页
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = [[ZZTabBarController alloc] init];
            }

        } failure:^(NSError *error) {
            ZZLog(@"%@",error);
        }];
    }
}
#pragma mark -  判断电话号码是否存在
//- (BOOL)checkTel:(NSString *)str{
//}

#pragma mark -  监听忘记密码按钮点击
- (void)forgetPassWord {
    ForgetController *forgetVc = [[ForgetController alloc] init];
    [self.navigationController pushViewController:forgetVc animated:YES];
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

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    ZZLog(@"----回调方法----rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

@end
