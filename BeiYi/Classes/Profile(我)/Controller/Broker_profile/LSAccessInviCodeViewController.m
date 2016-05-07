//
//  LSAccessInviCodeViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/8.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSAccessInviCodeViewController.h"
#import "LSRegularEx.h"
#import "Common.h"

@interface LSAccessInviCodeViewController ()

/** 姓名 */
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

/** 手机号码 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;

@end

@implementation LSAccessInviCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 1.更改状态栏的文字颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    // 2.设置UI
    [self setUI];
    
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameTextField.clearsOnBeginEditing = YES;
    
    self.phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumTextField.clearsOnBeginEditing = YES;
    self.phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
}

#pragma mark - 设置导航栏右侧按钮
- (void)setUI {
    // 1.设置基本信息
    self.view .backgroundColor = ZZBackgroundColor;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    titleLabel.text = @"获取邀请码";
    titleLabel.textColor = ZZTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    // 2. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
}

- (void)navBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 提交按钮 监听
- (IBAction)commitMemo:(UIButton *)sender {
    
    // 验证填写的信息
    if (!self.nameTextField.text.length) {
        [MBProgressHUD showError:@"请输入您的姓名" toView:self.view];
        return;
    }
    if (!self.phoneNumTextField.text.length) { // 没有输入手机号码
        
        [MBProgressHUD showError:@"请输入您的手机号码" toView:self.view];
        return;
    } else { // 已经输入了手机号码
        
        if (![LSRegularEx validatePhoneNum:self.phoneNumTextField.text]) {
            [MBProgressHUD showError:@"您输入的手机号码有误" toView:self.view];
            return;
        }
    }
    
    
    // 1. 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/offer/apply",BASEURL];
    
    // 2. 创建请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"token"] = myAccount.token;
    params[@"name"] = self.nameTextField.text;
    params[@"mobile"] = self.phoneNumTextField.text;
    ZZLog(@"%@",params);
    
    // 3. 发送post请求
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(id responseObj) {
        ZZLog(@"--经纪人检测--%@",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:responseObj[@"message"] toView:weakSelf.view];
        }
        if ([responseObj[@"code"] isEqualToString:@"0001"]) {
            [MBProgressHUD showError:responseObj[@"message"] toView:weakSelf.view];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"%@",error);
    }];
}

#pragma mark - 拨打客服电话按钮 监听
- (IBAction)callUS:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",sender.titleLabel.text]]];
}

#pragma mark - 拦截view的触摸动作
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
