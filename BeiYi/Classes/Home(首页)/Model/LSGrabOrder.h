//
//  LSGrabOrder.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/12.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSAttach.h"

@interface LSGrabOrder : NSObject

/**
 *  抢单模型
 */

/** 订单ID */
@property (nonatomic, copy) NSString *grabOrder_id;

/** 订单类型 */
@property (nonatomic, copy) NSString *order_type;

/** 医院名称 */
@property (nonatomic, copy) NSString *hospital_name;

/** 优质服务 */
@property (nonatomic, strong) LSAttach *attach;

/** 展示的时间 */
@property (nonatomic, copy) NSString *show_time;

/** 预约时间 */
@property (nonatomic, copy) NSString *start_time;

/** 订单价格 */
@property (nonatomic, copy) NSString *price;

/** 订单编号 */
@property (nonatomic, copy) NSString *order_code;

/** 订单类型描述 */
@property (nonatomic, copy) NSString *order_type_str;

/** 经纪人最高价格 */
@property (nonatomic, copy) NSString *offer_price;

/** 医生姓名 */
@property (nonatomic, copy) NSString *doctor_name;

/** 预约结束时间 */
@property (nonatomic, copy) NSString *end_time;

/** 科室名称 */
@property (nonatomic, copy) NSString *department_name;

/** 医生头像 */
@property (nonatomic, strong) NSURL *avator;

@end
