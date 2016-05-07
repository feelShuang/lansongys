//
//  ApplyTheOrderController.m
//  BeiYi
//
//  Created by Joe on 15/6/25.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ApplyTheOrderController.h"
#import "Common.h"
#import "ZZTextView.h"

@interface ApplyTheOrderController ()
/** UITextView 申请 说明 */
@property (nonatomic, strong) ZZTextView *txView;
/** UIButton 有损退单 按钮 */
@property (nonatomic, strong) UIButton *btnReduce;
/** UIButton 无损退单 按钮 */
@property (nonatomic, strong) UIButton *btnNoReduce;

@end

@implementation ApplyTheOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.基本设置
    self.view.backgroundColor = ZZColor(245, 245, 245, 1);
    self.title = @"申请退单";
    [self setUpUI];
    
    // 2.UITextView从顶部开始显示内容
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setUpUI {
    
    // 1.UITextView 申请 描述
    _txView = [[ZZTextView alloc] initWithFrame:CGRectMake(10, 64 +ZZMarins, SCREEN_WIDTH -20, SCREEN_HEIGHT/4)];
    _txView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_txView];
    _txView.font = [UIFont systemFontOfSize:15];
    _txView.placeholder = @"请填写描述信息...";
    _txView.textAlignment = NSTextAlignmentLeft;
    
    // 2.UIView 退单方式 背景
    UIView *applyBackVeiw = [ZZUITool viewWithframe:CGRectMake(10, CGRectGetMaxY(_txView.frame) +ZZMarins, SCREEN_WIDTH -20, 80) backGroundColor:[UIColor whiteColor] superView:self.view];
    
    // 3.UILabel 提示：退单价格的20%
    UILabel *lblTipLeft = [ZZUITool labelWithframe:CGRectMake(10, 5, SCREEN_WIDTH/2, 30) Text:@"订单价格的20%" textColor:[UIColor blackColor]  fontSize:(CGFloat)15 superView:applyBackVeiw];
    lblTipLeft.textAlignment = NSTextAlignmentLeft;
    
    // 4.水平分割线1
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, 40) width:SCREEN_WIDTH -20 backGroundColor:ZZBackgroundColor superView:applyBackVeiw];
    
    // 5.UILabel 提示：无损退单
    UILabel *lblAliPay = [ZZUITool labelWithframe:CGRectMake(10, 45, SCREEN_WIDTH/2, 30) Text:@"无损退单" textColor:[UIColor blackColor]  fontSize:(CGFloat)15 superView:applyBackVeiw];
    lblAliPay.textAlignment = NSTextAlignmentLeft;
    
    // 6.UIButton 损失20% -- 退单按钮
    _btnReduce = [ZZUITool buttonWithframe:CGRectMake(CGRectGetMaxX(applyBackVeiw.frame) -50, 0, 40, 40) title:nil titleColor:nil backgroundColor:nil target:self action:@selector(applyReduce) superView:applyBackVeiw];
    [_btnReduce setImage:[UIImage imageNamed:@"OKBtn"] forState:UIControlStateNormal];
    [_btnReduce setImage:[UIImage imageNamed:@"OKBtn_Clicked"] forState:UIControlStateSelected];
    
    // 8.UIButton 无损 -- 退单按钮
    _btnNoReduce = [ZZUITool buttonWithframe:CGRectMake(CGRectGetMaxX(applyBackVeiw.frame) -50, 40, 40, 40) title:nil titleColor:nil backgroundColor:nil target:self action:@selector(applyNoReduce) superView:applyBackVeiw];
    [_btnNoReduce setImage:[UIImage imageNamed:@"OKBtn"] forState:UIControlStateNormal];
    [_btnNoReduce setImage:[UIImage imageNamed:@"OKBtn_Clicked"] forState:UIControlStateSelected];
    
    // 默认选择 有损退单 按钮
    [self applyReduce];
    
    // 9.设置导航栏右侧按钮
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame = CGRectMake(270, 0, 60, 40);
    [btnSave setTitle:@"确定" forState:UIControlStateNormal];
    btnSave.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnSave addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
}

#pragma mark - 监听 有损退单-按钮 点击
- (void)applyReduce {
    self.btnReduce.selected = YES;
    self.btnNoReduce.selected = NO;
}

#pragma mark - 监听 无损退单-按钮 点击
- (void)applyNoReduce {
    self.btnNoReduce.selected = YES;
    self.btnReduce.selected = NO;
}

#pragma mark - 监听右侧 确定按钮 点击
- (void)submit {
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/refund",BASEURL];
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:self.orderCode forKey:@"order_code"];// 订单编号
    
    // 退款赔付类型1-无损退单2-订单价格百分20
    if (self.btnReduce.selected) {
        [params setObject:@2 forKey:@"refund_type"];
    }else {
        [params setObject:@1 forKey:@"refund_type"];
    }
    
    [params setObject:self.txView.text forKey:@"reason"];// 退单原因
    
    __weak typeof(self) weakSelf = self;
    
    // 2.发送网络请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"~~~退单~~~%@",responseObj);
        
        if ([responseObj[@"code"] isEqual:@"0000"]) {// 操作成功
            [MBProgressHUD showSuccess:responseObj[@"message"]];
            [weakSelf.navigationController popToViewController:weakSelf.navigationController.viewControllers[1] animated:YES];
            
        }else {
            [MBProgressHUD showSuccess:responseObj[@"message"]];

        }
        
    } failure:^(NSError *error) {
        ZZLog(@"~~~退单~~~%@",error);
        
    }];
}
@end
