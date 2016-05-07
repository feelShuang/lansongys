//
//  LSAttach.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/12.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSAttach : NSObject
/**
 *  附加服务
 */

/**  */
@property (nonatomic, copy) NSString *over_exact_type;

/** 抢单标志 */
@property (nonatomic, copy) NSString *assure_flag;

/** 订单ID */
@property (nonatomic, copy) NSString *order_id;

/** 附加服务ID */
@property (nonatomic, copy) NSString *attach_id;

/** 担保服务价格 */
@property (nonatomic, copy) NSString *assure_price;

/** 初始化担保服务价格 */
@property (nonatomic, assign) NSInteger init_assure_price;

/** 经纪人该项服务的价格 */
@property (nonatomic, copy) NSString *service_price;

/** 经纪人提供的就诊时间 */
@property (nonatomic, copy) NSString *over_visit_time;

/** 初始化服务价格 */
@property (nonatomic, assign) NSInteger init_service_price;

// --------------离院跟踪服务--------------

@property (nonatomic, copy) NSString *over_start_time;

/** 经纪人月份价格 */
@property (nonatomic, copy) NSString *month_price;

// active_service_count

/** 每月初始化服务价格 */
@property (nonatomic, assign) NSInteger init_month_price;

// warn_count

/** 出院时间 */
@property (nonatomic, copy) NSString *out_hospital_time;

/** 购买的几个月份 */
@property (nonatomic, copy) NSString *month_number;

// over_weixin
// record_number
// --------------主刀医生服务--------------
/** 就诊地址 */
@property (nonatomic, copy) NSString *visit_address;
/** 初始化差旅费 */
@property (nonatomic, assign) NSInteger init_travel_price;
/** 结束就诊日期 */
@property (nonatomic, copy) NSString *over_visit_day;
/** 就诊医院 */
@property (nonatomic, copy) NSString *visit_hospital;
/** 就诊类型 1-外院 */
@property (nonatomic, copy) NSString *visit_type;
/** 就诊科室 */
@property (nonatomic, copy) NSString *visit_department;

@property (nonatomic, copy) NSString *bunk_num;
/** 经纪人提供的差旅费 */
@property (nonatomic, copy) NSString *travel_price;

@end

