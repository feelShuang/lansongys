//
//  TimeTabulateTotal.h
//  BeiYi
//
//  Created by Joe on 15/10/10.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  时间排表--[完整]--数据模型
 */
@interface TimeTabulateTotal : NSObject

/** NSString 开始时间 */
@property (nonatomic, copy) NSString *start;
/** NSArray 数组里面是 TimeTabulate数组模型（每一天的数据） */
@property (nonatomic, strong) NSArray *weekList;
/**  NSString 结束时间 */
@property (nonatomic, copy) NSString *end;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)tabulateTotalWithDict:(NSDictionary *)dict;

@end
