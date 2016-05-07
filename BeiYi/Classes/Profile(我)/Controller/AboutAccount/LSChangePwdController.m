//
//  LSChangePwdController.m
//  BeiYi
//
//  Created by LiuShuang on 15/4/21.
//  Copyright (c) 2015年 LiuShuang. All rights reserved.
//

#import "LSChangePwdController.h"
#import "Common.h"
#import "ZZHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "Md5Coder.h"
#import "ZZTabBarController.h"

@interface LSChangePwdController ()

/** 旧密码 */
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
/** 新密码 */
@property (weak, nonatomic) IBOutlet UITextField *xNewPwdTextField;
/** 确认密码 */
@property (weak, nonatomic) IBOutlet UITextField *repeatPwdTextField;

@end

@implementation LSChangePwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view .backgroundColor = ZZBackgroundColor;
    
    [self setUI];
}

- (void)setUI {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.text = @"修改密码";
    titleLabel.textColor = ZZTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    // 2.设置导航栏右侧按钮
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame = CGRectMake(0, 0, 40, 30);
    [btnSave setTitle:@"确定" forState:UIControlStateNormal];
    btnSave.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnSave setTitleColor:[UIColor colorWithHexString:@"#0099ff"] forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor colorWithHexString:@"#5bbdfe"] forState:UIControlStateHighlighted];
    [btnSave addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    
    // 3. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
}

- (void)navBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 监听 确认 按钮点击
- (void)confirm {
    ZZLog(@"点击了确认按钮");

    if (self.oldPwdTextField.text.length ==0) {
        [MBProgressHUD showError:@"请输入您的旧密码"];
        return;
    }else if (self.xNewPwdTextField.text.length ==0) {
        [MBProgressHUD showError:@"请输入您的新密码"];
        return;
    }else if(self.repeatPwdTextField.text.length ==0) {
        [MBProgressHUD showError:@"请再次输入您的新密码"];
        return;
    }
    
    if (![self.xNewPwdTextField.text isEqualToString: self.repeatPwdTextField.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
    } else {
        
        [MBProgressHUD showMessage:@"请稍后..."];
        
        // 1.准备参数
        NSString *urlStr = [NSString stringWithFormat:@"%@/uc/my/update_pwd",BASEURL];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[Md5Coder md5:self.oldPwdTextField.text] forKey:@"old_pwd"];
        [params setObject:[Md5Coder md5:self.xNewPwdTextField.text] forKey:@"new_pwd"];
        [params setObject:myAccount.token forKey:@"token"];
        
        // 2.发送请求
        [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
            ZZLog(@"确认%@成功",responseObj);
            
            [MBProgressHUD hideHUD];

            // 2.1判断是否修改成功
            if ([responseObj[@"message"] isEqualToString:@"密码修改成功！"]) {// 密码修改成功
                // 显示提示信息
                [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@请重新登陆", responseObj[@"message"]]];
                
                // 删除账号信息，跳转回首页
                [ZZAccountTool deleteAccount];
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = [[ZZTabBarController alloc] init];
                
            } else {// 密码修改失败
                [MBProgressHUD showError:responseObj[@"message"]];
            }
            
        } failure:^(NSError *error) {
            ZZLog(@"确认%@成功",error);
            [MBProgressHUD hideHUD];
        }];
    }
}

#pragma mark - 退出键盘
- (IBAction)textFieldReturnEditing:(UITextField *)sender {
    
    [sender resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
