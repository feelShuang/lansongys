//
//  GetOrder.m
//  BeiYi
//
//  Created by Joe on 15/5/28.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "GetOrder.h"
#import "MJExtension.h"

@implementation GetOrder

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"order_id": @"id"
             };
    
}

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             
             @"attach": @"OrderAttach"
             
             };
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}

@end
