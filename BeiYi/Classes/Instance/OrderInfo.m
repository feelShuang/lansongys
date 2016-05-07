//
//  OrderInfo.m
//  BeiYi
//
//  Created by Joe on 15/5/20.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "OrderInfo.h"


@implementation OrderInfo

- (instancetype)init {
    if (self = [super init]) {
        self.service_type = @"0";
        self.assure_flag = NO;
        self.isUpLoading = YES;
    }
    return self;
}


static OrderInfo *_instance = nil;

+ (OrderInfo *)shareInstance {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[OrderInfo alloc] init];
    });

    return _instance;
}


@end
