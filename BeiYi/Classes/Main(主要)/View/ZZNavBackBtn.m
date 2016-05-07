//
//  ZZNavBackBtn.m
//  BeiYi
//
//  Created by Joe on 15/7/13.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ZZNavBackBtn.h"

@implementation ZZNavBackBtn

- (instancetype)initWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action {
    if (self = [super init]) {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.textAlignment = UIViewContentModeCenter;
        self.imageView.contentMode = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"iocn_NavBack"] forState:UIControlStateNormal];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        self.layer.cornerRadius = 8.0f;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.frame.size.width *0.2;
    CGFloat h = self.frame.size.height;
    return CGRectMake(x, y, w, h);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat x = self.frame.size.width *0.3;;
    CGFloat y = 0;
    CGFloat w = self.frame.size.width *0.7;
    CGFloat h = self.frame.size.height;
    
    return CGRectMake(x, y, w, h);
}

@end
