//
//  LSDoctorLevels.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/6.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSDoctorLevels.h"

@implementation LSDoctorLevels

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)levelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
