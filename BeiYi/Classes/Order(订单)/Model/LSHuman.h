//
//  LSHuman.h
//  BeiYi
//
//  Created by LiuShuang on 16/1/27.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSHuman : NSObject
/**
 * 就诊人信息
 */

/** 所在地址 */
@property (nonatomic, copy) NSString *address;
/** 身份证号码（显示） */
@property (nonatomic, copy) NSString *id_card;
/** 订单id */
@property (nonatomic, copy) NSString *order_id;
/** 手机号码 */
@property (nonatomic, copy) NSString *mobile;
/** 年龄 */
@property (nonatomic, copy) NSString *age;
/** link_name */
@property (nonatomic, copy) NSString *link_name;
/** link_mobile */
@property (nonatomic, copy) NSString *link_mobile;
/** 身份证号码（隐藏） */
@property (nonatomic, copy) NSString *hide_id_card;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
/** 性别 */
@property (nonatomic, copy) NSString *name;

@end
