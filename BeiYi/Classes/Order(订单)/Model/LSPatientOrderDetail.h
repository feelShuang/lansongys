//
//  LSPatientOrderDetail.h
//  BeiYi
//
//  Created by LiuShuang on 16/1/27.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOrderDetailAttach.h"
#import "LSHuman.h"
#import "LSOver.h"

@interface LSPatientOrderDetail : NSObject

/**
 *  患者订单详情
 */

/** 订单ID */
@property (nonatomic, copy) NSString *order_id;
/** 订单类型 */
@property (nonatomic, copy) NSString *order_type;
/** order_time_show */
@property (nonatomic, copy) NSString *order_time_show;
/** 医生级别 */
@property (nonatomic, copy) NSString *doctor_level;
/** 就诊时间 */
@property (nonatomic, copy) NSString *visit_time;
/** 医院名称 */
@property (nonatomic, copy) NSString *hospital_name;
/** attach */
@property (nonatomic, strong) LSOrderDetailAttach *attach;
/** 附加服务 */
@property (nonatomic, copy) NSString *service_attach;
/** 订单状态描述 */
@property (nonatomic, copy) NSString *order_status_str;
/** 医生头像 */
@property (nonatomic, strong) NSURL *doctor_avator;
/** 价格 */
@property (nonatomic, copy) NSString *price;
/** 订单编号 */
@property (nonatomic, copy) NSString *order_code;
/** 订单类型描述 */
@property (nonatomic, copy) NSString *order_type_str;
/** 订单状态码 */
@property (nonatomic, copy) NSString *order_status;
/** 订单超时 */
@property (nonatomic, copy) NSString *order_over;
/** 凭证信息 */
@property (nonatomic, strong) LSOver *over_over;
/** 医生名称 */
@property (nonatomic, copy) NSString *doctor_name;
/** 就诊人信息 */
@property (nonatomic, strong) LSHuman *human;
/** 科室名称 */
@property (nonatomic, copy) NSString *department_name;

@end
