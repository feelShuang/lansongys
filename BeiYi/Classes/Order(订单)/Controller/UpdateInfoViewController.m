//
//  UpdateInfoViewController.m
//  BeiYi
//
//  Created by 刘爽 on 16/2/19.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "UpdateInfoViewController.h"
#import "SeclectVisitTimeTableViewController.h"
#import "Common.h"

@interface UpdateInfoViewController ()<selectVisitTimeDelegate,UITextViewDelegate>

// 描述凭证信息
@property (weak, nonatomic) IBOutlet UITextView *memoTextView;
// placeholder  Label
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
// 就诊时间提示
@property (weak, nonatomic) IBOutlet UILabel *visitTimeLabel;
// 就诊时间
@property (weak, nonatomic) IBOutlet UIButton *visiTimeButton;
// 服务天数 or 微信号
@property (weak, nonatomic) IBOutlet UILabel *weiXinHaoLabel;
// 天数 or 微信号
@property (weak, nonatomic) IBOutlet UITextField *weiXinHaoTextField;
// 天数 or 微信号背景
@property (weak, nonatomic) IBOutlet UIView *weiXinHaoBgView;
#pragma mark - 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weiXinHaoTopToVisitTime;
//
@property (nonatomic, strong) SeclectVisitTimeTableViewController *seclectVisitTimeTVC;
// 接收时间
@property (nonatomic, copy) NSString *timeStr;
// am or pm
@property (nonatomic, copy) NSString *timeAmOrPm;

//
@property (nonatomic, assign) BOOL isPush;

@end

@implementation UpdateInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 设置title
    self.title = @"提交凭证";
    
    // 设置导航条
    [self setUI];
    
    // 设置代理
    self.memoTextView.delegate = self;
    
    self.seclectVisitTimeTVC = [[SeclectVisitTimeTableViewController alloc] init];
    _seclectVisitTimeTVC.delegate = self;
    
    _isPush = NO;
    
    [self.visiTimeButton setTitle:@"请选择就诊时间" forState:UIControlStateNormal];
    
    self.weiXinHaoTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setUI {
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(0, 0, 50, 30);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnItemAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    if ([self.order_type isEqualToString:@"2"]) {
        
    }
    else if ([self.order_type isEqualToString:@"5"]) {
        self.visitTimeLabel.text = @"开始服务时间:";
        self.weiXinHaoLabel.text = @"微信号:";
        self.weiXinHaoTextField.placeholder = @"请填提供服务的微信号";
    }
    else {
        self.weiXinHaoBgView.hidden = YES;
    }
    
}

#pragma mark - 选择时间按钮监听
- (IBAction)seclectVisitTimeButtonAction:(UIButton *)sender {
    
    _seclectVisitTimeTVC.order_code = self.order_code;
    ZZLog(@"%@",self.visiTimeButton.titleLabel.text);
    _isPush = YES;
    [self.navigationController pushViewController:_seclectVisitTimeTVC animated:YES];
}

#pragma mark - 提交按钮事件
- (void)rightBtnItemAction {
    
    // 1. 准备请求网址
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/offer_complete",BASEURL];

    // 2. 创建请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:myAccount.token forKey:@"token"]; // 登陆标记
    [params setObject:self.order_code forKey:@"order_code"];
    [params setObject:self.memoTextView.text forKey:@"memo"]; // 凭证描述
    
    if ([self.order_type isEqualToString:@"1"]) {
        [params setObject:self.timeStr forKey:@"over_visit_time"]; // 就诊时间
        [params setObject:self.timeAmOrPm forKey:@"over_exact_type"]; // 就诊具体时间1-上午 2-下午
    }
    else if ([self.order_type isEqualToString:@"2"]) {
        [params setObject:self.timeStr forKey:@"over_visit_time"]; // 就诊时间
        [params setObject:self.weiXinHaoTextField.text forKey:@"over_visit_day"]; // 服务天数
    }
    else if ([self.order_type isEqualToString:@"3"]) {
        [params setObject:self.timeStr forKey:@"over_visit_time"]; // 就诊时间
    }
    else if ([self.order_type isEqualToString:@"4"]) {
        [params setObject:self.timeStr forKey:@"over_visit_time"]; // 取号日期
        [params setObject:self.timeAmOrPm forKey:@"over_exact_type"]; // 取号具体时间 1.上午 2.下午
    }
    else {
        [params setObject:self.weiXinHaoTextField.text forKey:@"over_weixin"]; // 取号日期
        [params setObject:self.timeStr forKey:@"over_start_time"]; // 开始服务时间
    }
    
    ZZLog(@"params = %@",params);
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(id responseObj) {
        ZZLog(@"---responseObj = %@",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            // 添加遮盖
            [MBProgressHUD showSuccess:responseObj[@"message"] toView:weakSelf.view];
        }
        else {
            // 添加遮盖
            [MBProgressHUD showError:responseObj[@"message"] toView:weakSelf.view];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"--error = %@",error);
        // 隐藏遮盖
        [MBProgressHUD hideHUDForView:weakSelf.view  animated:YES];
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
    }];
}

#pragma mark - selectVisitTimeDelegate
- (void)visitHospitalWithTime:(NSString *)time {
    
    // 设置visitTimeButton标题
    [self.visiTimeButton setTitle:time forState:UIControlStateNormal];
    [self.visiTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    NSString *ymdTime = [time substringToIndex:9];
    self.timeStr = ymdTime;
    
    if ([time hasSuffix:@"上午"]) {
        self.timeAmOrPm = @"1";
    }
    else {
        self.timeAmOrPm = @"2";
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    self.memoTextView = textView;
    // 借助Label实现placeholder效果
    if (textView.text.length == 0) {
        
    }
    else {
        _placeholderLabel.text = @"";
    }
    
}

#pragma mark - 隐藏键盘，UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [_memoTextView resignFirstResponder];
        
        return NO;
    }
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
