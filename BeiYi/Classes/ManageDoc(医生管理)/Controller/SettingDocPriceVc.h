//
//  SettingDocPriceVc.h
//  BeiYi
//
//  Created by Joe on 15/12/30.
//  Copyright © 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSBrokerDoctor;

@interface SettingDocPriceVc : UIViewController
/**
 *  NSString 服务类型 设置UI
 */
@property (nonatomic, copy) NSString *typeNum;

@property (nonatomic, copy) NSString *price1;

@property (nonatomic, copy) NSString *price2;

/** 医生模型 */
@property (nonatomic, strong) LSBrokerDoctor *doctor;

// 医院ID
@property (nonatomic, copy) NSString *hospital_id;

// 用来区别设置医院还是设置医生
@property (nonatomic, assign) NSInteger controllerID;

// 服务开通标识
@property (nonatomic, copy) NSString *open_flag;

@end
