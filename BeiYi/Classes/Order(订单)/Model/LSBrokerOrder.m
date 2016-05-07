//
//  LSBrokerOrder.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/14.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSBrokerOrder.h"
#import <MJExtension.h>

@implementation LSBrokerOrder

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"order_id": @"id"
             };
}

@end
