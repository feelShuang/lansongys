//
//  LSBalanceViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/8.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSBalanceViewController.h"
#import "LSRechargeViewController.h"
#import "LSWithDrawalViewController.h"
#import "LSTranscationRecordTableViewController.h"
#import "Common.h"

@interface LSBalanceViewController ()

/** 账户余额 */
@property (weak, nonatomic) IBOutlet UILabel *allBalanceLabel;
/** 可用余额 */
@property (weak, nonatomic) IBOutlet UILabel *useBalanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *freezeBalanceLabel;

/** 提现按钮 */
@property (weak, nonatomic) IBOutlet UIButton *withDrawalBtn;

@end

@implementation LSBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZZBackgroundColor;
    
    [self setUpUI];
    
    // 更改状态栏的文字颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置状态条的颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#f5f6f7"]];
    
    // 获取我的余额
    // 1. 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/trader/account",BASEURL];
    
    // 2. 创建请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"token"] = myAccount.token;
    
    // 3. 发送post请求
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"---余额---%@",responseObj);
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {

            weakSelf.allBalanceLabel.text = [NSString stringWithFormat:@"%@",responseObj[@"result"][@"balance"]];
            weakSelf.useBalanceLabel.text = [NSString stringWithFormat:@"%@",responseObj[@"result"][@"use_balance"]];
            weakSelf.freezeBalanceLabel.text = [NSString stringWithFormat:@"%@",responseObj[@"result"][@"freeze"]];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"%@",error);
    }];
}


- (void)setUpUI {
    
    // 1. 设置按钮点击效果
    [self.withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"bont_mo_ren"] forState:UIControlStateNormal];
    [self.withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"bont_dian_ji"] forState:UIControlStateHighlighted];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.text = @"我的余额";
    titleLabel.textColor = ZZTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    // 5.设置导航条
    UIButton *rightBtnItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtnItem.frame = CGRectMake(0, 0, 60, 30);
    [rightBtnItem setTitle:@"交易记录" forState:UIControlStateNormal];
    [rightBtnItem setTitleColor:[UIColor colorWithHexString:@"#0099ff"] forState:UIControlStateNormal];
    [rightBtnItem setTitleColor:[UIColor colorWithHexString:@"#5bbdfe"] forState:UIControlStateHighlighted];
    rightBtnItem.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtnItem addTarget:self action:@selector(transactionRecord) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtnItem];
    
    // 3. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
}

- (void)navBackAction {
    
    // 页面将要消失的时候设置状态条文字颜色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 交易记录
- (void)transactionRecord {
    
    LSTranscationRecordTableViewController *transcaRecordTVC = [LSTranscationRecordTableViewController new];
    [self.navigationController pushViewController:transcaRecordTVC animated:YES];
}

#pragma mark - 充值按钮 监听
- (IBAction)recharge:(UIButton *)sender {
    
    // 设置背景色为默认
    [sender setBackgroundColor:[UIColor colorWithHexString:@"#30a5fc"]];
    
    [self.navigationController pushViewController:[[LSRechargeViewController alloc] init]animated:YES];
}

#pragma mark - 当按钮按下 改变背景颜色
- (IBAction)heightLight:(UIButton *)sender {
    
    [sender setBackgroundColor:[UIColor colorWithHexString:@"#0092ff"]];
}

#pragma mark - 提现按钮 监听
- (IBAction)withDrawal:(UIButton *)sender {
    
    [self.navigationController pushViewController:[[LSWithDrawalViewController alloc] init]animated:YES];
}

@end
