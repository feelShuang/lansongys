//
//  PlanDay.h
//  BeiYi
//
//  Created by Joe on 15/10/10.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  上传的数据（每一天） 模型
 */
@interface PlanDay : NSObject<NSCoding>

/** NSString 天数（是一星期里面的第几天） */
@property (nonatomic, copy) NSString *week;
/** NSString 日期 -- 2015-01-03 */
@property (nonatomic, copy) NSString *week_date;
/** NSString 数量 */
@property (nonatomic, copy) NSString *number;

+ (instancetype)planDayWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
