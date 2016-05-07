//
//  LSPatientOrderDetail.m
//  BeiYi
//
//  Created by LiuShuang on 16/1/27.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSPatientOrderDetail.h"

@implementation LSPatientOrderDetail

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"order_id": @"id",
             };
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
