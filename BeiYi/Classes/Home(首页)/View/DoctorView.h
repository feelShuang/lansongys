//
//  DoctorView.h
//  BeiYi
//
//  Created by Joe on 15/5/19.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorView : UIView
/**
 *  返回一个显示医生详情的View
 *
 *  @param icon       图片urlString
 *  @param name       医生姓名
 *  @param entry      医生专长类别
 *  @param hospital   医院名称
 */
+ (instancetype)doctorViewWithFrame:(CGRect)frame icon:(NSString *)icon name:(NSString *)name entry:(NSString *)entry hospital:(NSString *)hospital;

@end
