//
//  ZZActionBtn.m
//  BeiYi
//
//  Created by Joe on 15/7/9.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ZZActionBtn.h"

@implementation ZZActionBtn

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title ImageName:(NSString *)imageName HighlightImageName:(NSString *)highlightImageName Target:(id)target action:(SEL)action {
    
    if (self = [super initWithFrame:frame]) {
        // 设置文字
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        if ([UIScreen mainScreen].bounds.size.height <= 568) {
            self.titleLabel.font = [UIFont systemFontOfSize:12];

        }else {
            self.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        
        // 设置图片
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
        
        // 监听点击事件
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


+ (instancetype)actionBtnWithFrame:(CGRect)frame Title:(NSString *)title ImageName:(NSString *)imageName HighlightImageName:(NSString *)highlightImageName Target:(id)target action:(SEL)action {
    
        return [[self alloc] initWithFrame:frame Title:title ImageName:imageName HighlightImageName:highlightImageName Target:target action:action];
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat x = 0;
    CGFloat y = self.frame.size.height * 0.8;
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height * 0.2;
    return CGRectMake(x, y, w, h);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat h = self.frame.size.height * 0.6;
    CGFloat w = h; 
    CGFloat x = (self.frame.size.width-w)/2;
    CGFloat y = self.frame.size.height * 0.1;
    return CGRectMake(x, y, w, h);
}

@end
