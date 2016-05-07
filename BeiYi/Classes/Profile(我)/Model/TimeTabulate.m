//
//  TimeTabulate.m
//  BeiYi
//
//  Created by Joe on 15/10/10.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "TimeTabulate.h"

@implementation TimeTabulate

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.week = dict[@"week"];
        self.planNumber = [dict[@"planNumber"] integerValue];
        self.showDate = dict[@"showDate"];
        self.usedNumber = [dict[@"usedNumber"] integerValue];
        self.date = dict[@"date"];
        
    }
    return self;
}

+ (instancetype)timeTabulateWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
