//
//  ZZNavBackBtn.h
//  BeiYi
//
//  Created by Joe on 15/7/13.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZNavBackBtn : UIButton
/**
 *  初始化充值按钮
 *
 *  NSString title      标题
 *  CGFloat fontSize    标题字体大小
 *  UIColor titleColor  标题字体颜色
 *  NSString imageName  图片名称
 */
- (instancetype)initWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;
@end
