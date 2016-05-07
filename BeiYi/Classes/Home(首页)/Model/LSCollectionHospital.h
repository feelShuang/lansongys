//
//  LSCollectionHospital.h
//  BeiYi
//
//  Created by LiuShuang on 16/2/24.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSCollectionHospital : NSObject
/**
 *  收藏的医院模型
 */

/** 医院地址 */
@property (nonatomic, copy) NSString *address;

/** 医院等级 */
@property (nonatomic, copy) NSString *level_str;

/** 医院所在地区 */
@property (nonatomic, copy) NSString *county_name;

/** 医院ID */
@property (nonatomic, copy) NSString *hos_id;

/** 医院图片 */
@property (nonatomic, strong) NSURL *imageStr;

/** 医院简称 */
@property (nonatomic, copy) NSString *short_name;

/** 医院所在省 */
@property (nonatomic, copy) NSString *province_name;

/** 医院所在城市 */
@property (nonatomic, copy) NSString *city_name;

@end
