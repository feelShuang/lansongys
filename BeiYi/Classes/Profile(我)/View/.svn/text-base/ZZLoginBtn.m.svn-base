//
//  ZZLoginBtn.m
//  BeiYi
//
//  Created by Joe on 15/4/21.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ZZLoginBtn.h"

@implementation ZZLoginBtn

- (instancetype)initWithTitle:(NSString *)title ImageName:(NSString *)imageName HighImageName:(NSString *)highImageName {
    if (self = [super init]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
        // 设置文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat x = 0;
    CGFloat y = self.frame.size.height * 0.7;
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height * 0.3;
    return CGRectMake(x, y, w, h);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat h = self.frame.size.height * 0.7;
    CGFloat w = h;
    CGFloat x = (self.frame.size.width-w)/2;
    CGFloat y = 0;
    return CGRectMake(x, y, w, h);
}

@end
