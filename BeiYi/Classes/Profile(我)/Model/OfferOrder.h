//
//  OfferOrder.h
//  BeiYi
//
//  Created by Joe on 15/5/27.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  我的订单 模型
 */
@interface OfferOrder : NSObject
/**
 *  我的订单 id
 */
@property (nonatomic, copy) NSString *offer_id;
/**
 *  我的订单 服务类型
 */
@property (nonatomic, copy) NSString *order_type;
/**
 *  我的订单 医院名称
 */
@property (nonatomic, copy) NSString *hospital_name;
/**
 *  我的订单 描述信息
 */
@property (nonatomic, copy) NSString *memo;
/**
 *  我的订单 起始时间
 */
@property (nonatomic, copy) NSString *start_time;
/**
 *  我的订单 创建时间
 */
@property (nonatomic, copy) NSString *created_at;
/**
 *  我的订单 订单状态
 */
@property (nonatomic, copy) NSString *order_status_str;
/**
 *  我的订单 价格
 */
@property (nonatomic, copy) NSString *price;
/**
 *  我的订单 order_code
 */
@property (nonatomic, copy) NSString *order_code;
/**
 *  我的订单 状态编码
 */
@property (nonatomic, copy) NSString *order_status;
/**
 *  我的订单 结束时间
 */
@property (nonatomic, copy) NSString *end_time;
/**
 *  我的订单 医生姓名
 */
@property (nonatomic, copy) NSString *doctor_name;
/**
 *  我的订单 科室名称
 */
@property (nonatomic, copy) NSString *department_name;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)offerOrderWithDict:(NSDictionary *)dict;

@end
