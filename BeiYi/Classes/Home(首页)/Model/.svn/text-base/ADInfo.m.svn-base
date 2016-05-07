//
//  ADInfo.m
//  BeiYi
//
//  Created by Joe on 15/11/11.
//  Copyright © 2015年 Joe. All rights reserved.
//

#import "ADInfo.h"

@implementation ADInfo

+ (instancetype)adInfoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.infoID = dict[@"id"];
        self.jump_url = dict[@"jump_url"];
        self.image_url = dict[@"image_url"];
        self.name = dict[@"name"];
        
    }
    return self;
}

@end
