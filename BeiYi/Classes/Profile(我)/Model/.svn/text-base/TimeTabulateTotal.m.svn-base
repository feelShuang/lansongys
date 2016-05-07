//
//  TimeTabulateTotal.m
//  BeiYi
//
//  Created by Joe on 15/10/10.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "TimeTabulateTotal.h"
#import "TimeTabulate.h"

@implementation TimeTabulateTotal

+ (instancetype)tabulateTotalWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
    
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
        
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dict in self.weekList) {
            TimeTabulate *time = [TimeTabulate timeTabulateWithDict:dict];
            [temp addObject:time];
        }
        self.weekList = temp;
    }
    
    return self;
}

@end
