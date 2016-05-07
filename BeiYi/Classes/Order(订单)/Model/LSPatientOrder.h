//
//  LSPatientOrder.h
//  BeiYi
//
//  Created by LiuShuang on 16/1/25.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSPatientOrder : NSObject
/**
 *  患者订单模型
 */

/** 患者订单ID */
@property (nonatomic, copy) NSString *patientOrder_id;

/** 订单展示时间 */
@property (nonatomic, copy) NSString *order_time_show;

/** 医生级别 */
@property (nonatomic, copy) NSString *doctor_level;

/** 订单状态信息 */
@property (nonatomic, copy) NSString *order_status_memo;

/** 就诊时间 */
@property (nonatomic, copy) NSString *visit_time;

/** 订单展示状态 */
@property (nonatomic, copy) NSString *order_status_show;

/** 医院名称 */
@property (nonatomic, copy) NSString *hospital_name;

/** 附加服务 */
@property (nonatomic, copy) NSString *service_attach;

/** 阅读标记 */
@property (nonatomic, copy) NSString *read_flag;

/** 医生头像 */
@property (nonatomic, strong) NSURL *doctor_avator;

/** 订单价格 */
@property (nonatomic, copy) NSString *price;

/** 订单编号 */
@property (nonatomic, copy) NSString *order_code;

/** 订单状态 */
@property (nonatomic, copy) NSString *order_status;

/** 医生姓名 */
@property (nonatomic, copy) NSString *doctor_name;

/** 订单类型展示 */
@property (nonatomic, copy) NSString *order_type_show;

/** 可是名称 */
@property (nonatomic, copy) NSString *department_name;

@end
