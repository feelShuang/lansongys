//
//  LSPatientHomeView.h
//  BeiYi
//
//  Created by LiuShuang on 16/3/11.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface LSPatientHomeView : UIView

/** UIScrollView 全屏滚动视图 */
@property (nonatomic, strong) UIScrollView *mainScrollView;

/** SDCycleScrollView 广告栏滚动视图 */
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

// 预约专家按钮
@property (nonatomic, strong) UIButton *appointmentExpertsButton;

// 主刀医生
@property (nonatomic, strong) UIButton *surgeonButton;

// 会诊服务
@property (nonatomic, strong) UIButton *consultationServiceButton;

// 病情分析
@property (nonatomic, strong) UIButton *conditionAnalysisButton;

// 离院跟踪
@property (nonatomic, strong) UIButton *leaveTrackButton;

// 优质医生
@property (nonatomic, strong) UITableView *docTableView;

// 添加广告轮播图
- (void)addCycleScrollViewWithImageUrls:(NSArray *)imageUrls titles:(NSArray *)titles;

@end
