//
//  LSPatientHomeView.m
//  BeiYi
//
//  Created by LiuShuang on 16/3/11.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#define BUTTON_BASETAG 100
#define ZZADScrollViewH SCREEN_HEIGHT * 0.27 // 广告栏高度

#import "LSPatientHomeView.h"
#import "Common.h"

@interface LSPatientHomeView ()

@property (nonatomic ,strong) UIView *btnBgView;

@end

@implementation LSPatientHomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addAllViews];
    }
    return self;
}

#pragma mark - 添加所有视图
- (void)addAllViews {
    
    // 1. 添加主屏幕滚动视图
    [self addScrollView];
    
    // 2. 添加所有的功能按钮
    [self addAllButtons];
    
    // 3. 添加优质医生
    [self addDocTableView];
}

#pragma mark - 添加主屏幕滚动视图
- (void)addScrollView {

    // 添加滚动视图
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - 49)];
    
    mainScrollView.backgroundColor = ZZBackgroundColor;
    mainScrollView.alwaysBounceVertical = YES;
    mainScrollView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:mainScrollView];
    self.mainScrollView = mainScrollView;
}

#pragma mark - 添加广告栏视图
- (void)addCycleScrollViewWithImageUrls:(NSArray *)imageUrls titles:(NSArray *)titles{
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ZZADScrollViewH) imageURLStringsGroup:imageUrls];
    cycleScrollView.infiniteLoop = YES;
#warning 更改了颜色
    cycleScrollView.currentPageDotColor = ZZBaseColor;
    cycleScrollView.pageDotColor = [UIColor whiteColor];
    cycleScrollView.titlesGroup = titles;
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"home_bei_jing"];
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [self.mainScrollView addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    cycleScrollView.autoScrollTimeInterval = 4.0;
}

#pragma mark - 添加全部的功能按钮
- (void)addAllButtons {
    
    // 1. 预约专家按钮
    UIButton *appointmentExpertsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    appointmentExpertsButton.frame = CGRectMake(0, ZZADScrollViewH, SCREEN_WIDTH, SCREEN_HEIGHT * 0.1214);
    appointmentExpertsButton.backgroundColor = [UIColor whiteColor];
    appointmentExpertsButton.tag = BUTTON_BASETAG + 1;
    // 添加边框
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, 0) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:appointmentExpertsButton];
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, CGRectGetHeight(appointmentExpertsButton.frame)) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:appointmentExpertsButton];
    
    [self.mainScrollView addSubview:appointmentExpertsButton];
    self.appointmentExpertsButton = appointmentExpertsButton;
    
    
    CGFloat appointBtnH = _appointmentExpertsButton.frame.size.height;
    
    // 1.1 添加图片
    UIImageView *appointBtnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_yuyuezhuanjia"]];
    appointBtnImage.frame = CGRectMake(appointBtnH * 0.271, appointBtnH * 0.21 , appointBtnH - (2 * appointBtnH * 0.21), appointBtnH - (2 * appointBtnH * 0.21));
    
    [_appointmentExpertsButton addSubview:appointBtnImage];
    
    // 1.2 添加title
    UILabel *appointTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(appointBtnImage.frame) + appointBtnH * 0.185, CGRectGetMinY(appointBtnImage.frame), SCREEN_WIDTH * 0.5, appointBtnH * 0.246)];

    appointTitleLabel.text = @"预约专家";
    appointTitleLabel.textColor = ZZTitleColor;
    
    [_appointmentExpertsButton addSubview:appointTitleLabel];
    
    // 1.3 添加Detail
    UILabel *appointDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(appointTitleLabel.frame), CGRectGetMaxY(appointTitleLabel.frame) + appointBtnH * 0.185, SCREEN_WIDTH - CGRectGetMinX(appointTitleLabel.frame), appointBtnH * 0.16)];
    
    appointDetailLabel.text = @"海量优质医生 自主预约更便捷";
    appointDetailLabel.textColor = ZZDetailStrColor;
    
    [_appointmentExpertsButton addSubview:appointDetailLabel];
    
    if (SCREEN_HEIGHT == 480) { // 4/4s
        appointTitleLabel.font = [UIFont systemFontOfSize:18];
        appointDetailLabel.font = [UIFont systemFontOfSize:13];
    } else if (SCREEN_HEIGHT == 568) { // 5/5s/5c
        appointTitleLabel.font = [UIFont systemFontOfSize:19];
        appointDetailLabel.font = [UIFont systemFontOfSize:14];
    } else if (SCREEN_HEIGHT == 667) { // 6
        appointTitleLabel.font = [UIFont systemFontOfSize:20];
        appointDetailLabel.font = [UIFont systemFontOfSize:15];
    } else { // 6p
        appointTitleLabel.font = [UIFont systemFontOfSize:22];
        appointDetailLabel.font = [UIFont systemFontOfSize:17];
    }
    
    
    // 四个按钮背景
    UIView *btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_appointmentExpertsButton.frame) + 10, SCREEN_WIDTH, SCREEN_HEIGHT * 0.238)];
    btnBgView.backgroundColor = [UIColor whiteColor];
    
    [self.mainScrollView addSubview:btnBgView];
    self.btnBgView = btnBgView;
    
    
    // 2. 主刀医生按钮
    UIButton *surgeonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    surgeonButton.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2, self.btnBgView.frame.size.height / 2);
    surgeonButton.backgroundColor = [UIColor whiteColor];
    surgeonButton.tag = BUTTON_BASETAG + 2;
    
    [self.btnBgView addSubview:surgeonButton];
    self.surgeonButton = surgeonButton;

    // 添加button内容
    [self addButtonWithButton:surgeonButton img:[UIImage imageNamed:@"home_zhudaoyisheng"] title:@"主刀医生" detail:@"指定名医开刀"];
    
    // 3. 会诊服务按钮
    UIButton *consultationServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    consultationServiceButton.frame = CGRectMake(SCREEN_WIDTH / 2, CGRectGetMinY(surgeonButton.frame), CGRectGetWidth(surgeonButton.frame), CGRectGetHeight(surgeonButton.frame));
    consultationServiceButton.backgroundColor = [UIColor whiteColor];
    consultationServiceButton.tag = BUTTON_BASETAG + 3;
    
    [self.btnBgView addSubview:consultationServiceButton];
    self.consultationServiceButton = consultationServiceButton;
    
    // 添加button内容
    [self addButtonWithButton:_consultationServiceButton img:[UIImage imageNamed:@"home_huizhenfuwu"] title:@"会诊服务" detail:@"名医请到身边来"];
    
    // 4. 病情分析按钮
    UIButton *conditionAnalysisButton = [UIButton buttonWithType:UIButtonTypeCustom];
    conditionAnalysisButton.frame = CGRectMake(0, CGRectGetMaxY(surgeonButton.frame) , CGRectGetWidth(surgeonButton.frame), CGRectGetHeight(surgeonButton.frame));
    
    conditionAnalysisButton.backgroundColor = [UIColor whiteColor];
    conditionAnalysisButton.tag = BUTTON_BASETAG + 4;
    
    [self.btnBgView addSubview:conditionAnalysisButton];
    self.conditionAnalysisButton = conditionAnalysisButton;
    
    // 添加button内容
    [self addButtonWithButton:conditionAnalysisButton img:[UIImage imageNamed:@"home_bingqingfenxi"] title:@"病情分析" detail:@"一对一权威建议"];

    
    // 5. 离院跟踪按钮
    UIButton *leaveTrackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leaveTrackButton.frame = CGRectMake(CGRectGetMaxX(surgeonButton.frame) + 1, CGRectGetMaxY(surgeonButton.frame), CGRectGetWidth(surgeonButton.frame), CGRectGetHeight(surgeonButton.frame));
    
    leaveTrackButton.backgroundColor = [UIColor whiteColor];
    leaveTrackButton.tag = BUTTON_BASETAG + 5;
    
    [self.btnBgView addSubview:leaveTrackButton];
    self.leaveTrackButton = leaveTrackButton;
    
    // 添加button内容
    [self addButtonWithButton:_leaveTrackButton img:[UIImage imageNamed:@"home_liyuangenzong"] title:@"离院跟踪" detail:@"实时病情随访"];
    
    // btnBgView添加边框
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, 0) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:_btnBgView];
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, CGRectGetHeight(_btnBgView.frame)) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:_btnBgView];
    
    // 添加分割线
    [ZZUITool lineVerticalWithPosition:CGPointMake(SCREEN_WIDTH / 2, 0) height:_btnBgView.frame.size.height backGroundColor:ZZSeparateLineColor superView:_btnBgView];
    [ZZUITool linehorizontalWithPosition:CGPointMake(SCREEN_WIDTH * 0.08, CGRectGetHeight(_surgeonButton.frame)) width:SCREEN_WIDTH * 0.848 backGroundColor:ZZSeparateLineColor superView:_btnBgView];
    
}

#pragma mark - 添加按钮
- (void)addButtonWithButton:(UIView *)button
                        img:(UIImage *)img
                      title:(NSString *)title
                     detail:(NSString *)detail {
    
    CGFloat surgeonW = _surgeonButton.frame.size.width;
    CGFloat surgeonH = _surgeonButton.frame.size.height;
    
    // 1. 添加图片
    UIImageView *surgeonBtnImage = [[UIImageView alloc] initWithImage:img];
    surgeonBtnImage.frame = CGRectMake(surgeonW * 0.128, surgeonH * 0.225 , surgeonH - (2 * surgeonH * 0.225), surgeonH - (2 * surgeonH * 0.225));
    
    [button addSubview:surgeonBtnImage];
    
    // 2. 添加title
    UILabel *surgeonTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(surgeonBtnImage.frame) + surgeonH * 0.125, CGRectGetMinY(surgeonBtnImage.frame) + surgeonH * 0.0625, CGRectGetWidth(_surgeonButton.frame) - CGRectGetMaxX(surgeonBtnImage.frame) - 20, surgeonH * 0.1875)];
    
    surgeonTitleLabel.text = title;
    surgeonTitleLabel.textColor = ZZTitleColor;
    
    [button addSubview:surgeonTitleLabel];
    
    // 3. 添加Detail
    UILabel *surgeonDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(surgeonTitleLabel.frame), CGRectGetMaxY(surgeonTitleLabel.frame) + surgeonH * 0.1, CGRectGetWidth(_surgeonButton.frame) - CGRectGetMaxX(surgeonBtnImage.frame) - 20, surgeonH * 0.1625)];
    
    surgeonDetailLabel.text = detail;
    surgeonDetailLabel.textColor = ZZDetailStrColor;
    
    
    [button addSubview:surgeonDetailLabel];
    
    if (SCREEN_HEIGHT == 480) { // 4/4s
        surgeonTitleLabel.font = [UIFont systemFontOfSize:14];
        surgeonDetailLabel.font = [UIFont systemFontOfSize:12];
    } else if (SCREEN_HEIGHT == 568) { // 5/5s/5c
        surgeonTitleLabel.font = [UIFont systemFontOfSize:14];
        surgeonDetailLabel.font = [UIFont systemFontOfSize:12];
    } else if (SCREEN_HEIGHT == 667) { // 6
        surgeonTitleLabel.font = [UIFont systemFontOfSize:15];
        surgeonDetailLabel.font = [UIFont systemFontOfSize:13];
    } else { // 6p
        surgeonTitleLabel.font = [UIFont systemFontOfSize:17];
        surgeonDetailLabel.font = [UIFont systemFontOfSize:15];
    }
}

#pragma mark - 添加优质医生
- (void)addDocTableView {
    
    self.docTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.btnBgView.frame) + 10, SCREEN_WIDTH, 71 * 5 + 35) style:UITableViewStylePlain];
    
    _docTableView.scrollEnabled = NO;
    _docTableView.backgroundColor = [UIColor whiteColor];
    
    [self.mainScrollView addSubview:_docTableView];
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.docTableView.frame));
}


@end
