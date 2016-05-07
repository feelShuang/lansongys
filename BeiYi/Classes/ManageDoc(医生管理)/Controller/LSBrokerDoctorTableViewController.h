//
//  LSBrokerDoctorTableViewController.h
//  BeiYi
//
//  Created by LiuShuang on 15/8/31.
//  Copyright (c) 2015年 LiuShuang. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  医生管理（我是经纪人） 控制器
 */
@interface LSBrokerDoctorTableViewController : UIViewController
/** segmentControld 的值 0：医生管理/ 1：医院管理 */
@property (nonatomic, assign) NSInteger segControlSelectedIndex;

@end
