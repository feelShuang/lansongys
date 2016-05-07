//
//  PlanDay.m
//  BeiYi
//
//  Created by Joe on 15/10/10.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "PlanDay.h"

@implementation PlanDay

+ (instancetype)planDayWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)enCoder {
    [enCoder encodeObject:self.week forKey:@"week"];
    [enCoder encodeObject:self.week_date forKey:@"week_date"];
    [enCoder encodeObject:self.number forKey:@"number"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.week =[decoder decodeObjectForKey:@"week"];
        self.week_date = [decoder decodeObjectForKey:@"week_date"];
        self.number = [decoder decodeObjectForKey:@"number"];
        
    }
    return self;
}

@end
