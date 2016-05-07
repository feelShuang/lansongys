//
//  UIBarButtonItem+Extension.m
//  BeiYi
//
//  Created by Joe on 15/4/20.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "ZZNavBackBtn.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    
    btn.frame = CGRectMake(0, 0, 30, 30);
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    ZZNavBackBtn *btn = [[ZZNavBackBtn alloc] initWithTitle:title fontSize:16 titleColor:[UIColor whiteColor] target:target action:action];
    btn.frame = CGRectMake(0, 0, 60, 40);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
