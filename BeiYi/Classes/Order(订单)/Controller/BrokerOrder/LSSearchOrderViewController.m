//
//  LSSearchOrderViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/22.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSSearchOrderViewController.h"
#import "Common.h"

@interface LSSearchOrderViewController ()<UITextFieldDelegate>

// 搜索框
@property (nonatomic, strong) UITextField *searchbar;

/** 时间选择控制器 */
@property (nonatomic, strong) UIDatePicker *datePicker;
/** 时间选择控制器的背景视图 */
@property (nonatomic, strong) UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *appointBtn;
@property (weak, nonatomic) IBOutlet UIButton *opearationBtn;
@property (weak, nonatomic) IBOutlet UIButton *consulutationBtn;
@property (weak, nonatomic) IBOutlet UIButton *illnessAnayzeBtn;
@property (weak, nonatomic) IBOutlet UIButton *leaveTrackBtn;

@property (weak, nonatomic) IBOutlet UIButton *visitStartTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *visitEndTimeBtn;

@property (weak, nonatomic) IBOutlet UIButton *notSureBtn;
@property (weak, nonatomic) IBOutlet UIButton *allreadyAllowBtn;
@property (weak, nonatomic) IBOutlet UIButton *chuHaoBtn;
/** 时间字符串 */
@property (nonatomic, copy) NSString *timeStr;
/** 标记时间选择控制器是否展示 */
@property (nonatomic, assign) BOOL isAppear;

/** 关键字 */
@property (nonatomic, copy) NSString *keyword;
/** 订单类型 */
@property (nonatomic, copy) NSString *order_type;
/** 订单状态 */
@property (nonatomic, copy) NSString *order_status;

@end

@implementation LSSearchOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.keyword = @"";
    self.order_type = @"";
    self.order_status = @"";
    
    // 添加搜索框
    [self addSearchBar];
    
    // 初始化按钮颜色
    [self setButtonUI];
}

#pragma mark - 添加搜索框
- (void)addSearchBar {
    
    // 搜索框
    self.searchbar = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 70, 30)];
    _searchbar.backgroundColor = ZZBackgroundColor;
    _searchbar.delegate = self;
    _searchbar.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchbar.returnKeyType = UIReturnKeySearch;
    _searchbar.layer.cornerRadius = CGRectGetHeight(_searchbar.frame) / 2;
    _searchbar.layer.borderColor = ZZBorderColor.CGColor;
    _searchbar.textAlignment = NSTextAlignmentLeft;
    _searchbar.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"famousDoc_sousuo"]];
    _searchbar.placeholder = @"请输入想要搜索的医院、医生、科室";
    _searchbar.font = [UIFont systemFontOfSize:14];
    _searchbar.layer.borderColor = ZZBorderColor.CGColor;
    _searchbar.layer.borderWidth = 1.0f;
    [_searchbar addTarget:self action:@selector(textFieldReturnEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_searchbar];

}

#pragma mark - 初始化按钮颜色
- (void)setButtonUI {
    
    [self borderSetWithBtn:self.appointBtn];
    [self borderSetWithBtn:self.opearationBtn];
    [self borderSetWithBtn:self.consulutationBtn];
    [self borderSetWithBtn:self.illnessAnayzeBtn];
    [self borderSetWithBtn:self.leaveTrackBtn];
    
    [self borderSetWithBtn:self.visitStartTimeBtn];
    [self borderSetWithBtn:self.visitEndTimeBtn];
    
    [self borderSetWithBtn:self.notSureBtn];
    [self borderSetWithBtn:self.allreadyAllowBtn];
    [self borderSetWithBtn:self.chuHaoBtn];
}

#pragma mark - 按钮事件 监听
- (IBAction)searchBtnAction:(UIButton *)sender {
    
    if (sender.tag == 1000) {
        // 选中
        [self btnSelectedAction:sender];
        // 未选中
        [self borderSetWithBtn:self.opearationBtn];
        [self borderSetWithBtn:self.consulutationBtn];
        [self borderSetWithBtn:self.illnessAnayzeBtn];
        [self borderSetWithBtn:self.leaveTrackBtn];
    } else if (sender.tag == 1001) {
        // 选中
        [self btnSelectedAction:sender];
        // 未选中
        [self borderSetWithBtn:self.appointBtn];
        [self borderSetWithBtn:self.consulutationBtn];
        [self borderSetWithBtn:self.illnessAnayzeBtn];
        [self borderSetWithBtn:self.leaveTrackBtn];
    } else if (sender.tag == 1002) {
        // 选中
        [self btnSelectedAction:sender];
        // 未选中
        [self borderSetWithBtn:self.appointBtn];
        [self borderSetWithBtn:self.opearationBtn];
        [self borderSetWithBtn:self.illnessAnayzeBtn];
        [self borderSetWithBtn:self.leaveTrackBtn];
    } else if (sender.tag == 1003) {
        // 选中
        [self btnSelectedAction:sender];
        // 未选中
        [self borderSetWithBtn:self.appointBtn];
        [self borderSetWithBtn:self.opearationBtn];
        [self borderSetWithBtn:self.consulutationBtn];
        [self borderSetWithBtn:self.leaveTrackBtn];
    } else if (sender.tag == 1004) {
        // 选中
        [self btnSelectedAction:sender];
        // 未选中
        [self borderSetWithBtn:self.appointBtn];
        [self borderSetWithBtn:self.opearationBtn];
        [self borderSetWithBtn:self.consulutationBtn];
        [self borderSetWithBtn:self.illnessAnayzeBtn];
    } else if (sender.tag == 1005) {
        // 开始时间
        [self addTimeSelecterWithTag:0];
    } else if (sender.tag == 1006) {
        // 结束时间
        [self addTimeSelecterWithTag:1];
    } else if (sender.tag == 1007) {
        // 选中
        [self btnSelectedAction:sender];
        // 未选中
        [self borderSetWithBtn:self.allreadyAllowBtn];
        [self borderSetWithBtn:self.chuHaoBtn];
    } else if (sender.tag == 1008) {
        // 选中
        [self btnSelectedAction:sender];
        // 未选中
        [self borderSetWithBtn:self.notSureBtn];
        [self borderSetWithBtn:self.chuHaoBtn];
    } else {
        [self btnSelectedAction:sender];
        // 未选中
        [self borderSetWithBtn:self.notSureBtn];
        [self borderSetWithBtn:self.allreadyAllowBtn];
    }
}

#pragma mark - 设置按钮选中状态的UI
- (void)btnSelectedAction:(UIButton *)button {
    
    button.selected = YES;
    button.layer.cornerRadius = 5.0;
    button.layer.borderColor = ZZColor(255, 138, 0, 1).CGColor;
    button.layer.borderWidth = 1.0f;
    [button setTitleColor:ZZColor(255, 138, 0, 1) forState:UIControlStateSelected];
    
    // 设置订单类型
    if (button == self.appointBtn || button == self.opearationBtn || button == self.consulutationBtn || button == self.illnessAnayzeBtn || button == self.leaveTrackBtn) {
        self.order_type = [NSString stringWithFormat:@"%ld",button.tag - 999];
    }
    // 设置订单状态
    if (button == self.notSureBtn || button == self.allreadyAllowBtn || button == self.chuHaoBtn) {
        if ([button.titleLabel.text isEqualToString:@"未确认接单"]) {
            self.order_status = @"1";
        } else if ([button.titleLabel.text isEqualToString:@"已接单"]) {
            self.order_status = @"2";
        } else if ([button.titleLabel.text isEqualToString:@"已出号"]) {
            self.order_status = @"5";
        }
        
    }
}

#pragma mark - 确认按钮 监听
- (IBAction)commitBtnAction:(UIButton *)sender {
    
    // 获取关键字
    self.keyword = _searchbar.text;
    
    NSString *startTime = @"";
    NSString *endTime = @"";
    if (![self.visitStartTimeBtn.currentTitle isEqualToString:@"开始时间"]) {
        startTime = self.visitStartTimeBtn.titleLabel.text;
    }
    if (![self.visitEndTimeBtn.currentTitle isEqualToString:@"结束时间"]) {
        endTime = self.visitEndTimeBtn.titleLabel.text;
    }
    
    if ([self.delegate respondsToSelector:@selector(searchOrderController:keyWord:order_status:order_type:startTime:endTime:)]) {
        [self.delegate searchOrderController:self keyWord:self.keyword order_status:self.order_status order_type:self.order_type startTime:startTime endTime:endTime];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 设置按钮边框UI
- (void)borderSetWithBtn:(UIButton *)button {
    
    button.selected = NO;
    button.layer.cornerRadius = 5.0;
    button.layer.borderColor = ZZBorderColor.CGColor;
    button.layer.borderWidth = 1.0f;
    [button setTitleColor:ZZDetailStrColor forState:UIControlStateNormal];
}

#pragma mark - 添加时间控制器
/**
 * 添加时间控制器
 * Tag:(NSInteger)tag 0：开始时间 1：结束时间
 */
- (void)addTimeSelecterWithTag:(NSInteger)tag {
    
    // 1.添加背景视图
    
    // datePicker控制器高度和Y值
    CGFloat height = 240;
    CGFloat datePickerY = CGRectGetMaxY(self.view.frame) - height;
    
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height)];
    pickerView.backgroundColor = [UIColor whiteColor];
    
    if (!_isAppear) { // 判断datePicker是否出现
        [self.view addSubview:pickerView];
        self.pickerView = pickerView;
        
        [UIView animateWithDuration:0.45f animations:^{
            self.pickerView.frame = CGRectMake(0, datePickerY, SCREEN_WIDTH, height);
        } completion:^(BOOL finished) {
            _isAppear = YES;
        }];
    }
    
    // 2.添加toolBar
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ZZBtnHeight)];
    bar.barTintColor = [UIColor whiteColor];
    
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemClicked)];
    [item0 setTitleTextAttributes:@{NSForegroundColorAttributeName :
                                        ZZBaseColor} forState:UIControlStateNormal];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];// 控制距离的item
    
    
    SEL selector;
    if (tag == 0) {
        selector = @selector(determineItemGetBeginTime);
    }else {
        selector = @selector(determineItemGetEndTime);
    }
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:selector];
    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName :
                                        ZZBaseColor} forState:UIControlStateNormal];
    bar.items = @[item0,item1,item2];
    [pickerView addSubview:bar];
    
    // 3.添加时间选择器
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, ZZBtnHeight, SCREEN_WIDTH, height - 40)];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:OneDay];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [datePicker setMinimumDate:[dateFormatter dateFromString:@"2016-01-01"]];
    [pickerView addSubview:datePicker];
    self.datePicker = datePicker;
}

#pragma mark 点击toolBar的取消按钮
- (void)cancelItemClicked {
    // 移除时间选择控制器
    [UIView animateWithDuration:0.45f animations:^{
        
        self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.pickerView.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            _isAppear = NO;
            [self.pickerView removeFromSuperview];
        }
    }];
    
}

#pragma mark 点击toolBar的确定按钮
/*
 *  点击toolBar的确定按钮
 *  tag 0：开始时间 1：结束时间
 */
- (void)determineItemGetBeginTime {
    // 1、显示时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    if ([self.visitStartTimeBtn.currentTitle isEqualToString:@"开始时间"]) {
        [self.visitStartTimeBtn setTitleColor:ZZTitleColor forState:UIControlStateNormal];
        [self.visitStartTimeBtn setTitle:[formatter stringFromDate:self.datePicker.date] forState:UIControlStateNormal];
    }
    
    // 2、移除时间选择控制器
    [self cancelItemClicked];
    
}

- (void)determineItemGetEndTime {
    // 1、显示时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    if ([self.visitEndTimeBtn.currentTitle isEqualToString:@"结束时间"]) {
        [self.visitEndTimeBtn setTitleColor:ZZTitleColor forState:UIControlStateNormal];
        [self.visitEndTimeBtn setTitle:[formatter stringFromDate:self.datePicker.date] forState:UIControlStateNormal];
    }
    
    // 2、移除时间选择控制器
    [self cancelItemClicked];
    
}

#pragma mark 时间改变
- (void) dateChange:(UIDatePicker *)picker{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    self.timeStr = [dateFormat stringFromDate:picker.date];
}

- (void)textFieldReturnEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
}

@end
