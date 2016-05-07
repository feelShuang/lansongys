//
//  LSBrokerOrder.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/14.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOrderDetailAttach.h"

@interface LSBrokerOrder : NSObject
/**
 *  经纪人订单模型
 */

/** 订单ID */
@property (nonatomic, copy) NSString *order_id;
/** 就诊时间 */
@property (nonatomic, copy) NSString *visit_time;
/** 医生级别 */
@property (nonatomic, copy) NSString *doctor_level;
/** 订单状态描述 */
@property (nonatomic, copy) NSString *order_status_memo;
/** 订单类型码 */
@property (nonatomic, copy) NSString *order_type;
/** 订单状态展示 */
@property (nonatomic, copy) NSString *order_status_show;

@property (nonatomic, strong) LSOrderDetailAttach *attach;
/** 医院名称 */
@property (nonatomic, copy) NSString *hospital_name;
/** 差旅费提交标记 */
@property (nonatomic, copy) NSString *travel_submit_flag;
/** 附加服务 */
@property (nonatomic, copy) NSString *service_attach;
/** 医生头像 */
@property (nonatomic, strong) NSURL *doctor_avator;
/** 价格 */
@property (nonatomic, copy) NSString *price;
/** 订单编号 */
@property (nonatomic, copy) NSString *order_code;
/** 订单状态码 */
@property (nonatomic, copy) NSString *order_status;
/** 医生姓名 */
@property (nonatomic, copy) NSString *doctor_name;
/** 订单类型展示 */
@property (nonatomic, copy) NSString *order_type_show;
/** 科室名称 */
@property (nonatomic, copy) NSString *department_name;

@end
