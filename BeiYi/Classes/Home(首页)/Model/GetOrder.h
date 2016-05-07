//
//  GetOrder.h
//  BeiYi
//
//  Created by Joe on 15/5/28.
//  Copyright (c) 2015年 Joe. All rights reserved.
//



#import <Foundation/Foundation.h>

/**
 *  抢单模型
	attach = {
	over_exact_type = <null>,
	assure_flag = 0,
	order_id = 1,
	id = 1,
	assure_price = <null>,
	init_assure_price = 0,
	service_price = 500,
	over_visit_time = <null>,
	init_service_price = 600
 },
 */
@interface GetOrder : NSObject

/** 抢单ID */
@property (nonatomic, copy) NSString *order_id;

/** 标记 是否可以抢单 */
@property (nonatomic, assign) BOOL grab_flag;

/** 服务类型 */
@property (nonatomic, copy) NSString *order_type;

/** 医院名称 */
@property (nonatomic, copy) NSString *hospital_name;


// 抢单 订单创建时间
@property (nonatomic, copy) NSString *created_at;

// 抢单 就诊开始时间
@property (nonatomic, copy) NSString *start_time;

// 抢单 价格
@property (nonatomic, copy) NSString *price;

// 抢单 order_code
@property (nonatomic, copy) NSString *order_code;

// 抢单 order_type_str
@property (nonatomic, copy) NSString *order_type_str;

// 抢单 就诊结束时间
@property (nonatomic, copy) NSString *end_time;

// 抢单 医生姓名
@property (nonatomic, copy) NSString *doctor_name;

// 抢单 科室名称
@property (nonatomic, copy) NSString *department_name;

@end
