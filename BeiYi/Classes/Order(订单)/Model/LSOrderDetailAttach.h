//
//  LSOrderDetailAttach.h
//  BeiYi
//
//  Created by LiuShuang on 16/1/27.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSOrderDetailAttach : NSObject

/**
 预约专家
 {
 over_exact_type = <null>,
 assure_flag = 0,
 order_id = 16,
 id = 10,
 assure_price = 6,
 init_assure_price = 6,
 service_price = 66,
 over_visit_time = <null>,
 init_service_price = 66
 },
 */


/*
{
service_price = 22,
id = 1,
over_visit_time = <null>,
order_id = 11,
init_service_price = 22,
over_exact_type = <null>
},

order_type_str = 病情分析会,
*/

// 主刀 / 会诊
/** 就诊医院地址 */
@property (nonatomic, copy) NSString *visit_address;
/** attach_id */
@property (nonatomic, copy) NSString *attach_id;
/** 初始差旅费 */
@property (nonatomic, assign) NSInteger init_travel_price;
/** 初始服务费 */
@property (nonatomic, assign) NSInteger init_service_price;
/** 就诊结束日期 */
@property (nonatomic, copy) NSString *over_visit_day;
/** 就诊医院名称 */
@property (nonatomic, copy) NSString *visit_hospital;
/** 订单id */
@property (nonatomic, copy) NSString *order_id;
/** 结束就诊时间 */
@property (nonatomic, copy) NSString *over_visit_time;
/** 就诊类型 */
@property (nonatomic, copy) NSString *visit_type;
/** 就诊科室 */
@property (nonatomic, copy) NSString *visit_department;
/** bunk_num */
@property (nonatomic, copy) NSString *bunk_num;
/** 经纪人提供的差旅费 */
@property (nonatomic, copy) NSString *travel_price;
/** 经纪人提供的服务费 */
@property (nonatomic, copy) NSString *service_price;

// 分析
/** over_exact_type */
@property (nonatomic, copy) NSString *over_exact_type;

// 挂号
/** assure_flag */
@property (nonatomic, copy) NSString *assure_flag;
/** 初始化优质服务价格 */
@property (nonatomic, assign) NSInteger init_assure_price;

// 离院
/** over_start_time */
@property (nonatomic, copy) NSString *over_start_time;
/** 经纪人提供的每月服务费 */
@property (nonatomic, copy) NSString *month_price;
/** 服务次数 */
@property (nonatomic, copy) NSString *active_service_count;
/** 初始月份服务费 */
@property (nonatomic, assign) NSInteger init_month_price;
/** 发出的警告次数 */
@property (nonatomic, copy) NSString *warn_count;
/** 出院时间 */
@property (nonatomic, copy) NSString *out_hospital_time;
/** 服务月数 */
@property (nonatomic, copy) NSString *month_number;
/** 微信号 */
@property (nonatomic, copy) NSString *over_weixin;
/** 病历号 */
@property (nonatomic, copy) NSString *record_number;

@end
