//
//  ZZActionBtn.h
//  BeiYi
//
//  Created by Joe on 15/7/9.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZActionBtn : UIButton

//@property (nonatomic, strong) UILabel *subTitle;

/**
 *  初始化一个首页功能按钮
 */
- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title ImageName:(NSString *)imageName HighlightImageName:(NSString *)highlightImageName Target:(id)target action:(SEL)action;

/**
 *  静态添加一个首页功能按钮
 */
+ (instancetype)actionBtnWithFrame:(CGRect)frame Title:(NSString *)title ImageName:(NSString *)imageName HighlightImageName:(NSString *)highlightImageName Target:(id)target action:(SEL)action;


@end
