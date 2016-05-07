//
//  LSWithDrawalViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/11.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSWithDrawalViewController.h"
#import "Common.h"

@interface LSWithDrawalViewController ()

/** 提现金额 */
@property (weak, nonatomic) IBOutlet UITextField *withDrawalAmountTextField;

/** 支付宝账号 */
@property (weak, nonatomic) IBOutlet UITextField *zhiFuBaoAccountTextField;

/** 提现人姓名 */
@property (weak, nonatomic) IBOutlet UITextField *withDrawalNameTextField;

@end

@implementation LSWithDrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置界面
    [self setUI];
    
    // 设置textField属性
    // 提取金额
    _withDrawalAmountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _withDrawalAmountTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    // 支付宝账号
    _zhiFuBaoAccountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _zhiFuBaoAccountTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    // 姓名
    _withDrawalNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
}

- (void)setUI {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.text = @"提取现金";
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

- (IBAction)withDrawalBtnAction:(UIButton *)sender {
    
    // 设置按钮背景颜色
    [sender setBackgroundColor:[UIColor colorWithHexString:@"#30a5fc"]];
    
    // 判断提取金额填写的信息
    if ([self.withDrawalAmountTextField.text floatValue] < 1.0f) {
        [MBProgressHUD showError:@"提现金额必须大于1元"];
        return;
    }
    if (!_zhiFuBaoAccountTextField.text.length) {
        [MBProgressHUD showError:@"请填写您的支付宝账号" toView:self.view];
        return;
    }
    if (!_withDrawalNameTextField.text.length) {
        [MBProgressHUD showError:@"请填写您的姓名" toView:self.view];
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/trader/withdraw",BASEURL];// 提现申请接口
    NSMutableDictionary *params = [NSMutableDictionary dictionary]
    ;
    
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:self.withDrawalAmountTextField.text forKey:@"price"];// 提取金额
    [params setObject:self.zhiFuBaoAccountTextField.text forKey:@"store_account_no"];// 收款帐号
    [params setObject:self.withDrawalNameTextField.text forKey:@"store_account_name"];// 收款人姓名
    
    __weak typeof(self) wSelf = self;
    
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"~~--responseObj~%@",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {// 提现成功
            ZZLog(@"~--提现成功--~%@",responseObj[@"result"]);
            [self.navigationController popToRootViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"已经提交提现申请！"];
            
        }else {// 提现失败
            // 2.2 获取失败,提示获取失败
            [MBProgressHUD showError:responseObj[@"message"] toView:wSelf.view];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"~~~%@",error);
        
    }];
}

#pragma mark - 设置按钮高亮颜色
- (IBAction)heightLight:(UIButton *)sender {
    
    [sender setBackgroundColor:[UIColor colorWithHexString:@"#0092ff"]];
}

#pragma mark - 拦截view的触摸动作
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
