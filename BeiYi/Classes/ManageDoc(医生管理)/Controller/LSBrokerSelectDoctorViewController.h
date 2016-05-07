//
//  LSBrokerSelectDoctorViewController.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/6.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSBrokerSelectDoctorViewController : UIViewController

// 过滤的医生ID
@property (nonatomic, copy) NSString *filterIDs;
// 订单类型（下单时）
@property (nonatomic, copy) NSString *order_type;

@end
