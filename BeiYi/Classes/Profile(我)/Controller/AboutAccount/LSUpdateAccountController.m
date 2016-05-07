//
//  LSUpdateAccountController.m
//  BeiYi
//
//  Created by LiuShuang on 15/6/17.
//  Copyright (c) 2015年 LiuShuang. All rights reserved.
//

#import "LSUpdateAccountController.h"
#import "Common.h"
#import "SectionCell.h"
#import "ZZSelectedView.h"
#import "MBProgressHUD+MJ.h"
#import "LoginController.h"
#import "ZZHttpTool.h"
#import "ZZTabBarController.h"

@interface LSUpdateAccountController ()
/** 性别标记:1男 2女 */
@property (nonatomic, assign) int sex;

/** 用户姓名 */
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

/** 用户性别 */
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womenButton;

@end

@implementation LSUpdateAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view .backgroundColor = ZZBackgroundColor;
    
    self.sex = 1;
    
    [self setUI];
    
    // 获取用户信息
    [self getUserInfo];
}

- (void)setUI {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.text = @"个人信息";
    titleLabel.textColor = ZZTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    // 2.设置导航栏右侧按钮
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame = CGRectMake(0, 0, 40, 30);
    [btnSave setTitle:@"保存" forState:UIControlStateNormal];
    btnSave.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnSave setTitleColor:[UIColor colorWithHexString:@"#0099ff"] forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor colorWithHexString:@"#5bbdfe"] forState:UIControlStateHighlighted];
    [btnSave addTarget:self action:@selector(gotoUpdate) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    
    // 3. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
}

- (void)navBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取个人信息
- (void)getUserInfo {
    
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/my",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];
    
    // 2.发送请求
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"确认%@成功",responseObj);
        
        if (![responseObj[@"result"][@"realname"] isKindOfClass:[NSNull class]]) {
            weakSelf.userNameTextField.text = responseObj[@"result"][@"realname"];
        }
        
        NSString *sex = [NSString stringWithFormat:@"%@", responseObj[@"result"][@"sex"]];
        // 按钮图片
        if ([sex isEqualToString:@"1"]) { // 男
            
            [self.manButton setImage:[UIImage imageNamed:@"service_xuan_ze"] forState:UIControlStateNormal];
            [self.womenButton setImage:[UIImage imageNamed:@"service_mo_ren"] forState:UIControlStateNormal];
            self.sex = 1;
        } else if ([sex isEqualToString:@"2"]) { // 女
            
            [self.manButton setImage:[UIImage imageNamed:@"service_mo_ren"] forState:UIControlStateNormal];
            [self.womenButton setImage:[UIImage imageNamed:@"service_xuan_ze"] forState:UIControlStateNormal];
            self.sex = 2;
        } else {
            [self.manButton setImage:[UIImage imageNamed:@"service_xuan_ze"] forState:UIControlStateNormal];
            [self.womenButton setImage:[UIImage imageNamed:@"service_mo_ren"] forState:UIControlStateNormal];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"确认%@成功",error);
    }];
}

#pragma mark - 监听右侧保存按钮点击
- (void)gotoUpdate {
    
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/my/update",BASEURL];

    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:self.userNameTextField.text forKey:@"realname"];// 真实姓名
    [params setObject:[NSString stringWithFormat:@"%d",self.sex] forKey:@"sex"];

    __weak typeof(self) weakSelf = self;

    // 2.发送网络请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"~~~%@~~~",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            
            [MBProgressHUD showSuccess:responseObj[@"message"] toView:weakSelf.view];
        }else {
            [MBProgressHUD showError:@"发生未知错误."];
        }

        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        ZZLog(@"~~~%@~~~",error);
        
    }];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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

#pragma mark - 退出键盘
- (IBAction)textFieldReturnEditing:(UITextField *)sender {
    
    [sender resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
