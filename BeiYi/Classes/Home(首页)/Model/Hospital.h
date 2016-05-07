//
//  Hostipal.h
//  NetWokText
//
//  Created by Joe on 15/5/6.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  医院模型
 */
@interface Hospital : NSObject
/**
 *  地址
 */
@property (nonatomic, copy) NSString *address;
/**
 *  城市名称
 */
@property (nonatomic, copy) NSString *city_name;
/**
 *  区名/县名
 */
@property (nonatomic, copy) NSString *county_name;
/**
 *  医院id
 */
@property (nonatomic, copy) NSString *hospital_id;
/**
 *  价钱
 */
@property (nonatomic, copy) NSString *price;
/**
 *  图片地址
 */
@property (nonatomic, copy) NSString *image;
/**
 *  医院等级
 */
@property (nonatomic, copy) NSString *level_str;
/**
 *  医院所在省份
 */
@property (nonatomic, copy) NSString *province_name;
/**
 *  医院简称（院名）
 */
@property (nonatomic, copy) NSString *short_name;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)hospitalWithDict:(NSDictionary *)dict;

@end
