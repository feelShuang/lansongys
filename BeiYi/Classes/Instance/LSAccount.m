//
//  LSAccount.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/6.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSAccount.h"

@implementation LSAccount

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

static LSAccount *_instance = nil;
+ (LSAccount *)sharedInstance {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[LSAccount alloc] init];
    });
    return _instance;
}

@end
