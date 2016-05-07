//
//  PlanWeek.h
//  BeiYi
//
//  Created by Joe on 15/10/10.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  上传的数据（每周） 模型
 */
@interface PlanWeek : NSObject<NSCoding>

/** NSString 开始时间 */
@property (nonatomic, copy) NSString *start;
/** NSString 结束时间 */
@property (nonatomic, copy) NSString *end;
/** NSArray 数组里存放PlanDay模型 */
@property (nonatomic, strong) NSArray *detail;

+ (instancetype)planWeekWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
