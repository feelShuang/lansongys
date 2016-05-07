
//
//  OperationBtn.m
//  BeiYi
//
//  Created by 刘爽 on 16/1/20.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "OperationBtn.h"

@implementation OperationBtn

// 初始化一个功能按钮
- (instancetype)initWithFrame:(CGRect)frame NormalImage:(NSString *)normalImage SelectedImage:(NSString *)seclectedImage Title:(NSString *)title Target:(id)target Action:(SEL)action {
    
    if (self = [super initWithFrame:frame]) {
        // 设置文字
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if ([UIScreen mainScreen].bounds.size.height <= 568) {
            self.titleLabel.font = [UIFont systemFontOfSize:13];
            
        }else {
            self.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        
        // 设置图片
//        [self setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
//        [self setBackgroundImage:[UIImage imageNamed:seclectedImage] forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
//        [self setImage:[UIImage imageNamed:seclectedImage] forState:UIControlStateSelected];
        
        // 监听事件
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
    
}

// 静态添加一个功能按钮
+ (instancetype)addActionBtnWithFrame:(CGRect)frame NormalImage:(NSString *)normalImage SelectedImage:(NSString *)seclectedImage Title:(NSString *)title Target:(id)target Action:(SEL)action {
    
    return [[self alloc] initWithFrame:frame NormalImage:normalImage SelectedImage:seclectedImage Title:title Target:target Action:action];
    
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 20;
    CGFloat h = 20;
    return CGRectMake(x, y, w, h);
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat x = 22;
    CGFloat y = 0;
    CGFloat w = self.frame.size.width * 0.7;
    CGFloat h = self.frame.size.height;
    return CGRectMake(x, y, w, h);
    
}



@end
