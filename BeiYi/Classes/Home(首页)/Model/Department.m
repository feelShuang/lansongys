//
//  Department.m
//  BeiYi
//
//  Created by Joe on 15/5/18.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "Department.h"
#import "ChildDepartment.h"

@implementation Department

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        
        self.depart_id = [dict[@"id"] intValue];
        self.dept_name = dict[@"dept_name"];

        // 取出原来的字典数组
        NSArray *dictArray = dict[@"childList"];
        NSMutableArray *carArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            ChildDepartment *child = [ChildDepartment childDepartWithDict:dict];
            [carArray addObject:child];
        }
        self.childList = carArray;
    }
    return self;
}
+ (instancetype)departWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
