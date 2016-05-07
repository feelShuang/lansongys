//
//  Doctor.m
//  BeiYi
//
//  Created by Joe on 15/5/18.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "Doctor.h"

@implementation Doctor

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.doctor_id = [dict[@"id"] intValue];
        self.name = dict[@"name"];
        self.avator = dict[@"avator"];
        self.level = [dict[@"level"] intValue];
    }
    return self;
}
+ (instancetype)doctorlWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
