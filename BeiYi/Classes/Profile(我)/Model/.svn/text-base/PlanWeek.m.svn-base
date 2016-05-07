//
//  PlanWeek.m
//  BeiYi
//
//  Created by Joe on 15/10/10.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "PlanWeek.h"
#import "PlanDay.h"

@implementation PlanWeek

+ (instancetype)planWeekWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dict in self.detail) {
            PlanDay *day = [PlanDay planDayWithDict:dict];
            [temp addObject:day];
        }
        self.detail = temp;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)enCoder {
    [enCoder encodeObject:self.start forKey:@"start"];
    [enCoder encodeObject:self.end forKey:@"end"];
    [enCoder encodeObject:self.detail forKey:@"detail"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.start =[decoder decodeObjectForKey:@"start"];
        self.end = [decoder decodeObjectForKey:@"end"];
        self.detail = [decoder decodeObjectForKey:@"detail"];

    }
    return self;
}
@end
