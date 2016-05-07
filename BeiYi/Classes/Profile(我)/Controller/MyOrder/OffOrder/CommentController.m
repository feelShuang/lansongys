//
//  CommentController.m
//  BeiYi
//
//  Created by Joe on 15/7/3.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "CommentController.h"
#import "ZZTextView.h"
#import "Common.h"
#import "LJStarView.h"

@interface CommentController ()<LJStarViewDelegate>
/** UITextField 评价内容 */
@property (nonatomic, strong) ZZTextView *txFieldDesc;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, strong) UIButton *btnScore;

@end

@implementation CommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZZBackgroundColor;
    self.title = @"评价";
    
    // 3.UITextView从顶部开始显示内容
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setUpUI];
}

- (void)setUpUI {
    // 1.bgView--背景View
    UIView *bgView = [ZZUITool viewWithframe:CGRectMake(0, 64, SCREEN_WIDTH, 260) backGroundColor: [UIColor whiteColor] superView:self.view];

    // 2.ZZTextView--服务评价
    ZZTextView *txView = [[ZZTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    txView.placeholder = @"对本次服务进行评价";
//    txView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:txView];
    self.txFieldDesc = txView;
    
    // 3.分割线
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, 120) width:SCREEN_WIDTH backGroundColor:[UIColor lightGrayColor] superView:bgView];
    
    // 4.评分显示
    UIButton *btnScore = [UIButton buttonWithType:UIButtonTypeCustom];
    btnScore.frame = CGRectMake(40, 150, 80, 80);
    btnScore.layer.cornerRadius = 40.0f;
    btnScore.layer.borderWidth = 1.0f;
    btnScore.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnScore.titleLabel.font = [UIFont systemFontOfSize:25];
    [btnScore setTitleColor:ZZBaseColor forState:UIControlStateNormal];
    [btnScore setTitle:@"0分" forState:UIControlStateNormal];
    btnScore.adjustsImageWhenHighlighted = NO;
    [bgView addSubview:btnScore];
    self.btnScore = btnScore;
    
    // 5.显示星星
    /*for (int i = 0; i < 5; i++) {
        UIButton *btnStar = [UIButton buttonWithType:UIButtonTypeCustom];
        btnStar.frame = CGRectMake(CGRectGetMaxX(btnScore.frame)+10+35*i, 175, 30, 30);
        [btnStar setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [btnStar setImage:[UIImage imageNamed:@"comment_clicked"] forState:UIControlStateSelected];
        [btnStar addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btnStar];
    }*/
    
    CGFloat starX = CGRectGetMaxX(btnScore.frame)+10;
    LJStarView *starView = [[LJStarView alloc] initWithFrame:CGRectMake(starX, 165, 234, 47)];
    starView.delegate = self;
    NSArray*path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSLog(@"%@",path[0]);
    [bgView addSubview:starView];
    
    // 6.评价按钮
    CGFloat x = ZZMarins;
    CGFloat w = (SCREEN_WIDTH - 2*ZZMarins);
    
    // 按钮
    UIButton *btn = [ZZUITool buttonWithframe:CGRectMake(x, 64+260+ZZMarins, w, ZZBtnHeight) title:@"评价" titleColor:nil backgroundColor:ZZButtonColor target:self action:@selector(commentBtnClicked) superView:self.view];
    btn.layer.cornerRadius = 3.0f;
    
}

#pragma mark - LJStarViewDelegate
- (void)starView:(LJStarView *)starView selecedStar:(NSString *)numStr
{
    ZZLog(@"%.1f",[numStr floatValue]);
    [self.btnScore setTitle:[NSString stringWithFormat:@"%@分",numStr] forState:UIControlStateNormal];
    self.score = numStr;
}

#pragma mark - 监听评价按钮
- (void)commentBtnClicked {
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/to_comment",BASEURL]; // 评价接口
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];// 登录token
    [params setObject:self.orderCode forKey:@"order_code"];// 订单编号
    [params setObject:self.score forKey:@"score"];// 评分1-5
    [params setObject:_txFieldDesc.text forKey:@"memo"];// 评论内容

    __weak typeof(self) weakSelf = self;
    
    // 2.发送post请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        
        // 2.1隐藏遮盖
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        // 2.2获取操作是否成功
        NSDictionary *resultDict = responseObj[@"result"];
        ZZLog(@"---点击确认/拒绝凭证 按钮---%@",resultDict);
        
        if ([responseObj[@"code"] isEqual:@"0000"]) {// 操作成功
            [MBProgressHUD showSuccess:responseObj[@"message"] toView:weakSelf.view];
            
            [weakSelf.navigationController popToViewController:weakSelf.navigationController.viewControllers[1] animated:YES];
            
        }else {// 操作失败
            [MBProgressHUD showError:responseObj[@"message"] toView:weakSelf.view];
            
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"抢单---%@",error);
        
        // 隐藏遮盖
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
    }];
}

@end
