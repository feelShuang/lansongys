//
//  ChildDepartment.m
//  BeiYi
//
//  Created by Joe on 15/5/18.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ChildDepartment.h"

@implementation ChildDepartment

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.childList_id = [dict[@"id"] intValue];
        self.dept_name = dict[@"dept_name"];
    }
    return self;
}

+ (instancetype)childDepartWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
@end
