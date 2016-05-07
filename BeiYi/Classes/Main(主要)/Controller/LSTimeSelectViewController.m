//
//  LSTimeSelectViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/3/25.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "LSTimeSelectViewController.h"
#import "LDCalendarView.h"
#import "Common.h"
#import "NSDate+extend.h"
#import <Masonry.h>

@interface LSTimeSelectViewController ()

// 日历控件
@property (nonatomic, strong) LDCalendarView *calendarView;
// 选择的日期
@property (nonatomic, strong) NSMutableArray *selectedDays;
// 展示选择的日期
@property (nonatomic, strong) UILabel *showTimeLab;

@end

@implementation LSTimeSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ZZBackgroundColor;
    
    // 设置UI
    [self setUI];
}

#pragma mark - 设置界面UI
- (void)setUI {
    
    CGFloat calendarH = 285;
    // 添加日期选择控件
    _calendarView = [[LDCalendarView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, calendarH)];
    
    [self.view addSubview:_calendarView];
    __weak typeof(self) weakSelf = self;
    _calendarView.complete = ^(NSArray *result) {
        if (result) {
            weakSelf.selectedDays = [result mutableCopy];
        }
    };
    [self.calendarView show];
    
    // 添加提示Label
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"请选择开始预约时间及结束时间";
    tipLabel.textColor = ZZDetailStrColor;
    tipLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:tipLabel];
    // 添加约束
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // 左对齐 （15）
        make.leading.mas_equalTo(self.view).with.offset(15);
        // 顶部对齐 (10)
        make.top.mas_equalTo(self.view).with.offset(CGRectGetMaxY(_calendarView.frame) + 10);
        // 大小
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 12));
    }];
    
    // 添加展示选择时间视图
    UIView *timeBgVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_calendarView.frame) + SCREEN_WIDTH * 0.266, SCREEN_WIDTH, 44)];
    timeBgVeiw.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:timeBgVeiw];
    
    // 医院日期 提示
    UILabel *tipTimeLabel = [[UILabel alloc] init];
    tipTimeLabel.text = @"已选日期";
    tipTimeLabel.textColor = ZZTitleColor;
    tipTimeLabel.font = [UIFont systemFontOfSize:16];
    [timeBgVeiw addSubview:tipTimeLabel];
    // 添加约束
    [tipTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // 居中
        make.centerY.mas_equalTo(timeBgVeiw);
        // 左对齐 （15）
        make.leading.mas_equalTo(self.view).with.offset(15);
        // 大小
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 4, 16));
    }];
    
    // 添加展示日期的Label
    UILabel *showTimeLabel = [[UILabel alloc] init];
    showTimeLabel.textColor = ZZDetailStrColor;
    showTimeLabel.textAlignment = NSTextAlignmentRight;
    showTimeLabel.font = [UIFont systemFontOfSize:14];
    [timeBgVeiw addSubview:showTimeLabel];
    self.showTimeLab = showTimeLabel;
    // 添加约束
    [showTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // 居中
        make.centerY.mas_equalTo(timeBgVeiw);
        // 右对齐 （15）
        make.trailing.mas_equalTo(self.view).with.offset(-15);
        // 大小
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SCREEN_WIDTH / 4 - 15, 16));
    }];
    
    //
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(0, 0, 40, 25);
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarItemClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.titleView = _calendarView.titleView;
}

#pragma mark - 导航栏右侧按钮 监听
- (void)rightBarItemClicked {

    //从小到大排序
    [self.selectedDays sortUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSMutableArray *timeArray = [NSMutableArray array];
    for (NSNumber *interval in self.selectedDays) {
        NSString *partStr = [NSDate stringWithTimestamp:interval.doubleValue/1000.0 format:@"yyyy-MM-dd"];
        [timeArray addObject:partStr];
    }
    
    // 展示选择日期
    self.showTimeLab.text = [NSString stringWithFormat:@"%@ 至 %@",timeArray.firstObject,timeArray.lastObject];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(timeSelect:selectTimeWithTimeArray:)]) {
        [self.delegate timeSelect:self selectTimeWithTimeArray:timeArray];
    }
    
    // 返回
    [self.navigationController popViewControllerAnimated:YES];
}

@end
