//
//  TimeTabulate.h
//  BeiYi
//
//  Created by Joe on 15/10/10.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  时间排表--[每一天]--数据模型
 */
@interface TimeTabulate : NSObject

/** NSString 天数（是一星期里面的第几天） */
@property (nonatomic, copy) NSString *week;
/** NSInteger 拥有的号的数量 */
@property (nonatomic, assign) NSInteger planNumber;
/**  NSString 显示的日期 09-20 */
@property (nonatomic, copy) NSString *showDate;
/**  NSInteger 使用过的号的数量 */
@property (nonatomic, assign) NSInteger usedNumber;
/**  NSString 当前时间 2015-09-20 */
@property (nonatomic, copy) NSString *date;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)timeTabulateWithDict:(NSDictionary *)dict;

@end
