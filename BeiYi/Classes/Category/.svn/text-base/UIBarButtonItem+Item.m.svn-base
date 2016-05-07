//
//  UIBarButtonItem+Item.m
//  BeiYi
//
//  Created by 刘爽 on 16/2/3.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "UIBarButtonItem+Item.h"

@implementation UIBarButtonItem (Item)

- (instancetype)barButtonItemWithIamge:(UIImage *)image
                                target:(id)target
                                action:(SEL)action
                      forControlEvents:(UIControlEvents)controlEvents {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:controlEvents];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}

@end
