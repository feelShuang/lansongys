//
//  ManageDepts.m
//  BeiYi
//
//  Created by Joe on 15/9/11.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ManageDepts.h"

@implementation ManageDepts

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.hospital_name = dict[@"hospital_name"];
        self.managedept_id = dict[@"id"];
        self.price = dict[@"price"];
        self.parent_name = dict[@"parent_name"];
        self.department_id = dict[@"department_id"];
        self.dept_name = dict[@"dept_name"];
        self.hospital_id = dict[@"hospital_id"];
        
    }
    return self;
}

+ (instancetype)manageDeptsWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
