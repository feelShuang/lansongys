//
//  Doctor.h
//  BeiYi
//
//  Created by Joe on 15/5/18.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  医生模型
 */
@interface Doctor : NSObject
/**
 *  医生id
 */
@property (nonatomic, assign) int doctor_id;
/**
 *  医生名字
 */
@property (nonatomic, copy) NSString *name;
/**
 *  医生头像url字符串
 */
@property (nonatomic, copy) NSString *avator;
/**
 *  医生级别（1-医师2-主治医师3-副主任医师4-主任医师）
 */
@property (nonatomic, assign) int level;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)doctorlWithDict:(NSDictionary *)dict;
@end
