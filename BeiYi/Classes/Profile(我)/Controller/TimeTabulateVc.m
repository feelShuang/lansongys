//
//  TimeTabulateVc.m
//  BeiYi
//
//  Created by Joe on 15/9/14.
//  Copyright (c) 2015年 Joe. All rights reserved.
//
#define ZZUserDefaults [NSUserDefaults standardUserDefaults]
#define PlanWeekPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PlanWeeks"]

#import "TimeTabulateVc.h"
#import "Common.h"
#import "TimeTabulate.h"
#import "TimeTabulateTotal.h"
#import "PlanDay.h"
#import "PlanWeek.h"
#import "MJExtension.h"

@interface TimeTabulateVc ()

/** NSInteger 按钮点击计数 */
@property (nonatomic, assign) NSInteger count;
/**  UILabel 切换/显示日期 */
@property (nonatomic, strong) UILabel *lblTime;
/**  UIButton 左边按钮 */
@property (nonatomic, strong) UIButton *btnLeft;
/**  UIButton 右边按钮 */
@property (nonatomic, strong) UIButton *btnRight;
/**  UITextField 价格 */
@property (nonatomic, strong) UITextField *txPrice;
/**  NSArray TimeTabulate模型的数组 */
@property (nonatomic, strong) NSArray *weekList;
/**  UILabel 第一天 */
@property (nonatomic, strong) UILabel *lblDayOne;
/**  UILabel 第二天 */
@property (nonatomic, strong) UILabel *lblDayTwo;
/**  UILabel 第三天 */
@property (nonatomic, strong) UILabel *lblDayThree;
/**  UILabel 第四天 */
@property (nonatomic, strong) UILabel *lblDayFour;
/**  UILabel 第五天 */
@property (nonatomic, strong) UILabel *lblDayFive;
/**  UILabel 第六天 */
@property (nonatomic, strong) UILabel *lblDaySix;
/**  UILabel 第七天 */
@property (nonatomic, strong) UILabel *lblDaySeven;
/**  UILabel 第一天已经用过的号的数量 */
@property (nonatomic, strong) UILabel *lblUsedOne;
/**  UILabel 第二天已经用过的号的数量 */
@property (nonatomic, strong) UILabel *lblUsedTwo;
/**  UILabel 第三天已经用过的号的数量 */
@property (nonatomic, strong) UILabel *lblUsedThree;
/**  UILabel 第四天已经用过的号的数量 */
@property (nonatomic, strong) UILabel *lblUsedFour;
/**  UILabel 第五天已经用过的号的数量 */
@property (nonatomic, strong) UILabel *lblUsedFive;
/**  UILabel 第六天已经用过的号的数量 */
@property (nonatomic, strong) UILabel *lblUsedSix;
/**  UILabel 第七天已经用过的号的数量 */
@property (nonatomic, strong) UILabel *lblUsedSeven;
/**  UITextField 输入第1天的号的数量 */
@property (nonatomic, strong) UITextField *txOne;
/**  UITextField 输入第2天的号的数量 */
@property (nonatomic, strong) UITextField *txTwo;
/**  UITextField 输入第3天的号的数量 */
@property (nonatomic, strong) UITextField *txThree;
/**  UITextField 输入第4天的号的数量 */
@property (nonatomic, strong) UITextField *txFour;
/**  UITextField 输入第5天的号的数量 */
@property (nonatomic, strong) UITextField *txFive;
/**  UITextField 输入第6天的号的数量 */
@property (nonatomic, strong) UITextField *txSix;
/**  UITextField 输入第7天的号的数量 */
@property (nonatomic, strong) UITextField *txSeven;

/**  NSString 第一天 */
@property (nonatomic, copy) NSString *startDay;
/**  NSString 最后一天 */
@property (nonatomic, copy) NSString *endDay;

@property (nonatomic, strong) PlanWeek *week1;
@property (nonatomic, strong) PlanWeek *week2;
@property (nonatomic, strong) PlanWeek *week3;
@property (nonatomic, strong) PlanWeek *week4;
@property (nonatomic, strong) NSMutableArray *weekArray;

@end

@implementation TimeTabulateVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.ControllerTitle;
    self.view.backgroundColor = ZZBackgroundColor;
    
    // 1.设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self btnWithFrame:CGRectMake(SCREEN_WIDTH - 40 -10, 25, 50, 40)]];
    
    [self setUpUI];
    
    self.weekArray = [NSMutableArray array];

    self.count = 1;
    [self btnLeftClicked];
}

#pragma mark - 创建导航栏右侧按钮
- (UIButton *)btnWithFrame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

#pragma mark - 监听"保存"按钮点击
- (void)saveBtnClicked {
//    ZZLog(@"保存");
    ZZLog(@"---self.week1:---%@",self.week1);
    ZZLog(@"---self.week2:---%@",self.week2);
    ZZLog(@"---self.week3:---%@",self.week3);
    ZZLog(@"---self.week4:---%@",self.week4);
    
    ZZLog(@"---是否包含self.week1：%d---",[self.weekArray containsObject:self.week1]);

    if (self.week1 == nil) {// week1不存在
        ZZLog(@"---week1不存在---");

    }else {
        ZZLog(@"---week1存在---");
        [self.weekArray removeObject:self.week1];
    }
    
    
    ZZLog(@"---点击保存按钮---%ld---%@",(unsigned long)self.weekArray.count,self.weekArray);
    
    PlanWeek *week = [NSKeyedUnarchiver unarchiveObjectWithFile:PlanWeekPath];
    ZZLog(@"---unarchiveObjectWithFile:---%@",week.start);

    /*
    // 1.判断是否输入了价格/价格是否大于1元
    if ([self.txPrice.text floatValue] < 1.0f) {
        [MBProgressHUD showError:@"请输入正确的价格(金额必须大于1元)"];
        return;
    }
     
    NSArray *plan = [PlanWeek keyValuesArrayWithObjectArray:self.weekArray];
    ZZLog(@"----%@---",plan);
    
    
    // 准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/offer/offer_submit",BASEURL];// 提供者服务设置提交
    
    NSDictionary *data = @{@"doctor_id" : self.doctorID,
                           @"service_type" : self.typeNum,
                           @"price" : self.txPrice.text,
                           @"plan" : plan,
                           };
    NSDictionary *params = @{@"token" : myAccount.token,
                             @"data" :data
                             };
    
    // 进行网络请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"----上传结果：%@---",responseObj);
    } failure:^(NSError *error) {
        ZZLog(@"%@",error);
    }];*/
    
}

#pragma mark - 界面设置
- (void)setUpUI {
    
    CGFloat lblTimeW = SCREEN_WIDTH/2;
    CGFloat lblTImeX = SCREEN_WIDTH/2 - lblTimeW/2;
    
    // 1.UILabel 切换/显示日期
    UILabel *lblTime = [ZZUITool labelWithframe:CGRectMake(lblTImeX, 64 +ZZMarins/2, lblTimeW, ZZBtnHeight) Text:nil textColor:ZZBaseColor fontSize:15.f superView:self.view];
    lblTime.textAlignment = NSTextAlignmentCenter;
    self.lblTime = lblTime;
    
    CGFloat buttonY = 64 +ZZMarins/2 +ZZBtnHeight/4;
    // 2.UIButton 左边按钮
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(CGRectGetMinX(lblTime.frame) -35, buttonY, ZZBtnHeight/2, ZZBtnHeight/2);
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"TimeTabulate-Left01"] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"TimeTabulate-Left02"] forState:UIControlStateDisabled];
    btnLeft.adjustsImageWhenHighlighted = NO;
    [btnLeft addTarget:self action:@selector(btnLeftClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLeft];
    self.btnLeft = btnLeft;
    
    // 3.UIButton 右边按钮
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(CGRectGetMaxX(lblTime.frame) +5, buttonY, ZZBtnHeight/2, ZZBtnHeight/2);
    [btnRight setBackgroundImage:[UIImage imageNamed:@"TimeTabulate-Right01"] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"TimeTabulate-Right02"] forState:UIControlStateDisabled];
    btnRight.adjustsImageWhenHighlighted = NO;
    [btnRight addTarget:self action:@selector(btnRightClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRight];
    self.btnRight = btnRight;
    
    CGFloat gridH = ZZBtnHeight*1.2;// 每个格子的高度
    CGFloat gridW = SCREEN_WIDTH/8;
    CGFloat bgViewH = gridH *3;
    
    // 4.时间排表View
    UIView *bgView = [ZZUITool viewWithframe:CGRectMake(0, CGRectGetMaxY(lblTime.frame) +ZZMarins, SCREEN_WIDTH, bgViewH) backGroundColor:[UIColor whiteColor] superView:self.view];
    
    // 4.1 分割线
    // 水平分割线 2 条
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, gridH) width:SCREEN_WIDTH backGroundColor:ZZBackgroundColor superView:bgView];
    
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, gridH*2) width:SCREEN_WIDTH backGroundColor:ZZBackgroundColor superView:bgView];
    
    // 竖直分割线 7 条
    [ZZUITool lineVerticalWithPosition:CGPointMake(gridW, 0) height:bgViewH backGroundColor:ZZBackgroundColor superView:bgView];
    
    [ZZUITool lineVerticalWithPosition:CGPointMake(gridW*2, 0) height:bgViewH backGroundColor:ZZBackgroundColor superView:bgView];
    
    [ZZUITool lineVerticalWithPosition:CGPointMake(gridW*3, 0) height:bgViewH backGroundColor:ZZBackgroundColor superView:bgView];
    
    [ZZUITool lineVerticalWithPosition:CGPointMake(gridW*4, 0) height:bgViewH backGroundColor:ZZBackgroundColor superView:bgView];
    
    [ZZUITool lineVerticalWithPosition:CGPointMake(gridW*5, 0) height:bgViewH backGroundColor:ZZBackgroundColor superView:bgView];
    
    [ZZUITool lineVerticalWithPosition:CGPointMake(gridW*6, 0) height:bgViewH backGroundColor:ZZBackgroundColor superView:bgView];
    
    [ZZUITool lineVerticalWithPosition:CGPointMake(gridW*7, 0) height:bgViewH backGroundColor:ZZBackgroundColor superView:bgView];
    
    // 4.2 UILabel - 已用，全部
    UILabel *lblTip1 = [ZZUITool labelWithframe:CGRectMake(0, gridH*(1+0.25), gridW, gridH/2) Text:@"已用" textColor:[UIColor darkGrayColor] fontSize:14.f superView:bgView];
    lblTip1.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lblTip2 = [ZZUITool labelWithframe:CGRectMake(0, gridH*(2+0.25), gridW, gridH/2) Text:@"全部" textColor:[UIColor darkGrayColor] fontSize:14.f superView:bgView];
    lblTip2.textAlignment = NSTextAlignmentCenter;
    
    CGFloat weekY = gridH *0.1;
    CGFloat weekHeight = gridH *0.4;

    //4.3 UILabel - 周一～周日
    UILabel *lblMonday = [ZZUITool labelWithframe:CGRectMake(gridW, weekY, gridW, weekHeight) Text:@"周一" textColor:[UIColor darkGrayColor] fontSize:14.f superView:bgView];
    lblMonday.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lblTuesday = [ZZUITool labelWithframe:CGRectMake(gridW*2, weekY, gridW, weekHeight) Text:@"周二" textColor:[UIColor darkGrayColor] fontSize:14.f superView:bgView];
    lblTuesday.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lblWednesday = [ZZUITool labelWithframe:CGRectMake(gridW*3, weekY, gridW, weekHeight) Text:@"周三" textColor:[UIColor darkGrayColor] fontSize:14.f superView:bgView];
    lblWednesday.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lblThursday = [ZZUITool labelWithframe:CGRectMake(gridW*4, weekY, gridW, weekHeight) Text:@"周四" textColor:[UIColor darkGrayColor] fontSize:14.f superView:bgView];
    lblThursday.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lblFriday = [ZZUITool labelWithframe:CGRectMake(gridW*5, weekY, gridW, weekHeight) Text:@"周五" textColor:[UIColor darkGrayColor] fontSize:14.f superView:bgView];
    lblFriday.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lblSaturday = [ZZUITool labelWithframe:CGRectMake(gridW*6, weekY, gridW, weekHeight) Text:@"周六" textColor:[UIColor darkGrayColor] fontSize:14.f superView:bgView];
    lblSaturday.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lblSunday = [ZZUITool labelWithframe:CGRectMake(gridW*7, weekY, gridW, weekHeight) Text:@"周日" textColor:[UIColor darkGrayColor] fontSize:14.f superView:bgView];
    lblSunday.textAlignment = NSTextAlignmentCenter;
    
    CGFloat dayY = CGRectGetMaxY(lblSunday.frame);
    CGFloat dayHeight = gridH *0.4;
    
    // 4.4 周一到周日对应的时间 UILabel
    self.lblDayOne = [ZZUITool labelWithframe:CGRectMake(gridW, dayY, gridW, dayHeight) Text:@"" textColor:[UIColor darkGrayColor] fontSize:13.f superView:bgView];
    self.lblDayOne.textAlignment = NSTextAlignmentCenter;
    
    self.lblDayTwo = [ZZUITool labelWithframe:CGRectMake(gridW*2, dayY, gridW, dayHeight) Text:@"" textColor:[UIColor darkGrayColor] fontSize:13.f superView:bgView];
    self.lblDayTwo.textAlignment = NSTextAlignmentCenter;
    
    self.lblDayThree = [ZZUITool labelWithframe:CGRectMake(gridW*3, dayY, gridW, dayHeight) Text:@"" textColor:[UIColor darkGrayColor] fontSize:13.f superView:bgView];
    self.lblDayThree.textAlignment = NSTextAlignmentCenter;
    
    self.lblDayFour = [ZZUITool labelWithframe:CGRectMake(gridW*4, dayY, gridW, dayHeight) Text:@"" textColor:[UIColor darkGrayColor] fontSize:13.f superView:bgView];
    self.lblDayFour.textAlignment = NSTextAlignmentCenter;
    
    self.lblDayFive = [ZZUITool labelWithframe:CGRectMake(gridW*5, dayY, gridW, dayHeight) Text:@"" textColor:[UIColor darkGrayColor] fontSize:13.f superView:bgView];
    self.lblDayFive.textAlignment = NSTextAlignmentCenter;
    
    self.lblDaySix = [ZZUITool labelWithframe:CGRectMake(gridW*6, dayY, gridW, dayHeight) Text:@"" textColor:[UIColor darkGrayColor] fontSize:13.f superView:bgView];
    self.lblDaySix.textAlignment = NSTextAlignmentCenter;
    
    self.lblDaySeven = [ZZUITool labelWithframe:CGRectMake(gridW*7, dayY, gridW, dayHeight) Text:@"" textColor:[UIColor darkGrayColor] fontSize:13.f superView:bgView];
    self.lblDaySeven.textAlignment = NSTextAlignmentCenter;
    
    CGFloat lblUsedY = lblTip1.frame.origin.y;
    CGFloat lblUsedH = lblTip1.frame.size.height;
    
    // 4.5已经使用的号的数量 UILabel
    self.lblUsedOne = [ZZUITool labelWithframe:CGRectMake(gridW, lblUsedY, gridW, lblUsedH) Text:@"null" textColor:[UIColor darkGrayColor] fontSize:14.f superView:bgView];
    self.lblUsedOne.textAlignment = NSTextAlignmentCenter;
    
    self.lblUsedTwo = [ZZUITool labelWithframe:CGRectMake(gridW*2, lblUsedY, gridW, lblUsedH) Text:@"null" textColor:[UIColor darkGrayColor] fontSize:14.f superView:bgView];
    self.lblUsedTwo.textAlignment = NSTextAlignmentCenter;
    
    self.lblUsedThree = [ZZUITool labelWithframe:CGRectMake(gridW*3, lblUsedY, gridW, lblUsedH) Text:@"null" textColor:[UIColor darkGrayColor] fontSize:14.f superView:bgView];
    self.lblUsedThree.textAlignment = NSTextAlignmentCenter;
    
    self.lblUsedFour = [ZZUITool labelWithframe:CGRectMake(gridW*4, lblUsedY, gridW, lblUsedH) Text:@"null" textColor:[UIColor darkGrayColor] fontSize:14.f superView:bgView];
    self.lblUsedFour.textAlignment = NSTextAlignmentCenter;
    
    self.lblUsedFive = [ZZUITool labelWithframe:CGRectMake(gridW*5, lblUsedY, gridW, lblUsedH) Text:@"null" textColor:[UIColor darkGrayColor] fontSize:14.f superView:bgView];
    self.lblUsedFive.textAlignment = NSTextAlignmentCenter;
    
    self.lblUsedSix = [ZZUITool labelWithframe:CGRectMake(gridW*6, lblUsedY, gridW, lblUsedH) Text:@"null" textColor:[UIColor darkGrayColor] fontSize:14.f superView:bgView];
    self.lblUsedSix.textAlignment = NSTextAlignmentCenter;
    
    self.lblUsedSeven = [ZZUITool labelWithframe:CGRectMake(gridW*7, lblUsedY, gridW, lblUsedH) Text:@"null" textColor:[UIColor darkGrayColor] fontSize:14.f superView:bgView];
    self.lblUsedSeven.textAlignment = NSTextAlignmentCenter;
    
    CGFloat txFieldY = lblTip2.frame.origin.y;
    CGFloat txFieldH = lblTip2.frame.size.height;
    
    self.txOne = [ZZUITool textFieldWithframe:CGRectMake(gridW, txFieldY, gridW, txFieldH) text:@"null" fontSize:14.f placeholder:nil backgroundColor:nil superView:bgView];
    self.txOne.textAlignment = NSTextAlignmentCenter;
    self.txOne.keyboardType = UIKeyboardTypeNumberPad;
    self.txOne.clearsOnBeginEditing = YES;
    
    self.txTwo = [ZZUITool textFieldWithframe:CGRectMake(gridW*2, txFieldY, gridW, txFieldH) text:@"null" fontSize:14.f placeholder:nil backgroundColor:nil superView:bgView];
    self.txTwo.textAlignment = NSTextAlignmentCenter;
    self.txTwo.keyboardType = UIKeyboardTypeNumberPad;
    self.txTwo.clearsOnBeginEditing = YES;

    self.txThree = [ZZUITool textFieldWithframe:CGRectMake(gridW*3, txFieldY, gridW, txFieldH) text:@"null" fontSize:14.f placeholder:nil backgroundColor:nil superView:bgView];
    self.txThree.textAlignment = NSTextAlignmentCenter;
    self.txThree.keyboardType = UIKeyboardTypeNumberPad;
    self.txThree.clearsOnBeginEditing = YES;

    self.txFour = [ZZUITool textFieldWithframe:CGRectMake(gridW*4, txFieldY, gridW, txFieldH) text:@"null" fontSize:14.f placeholder:nil backgroundColor:nil superView:bgView];
    self.txFour.textAlignment = NSTextAlignmentCenter;
    self.txFour.keyboardType = UIKeyboardTypeNumberPad;
    self.txFour.clearsOnBeginEditing = YES;

    self.txFive = [ZZUITool textFieldWithframe:CGRectMake(gridW*5, txFieldY, gridW, txFieldH) text:@"null" fontSize:14.f placeholder:nil backgroundColor:nil superView:bgView];
    self.txFive.textAlignment = NSTextAlignmentCenter;
    self.txFive.keyboardType = UIKeyboardTypeNumberPad;
    self.txFive.clearsOnBeginEditing = YES;

    self.txSix = [ZZUITool textFieldWithframe:CGRectMake(gridW*6, txFieldY, gridW, txFieldH) text:@"null" fontSize:14.f placeholder:nil backgroundColor:nil superView:bgView];
    self.txSix.textAlignment = NSTextAlignmentCenter;
    self.txSix.keyboardType = UIKeyboardTypeNumberPad;
    self.txSix.clearsOnBeginEditing = YES;

    self.txSeven = [ZZUITool textFieldWithframe:CGRectMake(gridW*7, txFieldY, gridW, txFieldH) text:@"null" fontSize:14.f placeholder:nil backgroundColor:nil superView:bgView];
    self.txSeven.textAlignment = NSTextAlignmentCenter;
    self.txSeven.keyboardType = UIKeyboardTypeNumberPad;
    self.txSeven.clearsOnBeginEditing = YES;

    
    // 5.1 价格背景-UIView
    UIView *priceBgView = [ZZUITool viewWithframe:CGRectMake(0, CGRectGetMaxY(bgView.frame) +ZZMarins, SCREEN_WIDTH, ZZBtnHeight) backGroundColor:[UIColor whiteColor] superView:self.view];
    
    // 5.2 提示图片-UIImageView
    CGFloat iconX = 10;
    CGFloat iconY = iconX;
    CGFloat iconH = ZZBtnHeight -iconY*2;
    UIImageView *icon = [ZZUITool imageViewWithframe:CGRectMake(iconX, iconY, iconH, iconH) imageName:@"addPatient" highlightImageName:nil superView:priceBgView];
    
    // 5.3 提示文字-UILabel
    UILabel *lblTips = [ZZUITool labelWithframe:CGRectMake(CGRectGetMaxX(icon.frame) +ZZMarins, iconY, SCREEN_WIDTH/3, iconH) Text:@"每个号的价格" textColor:[UIColor blackColor] fontSize:15 superView:priceBgView];
    
    // 5.4 输入金额-UITextField
    CGFloat txPriceX = CGRectGetMaxX(lblTips.frame)+ZZMarins;
    CGFloat txPriceW = SCREEN_WIDTH - txPriceX -ZZMarins;
    UITextField *txPrice = [ZZUITool textFieldWithframe:CGRectMake(txPriceX, iconY, txPriceW, iconH) text:nil fontSize:15 placeholder:@"请输入金额" backgroundColor:[UIColor whiteColor] superView:priceBgView];
    txPrice.keyboardType = UIKeyboardTypeNumberPad;
    txPrice.textAlignment = NSTextAlignmentRight;
    self.txPrice = txPrice;
}

#pragma mark -
#pragma mark 点击向左按钮
- (void)btnLeftClicked {
    // 1.点击计数
    _count --;
    self.btnLeft.enabled = (self.count != 0);
    self.btnRight.enabled = (self.count != 3);
    ZZLog(@"---count--%ld",(long)_count);
    
    // 2.获取当前时间，格式为："yyyy-MM-dd"
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowStr = [dateFormatter stringFromDate:[NSDate date]];
    ZZLog(@"---nowStr：%@",nowStr);
    
    // 3.点击按钮加载网络获取上周数据
    if ([self.startDay length] == 0) {// 可以保证第一次进入时左边按钮不可点击
        [self loadHTTPForTime:nowStr type:@"2"];
    
    }else {
        [self loadHTTPForTime:self.startDay type:@"1"];// 1代表上周
    }
    
    if (self.startDay) {
        // 4.保存数据
        [self saveDataWithCount:_count];
    }
}

#pragma mark 点击向右按钮
- (void)btnRightClicked {
    // 1.点击计数
    _count ++;
    self.btnLeft.enabled = (self.count != 0);
    self.btnRight.enabled = (self.count != 3);
    ZZLog(@"---count--%ld",(long)_count);

    // 2.点击按钮加载网络获取下周数据
    [self loadHTTPForTime:self.endDay type:@"2"];
    
    // 3.保存数据
    [self saveDataWithCount:_count];
}

#pragma mark  根据点击count  保存数据
/**
 *  保存数据
 *
 *  @param count 基数：_count
 */
- (void)saveDataWithCount:(NSInteger )count {
    switch (count) {
        case 0: {
            PlanWeek *week1 = [self savePlanWeek];
            self.week1 = week1;
//            [NSKeyedArchiver archiveRootObject:week1 toFile:PlanWeekPath];
            
            
//            [self.weekArray addObject:self.week1];
//            ZZLog(@"---self.weekArray---%@",self.weekArray);
            break;
        }
        case 1:{
            PlanWeek *week2 = [self savePlanWeek];
            self.week2 = week2;
//            [NSKeyedArchiver archiveRootObject:week2 toFile:PlanWeekPath];

            
//            [self.weekArray addObject:self.week2];
//            ZZLog(@"---self.weekArray---%@",self.weekArray);
            break;
        }
            
        case 2:{
            PlanWeek *week3 = [self savePlanWeek];
            self.week3 = week3;
//            [NSKeyedArchiver archiveRootObject:week3 toFile:PlanWeekPath];

            
//            [self.weekArray addObject:self.week3];
//            ZZLog(@"---self.weekArray---%@",self.weekArray);
            break;
        }
            
        case 3:{// 无效，不可点击
            PlanWeek *week4 = [self savePlanWeek];
            self.week4 = week4;
//            [NSKeyedArchiver archiveRootObject:week4 toFile:PlanWeekPath];

            
//            [self.weekArray addObject:self.week4];
//            ZZLog(@"---self.weekArray---%@",self.weekArray);
            break;
        }
            
    }
}
#pragma mark  保存一周数据
/**
 *  保存一周数据
 */
- (PlanWeek *)savePlanWeek {
    PlanWeek *week = [[PlanWeek alloc] init];
    week.start = self.startDay;
    week.end = self.endDay;
    
    PlanDay *day1 = [[PlanDay alloc] init];
    day1.week = @"1";
    day1.week_date = self.startDay;
    day1.number = self.txOne.text;
    
    PlanDay *day2 = [[PlanDay alloc] init];
    day2.week = @"2";
    day2.week_date = [self getNewDateWithWeek:day2.week];
    day2.number = self.txTwo.text;
    
    PlanDay *day3 = [[PlanDay alloc] init];
    day3.week = @"3";
    day3.week_date = [self getNewDateWithWeek:day3.week];
    day3.number = self.txThree.text;
    
    PlanDay *day4 = [[PlanDay alloc] init];
    day4.week = @"4";
    day4.week_date = [self getNewDateWithWeek:day4.week];
    day4.number = self.txFour.text;
    
    PlanDay *day5 = [[PlanDay alloc] init];
    day5.week = @"5";
    day5.week_date = [self getNewDateWithWeek:day5.week];
    day5.number = self.txFive.text;
    
    PlanDay *day6 = [[PlanDay alloc] init];
    day6.week = @"6";
    day6.week_date = [self getNewDateWithWeek:day6.week];
    day6.number = self.txSix.text;
    
    PlanDay *day7 = [[PlanDay alloc] init];
    day7.week = @"7";
    day7.week_date = [self getNewDateWithWeek:day7.week];
    day7.number = self.txSeven.text;
    
    week.detail = @[day1,day2,day3,day4,day5,day6, day7];
    
    return week;
}

#pragma mark 计算时间
/**
 *  计算时间
 *
 *  @param week 第几天（一周里的第几天）
 *
 *  @return NSString 格式为："2015-10-10"
 */
- (NSString *)getNewDateWithWeek:(NSString *)week {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDay = [formatter dateFromString:self.startDay];
    
    NSDate *newDate = [[NSDate alloc] initWithTimeInterval:3600*24*[week integerValue] sinceDate:startDay];
    
    return [formatter stringFromDate:newDate];
}

#pragma mark - 根据时间和类型获取网络数据
/**
 *  根据时间和类型获取网络数据
 *
 *  @param dateStr 将NSDateFormatter类型为@"yyyy-MM-dd"转换成字符串
 *  @param type    类型1-上周 2-下周
 */
- (void)loadHTTPForTime:(NSString *)dateStr type:(NSString *)type {
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    // 准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/offer/plan",BASEURL];// 经纪人排表日期列表
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];// 登录token
    [params setObject:type forKey:@"type"];// 类型1-上周 2-下周
    [params setObject:self.doctorID forKey:@"doctor_id"];// 医生ID，非必填
    [params setObject:dateStr forKey:@"date"];// 日期

    __weak typeof(self) weakSelf = self;
    
    // 发送post请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        
        // 隐藏遮盖
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        ZZLog(@"---排表时间---%@",responseObj);

        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            
            // 1.获取数据模型
            TimeTabulateTotal *tabulate = [TimeTabulateTotal tabulateTotalWithDict:responseObj[@"result"]];
//            ZZLog(@"---排表时间---%@",tabulate);
            
            // 2.设置按钮中间显示的时间（2015-09-20～2015-09-27）
            NSString *timeStr = [NSString stringWithFormat:@"%@~%@",tabulate.start,tabulate.end];
            weakSelf.lblTime.text = timeStr;
            
            // 3.设置开始时间和结束时间
            weakSelf.startDay = tabulate.start;
            weakSelf.endDay = tabulate.end;
            ZZLog(@"---开始时间：%@---结束时间：%@",weakSelf.startDay,weakSelf.endDay);

            // 4.设置其他数据
            if (tabulate.weekList.count == 7) {// 数组里有数据,有就会有7个
                
                // 4.0 赋值
                weakSelf.weekList = tabulate.weekList;
                ZZLog(@"---全部号个数---%zi",[tabulate.weekList[0] planNumber]);

                // 4.1 设置显示时间（10-10）
                [weakSelf setTimeShow];
                
                // 4.2 设置 已经使用的号 的数量
                [weakSelf setNumOfUsed];
                
                // 4.3 设置 全部号 的数量
                [weakSelf setPlanOfUsed];
            
            }else {
                [MBProgressHUD showError:@"数据错误"];
                
            }
            
        }else {
            [MBProgressHUD showError:responseObj[@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        ZZLog(@"抢单---%@",error);
        
        // 隐藏遮盖
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:@"网络错误，请重试" toView:weakSelf.view];
    }];

}

#pragma mark - 设置显示时间（10-10）
/**
 *  设置显示时间（10-10）
 */
- (void)setTimeShow {
    __weak typeof(self) weakSelf = self;

    weakSelf.lblDayOne.text = [weakSelf.weekList[0] showDate];
    weakSelf.lblDayTwo.text = [weakSelf.weekList[1] showDate];
    weakSelf.lblDayThree.text = [weakSelf.weekList[2] showDate];
    weakSelf.lblDayFour.text = [weakSelf.weekList[3] showDate];
    weakSelf.lblDayFive.text = [weakSelf.weekList[4] showDate];
    weakSelf.lblDaySix.text = [weakSelf.weekList[5] showDate];
    weakSelf.lblDaySeven.text = [weakSelf.weekList[6] showDate];
}

#pragma mark - 设置 已经使用的号 的数量
/**
 *  设置 已经使用的号 的数量
 */
- (void)setNumOfUsed {
    __weak typeof(self) weakSelf = self;

    
    weakSelf.lblUsedOne.text = [NSString stringWithFormat:@"%ld",(long)[weakSelf.weekList[0] usedNumber]];
    weakSelf.lblUsedTwo.text = [NSString stringWithFormat:@"%ld",(long)[weakSelf.weekList[1] usedNumber]];
    weakSelf.lblUsedThree.text = [NSString stringWithFormat:@"%ld",(long)[weakSelf.weekList[2] usedNumber]];
    weakSelf.lblUsedFour.text = [NSString stringWithFormat:@"%ld",(long)[weakSelf.weekList[3] usedNumber]];
    weakSelf.lblUsedFive.text = [NSString stringWithFormat:@"%ld",(long)[weakSelf.weekList[4] usedNumber]];
    weakSelf.lblUsedSix.text = [NSString stringWithFormat:@"%ld",(long)[weakSelf.weekList[5] usedNumber]];
    weakSelf.lblUsedSeven.text = [NSString stringWithFormat:@"%ld",(long)[weakSelf.weekList[6] usedNumber]];
}

#pragma mark - 设置 全部号 的数量
/**
 *  设置  全部号 的数量
 */
- (void)setPlanOfUsed {
    __weak typeof(self) weakSelf = self;
    
    weakSelf.txOne.text = [NSString stringWithFormat:@"%ld",(long)[weakSelf.weekList[0] planNumber]];
    weakSelf.txTwo.text = [NSString stringWithFormat:@"%ld",(long)[weakSelf.weekList[1] planNumber]];
    weakSelf.txThree.text = [NSString stringWithFormat:@"%ld",(long)[weakSelf.weekList[2] planNumber]];
    weakSelf.txFour.text = [NSString stringWithFormat:@"%ld",(long)[weakSelf.weekList[3] planNumber]];
    weakSelf.txFive.text = [NSString stringWithFormat:@"%ld",(long)[weakSelf.weekList[4] planNumber]];
    weakSelf.txSix.text = [NSString stringWithFormat:@"%ld",(long)[weakSelf.weekList[5] planNumber]];
    weakSelf.txSeven.text = [NSString stringWithFormat:@"%ld",(long)[weakSelf.weekList[6] planNumber]];
}

@end
