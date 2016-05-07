//
//  Avatar.m
//  BeiYi
//
//  Created by Joe on 15/7/2.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "Avatar.h"

static Avatar *_instance = nil;

@implementation Avatar

- (instancetype)init {
    if ([super init]) {
        
    }
    return self;
}

+ (Avatar *)sharedInstance {
    @synchronized ([Avatar class]) {
        if (_instance == nil) {
            _instance = [[Avatar alloc] init];
        }
        return _instance;
    }
}

@end
