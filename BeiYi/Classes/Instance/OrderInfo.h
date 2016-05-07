//
//  OrderInfo.h
//  BeiYi
//
//  Created by Joe on 15/5/20.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSDoctorDetail.h"
/**
 *  订单单例（存储订单信息）
 */
@interface OrderInfo : NSObject

// 服务类型
@property (nonatomic, copy) NSString *service_type;

// 医院id
@property (nonatomic, copy) NSString *hospital_id;

// 科室id
@property (nonatomic, copy) NSString *department_id;

// 医院名称
@property (nonatomic, copy) NSString *hospital_name;

// 科室名称
@property (nonatomic, copy) NSString *department_name;

// 医生id
@property (nonatomic, copy) NSString *doctor_id;

// 医生姓名
@property (nonatomic, copy) NSString *doctor_name;

// 就诊人id
@property (nonatomic, copy) NSString *patient_id;

@property (nonatomic, strong) LSDoctorDetail *doctorInfo;

/** 通知标记 */
// 患者
@property (nonatomic, copy) NSString *publish_order_read_count;
// 经纪人
@property (nonatomic, copy) NSString *offer_order_read_count;

// 主刀医生服务就诊人的在院状态
@property (nonatomic, copy) NSString *visit_type;

// 是否优质服务
@property (nonatomic, assign) BOOL assure_flag;

// 订单操作刷新标识
@property (nonatomic, assign) BOOL isUpLoading;


+ (OrderInfo *)shareInstance;

@end
