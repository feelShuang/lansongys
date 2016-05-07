//
//  LSBrokerDoctor.m
//  BeiYi
//
//  Created by LiuShuang on 15/9/14.
//  Copyright (c) 2015年 LiuShuang. All rights reserved.
//

#import "LSBrokerDoctor.h"
#import <MJExtension.h>

@implementation LSBrokerDoctor

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"doctor_id": @"id"
             };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
