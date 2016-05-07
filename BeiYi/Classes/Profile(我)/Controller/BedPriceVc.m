//
//  BedPriceVc.m
//  BeiYi
//
//  Created by Joe on 15/9/11.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "BedPriceVc.h"
#import "Common.h"

@interface BedPriceVc ()
@property (nonatomic, strong) UITextField *txPrice;

@end

@implementation BedPriceVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZZBackgroundColor;
    self.title = @"床位价格";
    
    [self setUpUI];
}

- (void)setUpUI {
    
    // 1.设置导航栏右侧按钮
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame = CGRectMake(270, 0, 60, 40);
    [btnSave setTitle:@"保存" forState:UIControlStateNormal];
    btnSave.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnSave addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    
    // 2.1 背景-UIView
    UIView *bgView = [ZZUITool viewWithframe:CGRectMake(0, 64 +20, SCREEN_WIDTH, ZZBtnHeight) backGroundColor:[UIColor whiteColor] superView:self.view];

    
    // 2.2 提示图片-UIImageView
    CGFloat iconX = 10;
    CGFloat iconY = iconX;
    CGFloat iconH = ZZBtnHeight -iconY*2;
    UIImageView *icon = [ZZUITool imageViewWithframe:CGRectMake(iconX, iconY, iconH, iconH) imageName:@"addPatient" highlightImageName:nil superView:bgView];
    
    // 2.3 提示文字-UILabel
    UILabel *lblTips = [ZZUITool labelWithframe:CGRectMake(CGRectGetMaxX(icon.frame) +ZZMarins, iconY, SCREEN_WIDTH/3, iconH) Text:@"每个床位的价格" textColor:[UIColor blackColor] fontSize:15 superView:bgView];
    
    // 2.4 输入金额-UITextField
    CGFloat txPriceX = CGRectGetMaxX(lblTips.frame)+ZZMarins;
    CGFloat txPriceW = SCREEN_WIDTH - txPriceX -ZZMarins;
    UITextField *txPrice = [ZZUITool textFieldWithframe:CGRectMake(txPriceX, iconY, txPriceW, iconH) text:nil fontSize:15 placeholder:@"请输入金额" backgroundColor:[UIColor whiteColor] superView:bgView];
    txPrice.keyboardType = UIKeyboardTypeNumberPad;
    txPrice.textAlignment = NSTextAlignmentRight;
    self.txPrice = txPrice;
    
}

#pragma mark - 监听右侧保存按钮点击
- (void)save {
    ZZLog(@"---%@",self.txPrice.text);
    
    // 1.判断输入的字符是不是数字，如果不是，弹框提示
    if (!self.txPrice.text.length) {
        [MBProgressHUD showError:@"请输入价格!"];
        
    } else if (![self isPureInt:self.txPrice.text]) {
        ZZLog(@"不是纯数字！");
        [MBProgressHUD showError:@"请输入正确的价格!"];
        
    }else if ([self.txPrice.text floatValue] == 0.f){// 输入价格为0
        ZZLog(@"--纯数字！--输入价格为0");
        [MBProgressHUD showError:@"价格必须大于0"];
        
    }else {
        ZZLog(@"--纯数字！--%@",self.txPrice.text);
        
        [self loadHTTPRequest];
    }
    

}

- (void)loadHTTPRequest {
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/offer/save_offer_department",BASEURL];
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:self.txPrice.text forKey:@"price"];// 服务价格
    [params setObject:_arrIDs[0] forKey:@"hospital_id"];// 医院ID
    [params setObject:_arrIDs[1] forKey:@"department_id"];// 科室ID
    
    __weak typeof(self) weakSelf = self;
    
    // 2.发送网络请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"~~~%@~~~",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {// 如果操作成功
            
            [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:1] animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            });
            
        }else {
            [MBProgressHUD showError:@"发生未知错误."];
            
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"~~~%@~~~",error);
        
    }];
}

#pragma mark - 判断是不是纯数字
/**
 *  判断是不是纯数字
 */
- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

@end
