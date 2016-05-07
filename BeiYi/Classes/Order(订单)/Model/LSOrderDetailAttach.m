//
//  LSOrderDetailAttach.m
//  BeiYi
//
//  Created by 刘爽 on 16/1/27.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "LSOrderDetailAttach.h"

@implementation LSOrderDetailAttach

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"attach_id": @"id"
             };
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}

@end
