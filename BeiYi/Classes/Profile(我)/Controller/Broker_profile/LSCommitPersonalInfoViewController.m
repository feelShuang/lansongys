//
//  LSCommitPersonalInfoViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/8.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSCommitPersonalInfoViewController.h"
#import "LSCommitPayInfoViewController.h"
#import "Common.h"

@interface LSCommitPersonalInfoViewController ()

/** 经纪人姓名 */
@property (weak, nonatomic) IBOutlet UITextField *brokerNameTextField;
/** 经纪人身份证号码 */
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;

/** 身份证正面宽度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idCardFrontWidthLayout;

@property (weak, nonatomic) IBOutlet UIView *contentInfoView;

@end

@implementation LSCommitPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 1.更改状态栏的文字颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    // 2.设置UI
    [self setUI];
    
    self.brokerNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.brokerNameTextField.clearsOnBeginEditing = YES;
    
    self.idCardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.idCardTextField.clearsOnBeginEditing = YES;
    self.idCardTextField.keyboardType = UIKeyboardTypeNumberPad;
}

#pragma mark - 设置导航栏右侧按钮
- (void)setUI {
    
    // 设置身份证宽度约束
    self.idCardFrontWidthLayout.constant = (SCREEN_WIDTH * 0.92);
    
    // 1.设置基本信息
    self.view .backgroundColor = ZZBackgroundColor;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    titleLabel.text = @"提交个人信息";
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
    [btnRegister addTarget:self action:@selector(nextCommit) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRegister];
    
    // 3. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
}

- (void)navBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 监听按钮点击---跳转到注册界面
- (void)nextCommit {
    LSCommitPayInfoViewController *commitInfoVC = [[LSCommitPayInfoViewController alloc] init];
    [self.navigationController pushViewController:commitInfoVC animated:YES];
}

#pragma mark - 上传身份证按钮 监听
- (IBAction)uploadIDCard:(UIButton *)sender {
    
    if (sender.tag == 100) { // 上传身份证正面按钮
        
    } else { // 上传身份证反面按钮
        
    }
}

#pragma mark - 蓝松医生用户协议按钮 监听
- (IBAction)lansongProtocol:(UIButton *)sender {
    
    if (sender.tag == 200) { // 选中图标按钮
        
    } else { // 蓝松医生用户协议按钮
        
    }
}

#pragma mark - 拦截view的触摸动作
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.contentInfoView endEditing:YES];
}

@end
