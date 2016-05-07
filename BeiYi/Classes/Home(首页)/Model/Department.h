//
//  Department.h
//  BeiYi
//
//  Created by Joe on 15/5/18.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  科室模型
 */
@interface Department : NSObject
/**
 *  科室id
 */
@property (nonatomic, assign) int depart_id;
/**
 *  科室名称
 */
@property (nonatomic, copy) NSString *dept_name;
/**
 *  子科室数组
 */
@property (nonatomic, strong) NSArray *childList;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)departWithDict:(NSDictionary *)dict;

@end
