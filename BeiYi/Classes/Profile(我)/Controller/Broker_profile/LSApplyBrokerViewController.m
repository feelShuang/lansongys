//
//  LSApplyBrokerViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/8.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSApplyBrokerViewController.h"
#import "LSAccessInviCodeViewController.h"
#import "LSCommitPersonalInfoViewController.h"
#import "Common.h"

@interface LSApplyBrokerViewController ()

/** 邀请码文本框 */
@property (weak, nonatomic) IBOutlet UITextField *invitationCodeTextField;

@end

@implementation LSApplyBrokerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 1.更改状态栏的文字颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    // 2.设置UI
    [self setUI];
    
    self.invitationCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.invitationCodeTextField.clearsOnBeginEditing = YES;
    self.invitationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#f5f6f7"]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 页面将要消失的时候设置状态条文字颜色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - 设置导航栏右侧按钮
- (void)setUI {
    // 1.设置基本信息
    self.view .backgroundColor = ZZBackgroundColor;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    titleLabel.text = @"申请经纪人";
    titleLabel.textColor = ZZTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    // 2.设置导航栏右侧按钮
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRegister.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 50, 30);
    [btnRegister setTitle:@"下一步" forState:UIControlStateNormal];
    btnRegister.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnRegister setTitleColor:[UIColor colorWithHexString:@"#0099ff"] forState:UIControlStateNormal];
    [btnRegister setTitleColor:[UIColor colorWithHexString:@"#5bbdfe"] forState:UIControlStateHighlighted];
    [btnRegister addTarget:self action:@selector(nextApply) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRegister];
    
    // 3. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
}

- (void)navBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 监听按钮点击---跳转到注册界面
- (void)nextApply {
    
//    if (!self.invitationCodeTextField.text.length) {
//        
//        [MBProgressHUD showError:@"请填写邀请码" toView:self.view];
//        
//    } else {
    
        LSCommitPersonalInfoViewController *commitInfoVC = [[LSCommitPersonalInfoViewController alloc] init];
        [self.navigationController pushViewController:commitInfoVC animated:YES];
//    }
}

#pragma mark - 获取验证码按钮 监听
- (IBAction)accessInvitationCodeAction:(UIButton *)sender {
    
    LSAccessInviCodeViewController *accessInviCodeVC = [LSAccessInviCodeViewController new];
    [self.navigationController pushViewController:accessInviCodeVC animated:YES];
}

#pragma mark - 拦截view的触摸动作
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
