//
//  LDCalendarView.m
//
//  Created by lidi on 15/9/1.
//  Copyright (c) 2015年 lidi. All rights reserved.
//

#import "LDCalendarView.h"
#import "NSDate+extend.h"
#import "Common.h"

#define UNIT_WIDTH  40
#define LeftBtnTag 1000


//行 列 每小格宽度 格子总数
static const NSInteger kRow = 6;
static const NSInteger kCol = 7;
static const NSInteger kTotalNum = (kRow - 1) * kCol;

@implementation UIColor (Extend)
+ (UIColor *)hexColorWithString:(NSString *)string
{
    return [UIColor hexColorWithString:string alpha:1.0f];
}

+ (UIColor *)hexColorWithString:(NSString *)string alpha:(float) alpha
{
    if ([string hasPrefix:@"#"]) {
        string = [string substringFromIndex:1];
    }
    
    NSString *pureHexString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([pureHexString length] != 6) {
        return [UIColor whiteColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [pureHexString substringWithRange:range];
    
    range.location += range.length ;
    NSString *gString = [pureHexString substringWithRange:range];
    
    range.location += range.length ;
    NSString *bString = [pureHexString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}
@end

@interface LDCalendarView() {
    NSMutableArray *_currentMonthDateArray;
    NSMutableArray *_selectArray;
    UIView *_dateBgView;//日期的背景
    UIView *_contentBgView;
    CGRect _touchRect;//可操作区域
}
@property (nonatomic, assign)int32_t month;
@property (nonatomic, assign)int32_t year;
@property (nonatomic, strong)UILabel *titleLab;//标题
@property (nonatomic, strong)NSDate *today; //今天0点的时间
@property (nonatomic, strong) NSMutableArray *selectBtnArray;
@end

@implementation LDCalendarView
- (NSDate *)today {
    if (!_today) {
        NSDate *currentDate = [NSDate date];
        NSInteger tYear = currentDate.year;
        NSInteger tMonth = currentDate.month;
        NSInteger tDay = currentDate.day;
        
        //字符串转换为日期
        //实例化一个NSDateFormatter对象
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        _today =[dateFormat dateFromString:[NSString stringWithFormat:@"%@-%@-%@",@(tYear),@(tMonth),@(tDay)]];
    }
    return _today;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        // 1. 标题
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
        titleView.backgroundColor = [UIColor clearColor];
        self.titleView = titleView;
        
        // 1.2 月份选择箭头
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        leftBtn.frame = CGRectMake(0, 0, 30, CGRectGetHeight(titleView.frame));
        leftBtn.tag = LeftBtnTag;
        leftBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        [leftBtn setImage:[UIImage imageNamed:@"you"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(switchMonthBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleView addSubview:leftBtn];
        
        // 1.1 当前月份
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftBtn.frame), 0, CGRectGetWidth(_titleView.frame) * 0.6, _titleView.height)];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.userInteractionEnabled = YES;
        [self.titleView addSubview:_titleLab];
        
        // 1.3 月份选择箭头 右
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        rightBtn.frame = CGRectMake(CGRectGetMaxX(_titleLab.frame), CGRectGetMinY(leftBtn.frame), CGRectGetWidth(leftBtn.frame), CGRectGetHeight(_titleView.frame));
        [rightBtn setImage:[UIImage imageNamed:@"you"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(switchMonthBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        [self.titleView addSubview:rightBtn];
        
        
        
        
        //内容区的背景
        _contentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _contentBgView.userInteractionEnabled = YES;
        _contentBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentBgView];
    
        
        
        // 时间按钮背景
        _dateBgView = [[UIView alloc] initWithFrame:CGRectMake(25, 0, CGRectGetWidth(_contentBgView.frame) - 50, UNIT_WIDTH*kCol - 16)];
        _dateBgView.userInteractionEnabled = YES;
        _dateBgView.backgroundColor = [UIColor hexColorWithString:@"ffffff"];
        [_contentBgView addSubview:_dateBgView];
        
        // 添加星期背景
        CGFloat bgH = CGRectGetHeight(_dateBgView.frame) / 8.2;
        UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, bgH)];
        bgView1.backgroundColor = [UIColor hexColorWithString:@"f5f5f5"];
        [self addSubview:bgView1];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, bgH, CGRectGetWidth(bgView1.frame), 1)];
        line1.backgroundColor = ZZBorderColor;
        [bgView1 addSubview:line1];
        UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, 0, 25, bgH)];
        bgView2.backgroundColor = [UIColor hexColorWithString:@"f5f5f5"];
        [self addSubview:bgView2];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, bgH, CGRectGetWidth(bgView2.frame), 1)];
        line2.backgroundColor = ZZBorderColor;
        [bgView2 addSubview:line2];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_dateBgView addGestureRecognizer:tap];
        
        //初始化数据
        [self initData];

    }
    return self;
}

- (void)initData {
    _selectArray = @[].mutableCopy;
    
    //获取当前年月
    NSDate *currentDate = [NSDate date];
    self.month = (int32_t)currentDate.month;
    self.year = (int32_t)currentDate.year;
    [self refreshDateTitle];

    _currentMonthDateArray = [NSMutableArray array];
    for (int i = 0; i < kTotalNum; i++) {
        [_currentMonthDateArray addObject:@(0)];
    }
    
    [self showDateView];
}

- (void)switchMonthBtnAction:(UIButton *)sender {

    if (sender.tag == LeftBtnTag) {
        //左
        [self leftSwitch];
    }else {
        //右
        [self rightSwitch];
    }
}

- (void)leftSwitch{
    //左
    if (self.month > 1) {
        self.month -= 1;
    }else {
        self.month = 12;
        self.year -= 1;
    }
    
    [self refreshDateTitle];
}

- (void)rightSwitch {
    if (self.month < 12) {
        self.month += 1;
    }else {
        self.month = 1;
        self.year += 1;
    }
    
    [self refreshDateTitle];
}

- (void)refreshDateTitle {
    _titleLab.text = [NSString stringWithFormat:@"%@年%@月",@(self.year),@(self.month)];
    
    [self showDateView];
}

- (void)showDateView {
    //移除之前子视图
    [_dateBgView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    CGFloat offX = 0.0;
    CGFloat offY = 0.0;
    CGFloat w = (CGRectGetWidth(_dateBgView.frame)) / kCol;
    CGFloat h = (CGRectGetHeight(_dateBgView.frame)) / kRow;
    CGFloat labelH = (CGRectGetHeight(_dateBgView.frame)) / 8.2;
    CGRect baseRect = CGRectMake(offX,offY, w, h);
    CGRect labelRect = CGRectMake(offY, offY, w, labelH);
    NSArray *tmparr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    for(int i = 0 ;i < 7; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:labelRect];
        lab.textColor = [UIColor hexColorWithString:@"999999"];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:16];
        lab.backgroundColor = [UIColor hexColorWithString:@"f5f5f5"];
        lab.text = [tmparr objectAtIndex:i];
        [_dateBgView addSubview:lab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(offX, labelH, w, 1)];
        line.backgroundColor = ZZBorderColor;
        [lab addSubview:line];
        
        labelRect.origin.x += labelRect.size.width;
    }

    //字符串转换为日期
    //实例化一个NSDateFormatter对象
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *firstDay =[dateFormat dateFromString:[NSString stringWithFormat:@"%@-%@-%@",@(self.year),@(self.month),@(1)]];
    
    CGFloat startDayIndex = [NSDate acquireWeekDayFromDate:firstDay];
    //第一天是今天，特殊处理
    if (startDayIndex == 1) {
        //星期天（对应一）
        startDayIndex = 0;
    }else {
        //周一到周六（对应2-7）
        startDayIndex -= 1;
    }
    
    baseRect.origin.x = w * startDayIndex;
    baseRect.origin.y += (baseRect.size.height);
    NSInteger baseTag = 100;
    for(int i = startDayIndex; i < kTotalNum;i++)
    {
        if (i % kCol == 0 && i!= 0)
        {
            baseRect.origin.y += (baseRect.size.height);
            baseRect.origin.x = offX;
        }
        
        //设置触摸区域
        if (i == startDayIndex)
        {
            _touchRect.origin = baseRect.origin;
            _touchRect.origin.x = 0;
            _touchRect.size.width = kCol * w;
            _touchRect.size.height = kRow * h;
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = baseTag + i;
        [btn setFrame:baseRect];
        btn.userInteractionEnabled = NO;
        btn.backgroundColor = [UIColor clearColor];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        btn.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 10, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(10, 0, -10, 0);

        NSDate * date = [firstDay dateByAddingTimeInterval:(i - startDayIndex) *24*60*60];
        _currentMonthDateArray[i] = @(([date timeIntervalSince1970]) * 1000);
        NSString *title = INTTOSTR(date.day);
        if ([date isToday])
        {//今天
            title = @"今天";
        }
        else if(date.day == 1)
        {//是1号
            //在下面标一下月份
//            UILabel *monthLab = [[UILabel alloc] initWithFrame:CGRectMake(baseRect.origin.x, baseRect.origin.y + baseRect.size.height - 7, baseRect.size.width, 7)];
//            monthLab.backgroundColor = [UIColor clearColor];
//            monthLab.textAlignment = NSTextAlignmentCenter;
//            monthLab.font = [UIFont systemFontOfSize:7];
//            monthLab.textColor = [UIColor hexColorWithString:@"c0c0c0"];
//            monthLab.text = [NSString stringWithFormat:@"%@月",@(date.month)];
//            [_dateBgView addSubview:monthLab];
        }
        
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        if ([self.today compare:date] < 0) {
            //时间比今天大,同时是当前月2b2b2b
            [btn setTitleColor:[UIColor hexColorWithString:@"333333"] forState:UIControlStateNormal];
        }else if ([self.today compare:date] > 0) { // 时间比今天小
            [btn setTitleColor:[UIColor hexColorWithString:@"999999"] forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:ZZButtonTintColor forState:UIControlStateNormal];
        }
        [btn setBackgroundColor:[UIColor clearColor]];
        [_dateBgView addSubview:btn];
        [_dateBgView sendSubviewToBack:btn];
        
        baseRect.origin.x += (baseRect.size.width);
    }
    
    //高亮选中的
    [self refreshDateView];
}

- (void)setDefaultDates:(NSArray *)defaultDates {
    _defaultDates = defaultDates;
    
    if (defaultDates) {
        _selectArray = [defaultDates mutableCopy];
    }else {
        _selectArray = @[].mutableCopy;
    }
}

- (void)refreshDateView {
    for(int i = 0; i < kTotalNum; i++)
    {
        UIButton *btn = (UIButton *)[_dateBgView viewWithTag:100 + i];
        NSNumber *interval = [_currentMonthDateArray objectAtIndex:i];

        if (i < [_currentMonthDateArray count] && btn)
        {
            
            if ([_selectArray containsObject:interval]) {
                
                // 选中的时间 升序排序
                [_selectArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    return [obj1 compare:obj2];
                }];
                
                // 第一个时间
                NSNumber *firstInterval = [_selectArray firstObject];

                // 1. 找到第一个btn更改图片
                for (int i = 0; i < _currentMonthDateArray.count; i ++) {
             
                    if (_currentMonthDateArray[i] == firstInterval) {
                        // 删除第一个btn的背景
                        UIButton *firstBtn = (UIButton *)[_dateBgView viewWithTag:100 + i];
                        [firstBtn setBackgroundImage:[UIImage imageNamed:@"qi_shi"] forState:UIControlStateNormal];
                        [firstBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                       
                    } else {
                        [btn setBackgroundImage:[UIImage imageNamed:@"jie_shu"] forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
}

- (void)show {
    self.hidden = NO;
}

- (void)hide {
    self.hidden = YES;
}

-(void)tap:(UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:_dateBgView];
    if (CGRectContainsPoint(_touchRect, point)) {
        CGFloat w = (CGRectGetWidth(_dateBgView.frame)) / kCol;
        CGFloat h = (CGRectGetHeight(_dateBgView.frame)) / kRow;
        int row = (int)((point.y - _touchRect.origin.y) / h);
        int col = (int)((point.x) / w);
        
        NSInteger index = row * kCol + col;
        [self clickForIndex:index];
    }
}

#pragma mark - 日期Button事件处理
- (void)clickForIndex:(NSInteger)index
{
    
    
    UIButton *btn = (UIButton *)[_dateBgView viewWithTag:100 + index];
    if (index < [_currentMonthDateArray count]) {
        NSNumber *interval = [_currentMonthDateArray objectAtIndex:index];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval.doubleValue/1000.0];
        if ([self.today  compare:date] < 0) {
            //时间比今天大,同时是当前月
        }else {
            return;
        }
        
        //已选中,取消
        if ([_selectArray containsObject:interval]) {
            
            [_selectArray removeObject:interval];

            [btn setBackgroundImage:nil forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor hexColorWithString:@"2b2b2b"] forState:UIControlStateNormal];
        }
        else { //未选中,想选择
            
            // 保证数组中只有两个元素
            if (_selectArray.count > 1) {
                return;
            }
            // 添加到selectArray
            [_selectArray addObject:interval];

            if (_selectArray.count == 1) {
                
                // 第一个直接添加到数组
                [btn setBackgroundImage:[UIImage imageNamed:@"qi_shi"] forState:UIControlStateNormal];
            } else {
                NSNumber *firstInterval = [_selectArray firstObject];
                NSDate *firstDate = [NSDate dateWithTimeIntervalSince1970:firstInterval.doubleValue/1000.0];
                if ([firstDate compare:date] > 0) { // 时间比起始时间小

                    // 1. 找到第一个btn更改图片
                    for (int i = 0; i < _currentMonthDateArray.count; i ++) {
                        if (_currentMonthDateArray[i] == firstInterval) {
                            // 删除第一个btn的背景
                            UIButton *firstBtn = (UIButton *)[_dateBgView viewWithTag:100 + i];
                            [firstBtn setBackgroundImage:nil forState:UIControlStateNormal];
                            [firstBtn setTitleColor:ZZTitleColor forState:UIControlStateNormal];
                            // 删除数组中的数据
                            [_selectArray removeObject:[_selectArray objectAtIndex:0]];
                        }
                    }
                    
                    // 2. 设置背景图片为起始
                    [btn setBackgroundImage:[UIImage imageNamed:@"qi_shi"] forState:UIControlStateNormal];
   
                } else { // 时间比起始时间大
                    // 设置图片为结束
                    [btn setBackgroundImage:[UIImage imageNamed:@"jie_shu"] forState:UIControlStateNormal];
                }
 
            }
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            //如果选中的是下个月切换到下个月
            if (date.month > self.month) {
                [self rightSwitch];
            }
        }
        [self _doneBtnClick];
    }
}

- (void)_doneBtnClick
{
    if (_complete) {
        _complete([_selectArray mutableCopy]);
    }
}

#pragma mark - lazy
- (NSMutableArray *)selectBtnArray {
    
    if (_selectBtnArray == nil) {
        _selectBtnArray = [NSMutableArray array];
    }
    return _selectBtnArray;
}

@end
