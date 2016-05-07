//
//  LSPatientOrder.m
//  BeiYi
//
//  Created by LiuShuang on 16/1/25.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSPatientOrder.h"

@implementation LSPatientOrder

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
        return @{
                 @"myorder_id": @"id",
                 };
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}

@end
