//
//  LSGrabOrder.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/12.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSGrabOrder.h"
#import <MJExtension.h>

@implementation LSGrabOrder

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"grabOrder_id": @"id"
             };
}

@end
