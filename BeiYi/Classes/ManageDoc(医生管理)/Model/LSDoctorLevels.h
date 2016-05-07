//
//  LSDoctorLevels.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/6.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSDoctorLevels : NSObject
/**
 *  医生级别名称
 */
@property (nonatomic, copy) NSString *level_name;
/**
 *  医生级别id
 */
@property (nonatomic, copy) NSString *level_id;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)levelWithDict:(NSDictionary *)dict;

@end


