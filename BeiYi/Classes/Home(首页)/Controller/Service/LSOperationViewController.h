//
//  LSOperationViewController.h
//  BeiYi
//
//  Created by LiuShuang on 16/3/28.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSDoctorDetail;

@interface LSOperationViewController : UIViewController

// 功能按钮Push标记
@property (nonatomic, assign) BOOL buttonPush;
// 订单类型
@property (nonatomic, copy) NSString *order_type;

@property (nonatomic, strong) LSDoctorDetail *doctorInfo;

@end
