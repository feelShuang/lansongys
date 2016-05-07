//
//  LSActionSheet.m
//  BeiYi
//
//  Created by LiuShuang on 16/3/24.
//  Copyright © 2016年 Joe. All rights reserved.
//
#define LSColor(r,g,b,a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a) /1]
#define actionSheetCancelButtonTag 2999
#define actionSheetButtonBaseTag 3000
#define actionSheetButtonHeight 44
#define animationDuration 0.12
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "LSActionSheet.h"
#import "UIView+frame.h"

@interface LSActionSheet ()

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *actionSheet;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) NSMutableArray *separateLineArray;

@end

@implementation LSActionSheet

- (instancetype)initWithDelegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle itemsButtonTitle:(NSArray *)itemsButtonTitle {
    
    if (self = [super init]) {

        _btnArray = nil;
        _separateLineArray = nil;
        
        self.backgroundColor = [UIColor clearColor];
        self.delegate = delegate;
        
        // 遮盖
        UIView *coverView = [UIView new];
        coverView.backgroundColor = LSColor(102, 102, 102, 0.5);
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewClickedAction)];
        [coverView addGestureRecognizer:tapGes];
        [self addSubview:coverView];
        _coverView = coverView;
        
        // 添加actionSheet
        UIView *actionSheet = [UIView new];
        actionSheet.backgroundColor = [UIColor whiteColor];
        _actionSheet = actionSheet;
        [self.coverView addSubview:actionSheet];
        
        // 操作按钮
        for (int i = 0; i < itemsButtonTitle.count; i ++) {
            [self createBtnWithTitle:itemsButtonTitle[i] backgroundColor:[UIColor whiteColor] index:actionSheetButtonBaseTag + i];
        }
        
        // 取消按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelBtn.tag = actionSheetCancelButtonTag;
        [cancelBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [cancelBtn setTitleColor:LSColor(51, 51, 51, 1) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(actionSheetClickedButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = cancelBtn;
        [self.actionSheet addSubview:cancelBtn];
    }
    return self;
}

+ (instancetype)showActionSheetWithDelegate:(id)delegate cancleButtonTitle:(NSString *)cancleButtonTitle itemsButtonTitle:(NSArray *)itemsButtonTitle {
    
    return [[self alloc] initWithDelegate:delegate cancelButtonTitle:cancleButtonTitle itemsButtonTitle:itemsButtonTitle];
}

- (void)createBtnWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor index:(NSInteger)index {
    
    // 按钮
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.tag = index;
    actionBtn.backgroundColor = backgroundColor;
    actionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    actionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [actionBtn setTitle:title forState:UIControlStateNormal];
    if (index - actionSheetButtonBaseTag == 0) {
        [actionBtn setTitleColor:LSColor(0, 153, 255, 1) forState:UIControlStateNormal];
    } else {
        [actionBtn setTitleColor:LSColor(51, 51, 51, 1) forState:UIControlStateNormal];
    }
    [actionBtn addTarget:self action:@selector(actionSheetClickedButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionSheet addSubview:actionBtn];
    [self.btnArray addObject:actionBtn];
    
    // 分割线
    UIView *separateLine = [UIView new];
    separateLine.backgroundColor = LSColor(230, 230, 230, 1);
    [actionBtn addSubview:separateLine];
    [self.separateLineArray addObject:separateLine];
}

- (void)show {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.frame = keyWindow.bounds;
    [keyWindow addSubview:self];
    
    // coverView
    self.coverView.frame = self.bounds;
    
    // actionSheet
    CGFloat actionSheetH = (self.btnArray.count + 1) * actionSheetButtonHeight + 5;
    self.actionSheet.frame = CGRectMake(0, self.height, SCREEN_WIDTH, actionSheetH);
    
    // cancelButton
    self.cancelButton.frame = CGRectMake(0, actionSheetH - actionSheetButtonHeight, SCREEN_WIDTH, actionSheetButtonHeight);
    
    CGFloat btnH = actionSheetButtonHeight;
    for (int i = 0; i < _btnArray.count; i ++) {
        UIButton *btn = self.btnArray[i];
        btn.frame = CGRectMake(0, btnH * i, SCREEN_WIDTH, btnH);
        UIView *separateLine = self.separateLineArray[i];
        separateLine.frame = CGRectMake(0, btnH - 1, SCREEN_WIDTH, btnH);
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.actionSheet.y = self.height - self.actionSheet.height;
    }];
}

#pragma mark - 覆盖视图按钮事件
- (void)coverViewClickedAction {
    [self dismiss];
}

- (void)actionSheetClickedButtonAtIndex:(UIButton *)sender {
    
    if (sender.tag == actionSheetCancelButtonTag) {
        [self dismiss];
    } else {
        if (sender.tag - actionSheetButtonBaseTag == 0) {
            
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(LSActionSheet:didClickButtonAtIndex:)]) {
                [self.delegate LSActionSheet:self didClickButtonAtIndex:sender.tag - actionSheetButtonBaseTag];
            }
            [self dismiss];
        }
    }
}

- (void)dismiss {
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.actionSheet.y = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - lazy
- (NSArray *)btnArray {
    
    if (_btnArray == nil) {
        self.btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (NSArray *)separateLineArray {
    
    if (_separateLineArray == nil) {
        self.separateLineArray = [NSMutableArray array];
    }
    return _separateLineArray;
}

@end
