//
//  ManageDepts.h
//  BeiYi
//
//  Created by Joe on 15/9/11.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  科室 数据模型
 */
@interface ManageDepts : NSObject

/** 医院名称*/
@property (nonatomic, copy) NSString *hospital_name;
/** ??? id (不知道什么id)*/
@property (nonatomic, copy) NSString *managedept_id;
/** 价格*/
@property (nonatomic, copy) NSString *price;
/** 科室名称*/
@property (nonatomic, copy) NSString *parent_name;
/** 科室id*/
@property (nonatomic, copy) NSString *department_id;
/** 子科室名称*/
@property (nonatomic, copy) NSString *dept_name;
/** 医院id*/
@property (nonatomic, copy) NSString *hospital_id;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)manageDeptsWithDict:(NSDictionary *)dict;

@end
