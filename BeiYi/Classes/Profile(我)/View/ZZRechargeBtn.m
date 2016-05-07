//
//  ZZRechargeBtn.m
//  BeiYi
//
//  Created by Joe on 15/7/13.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ZZRechargeBtn.h"
#import "Common.h"

#define W self.frame.size.width
#define H self.frame.size.height

@implementation ZZRechargeBtn

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName target:(id)target action:(SEL)action {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

        self.imageView.contentMode = UIViewContentModeBottom;
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat y = 0.1 *H;
    CGFloat h = 0.35 *H;
    CGFloat w = h;
    CGFloat x = W/2 - w/2;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat y = 0.5 *H;
    CGFloat w = W;
    CGFloat h = 0.35 *H;
    CGFloat x = 0;

    return CGRectMake(x, y, w, h);
}

@end
