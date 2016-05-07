//
//  LSSetPwdViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/6.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSSetPwdViewController.h"
#import "Common.h"
#import "Md5Coder.h"
#import "LSAccount.h"

@interface LSSetPwdViewController ()


@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *checkPwdTextField;

@end

@implementation LSSetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 设置UI
    [self setUI];
}

#pragma mark - 设置UI
- (void)setUI {
    
    // 1. 设置标题
    UILabel *registerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    registerLabel.text = @"设置密码";
    registerLabel.textColor = ZZTitleColor;
    registerLabel.textAlignment = NSTextAlignmentCenter;
    registerLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = registerLabel;
    
    // 2. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
    
    // 3. 设置textField
    self.pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.pwdTextField.secureTextEntry = YES; // 密文显示
    self.pwdTextField.clearsOnBeginEditing = YES;// 再次编辑就清空
    
    self.checkPwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.checkPwdTextField.secureTextEntry = YES; // 密文显示
    self.checkPwdTextField.clearsOnBeginEditing = YES;// 再次编辑就清空
}

#pragma mark - 监听 返回按钮
- (void)navBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 确定按钮 监听
- (IBAction)btnClickedAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    if (self.pwdTextField.text.length ==0) {
        [MBProgressHUD showError:@"请输入您的密码" toView:self.view];
        return;
    }else if (self.checkPwdTextField.text.length ==0) {
        [MBProgressHUD showError:@"请再次输入您的密码" toView:self.view];
        return;
    }
    
    if (![self.pwdTextField.text isEqualToString:self.checkPwdTextField.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致" toView:self.view];
    } else {

        // 1.准备参数
        NSString *md5Pwd = [Md5Coder md5:self.pwdTextField.text];// md5加密后的密码
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/register",BASEURL];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];

        [dict setValue:self.mobile forKey:@"mobile"];
        [dict setValue:md5Pwd forKey:@"password"];
        [dict setValue:self.validate_code forKey:@"auth_code"];
        [dict setValue:@0 forKey:@"offer_flag"];// 默认注册成需求者
        
        // 2.添加遮盖
        [MBProgressHUD showMessage:@"正在发送请求..."];
        
        __weak typeof(self) weakSelf = self;
        
        // 3.发送post请求
        [ZZHTTPTool post:urlStr params:dict success:^(NSDictionary *responseObj) {
            ZZLog(@"---注册成功？---%@",responseObj);
            // 3.1移除遮盖
            [MBProgressHUD hideHUD];
            if ([responseObj[@"message"] isEqualToString:@"注册成功！"]){
                
                // 将账号和密码存入单例
                [LSAccount sharedInstance].user = self.mobile;
                [LSAccount sharedInstance].pwd = self.pwdTextField.text;
                
                ZZLog(@"%@%@",[LSAccount sharedInstance].user,[LSAccount sharedInstance].pwd);
                
                // 3.2跳转到登陆界面
                [MBProgressHUD showSuccess:@"注册成功！"];
                [weakSelf.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }else {
                [MBProgressHUD showError:responseObj[@"message"]];
            }
            
        } failure:^(NSError *error) {
            ZZLog(@"%@",error);
        }];
    }
    
}

#pragma mark - 拦截touch手势
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (IBAction)textFieldReturnEditing:(UITextField *)sender {
    
    [sender resignFirstResponder];
}


@end
