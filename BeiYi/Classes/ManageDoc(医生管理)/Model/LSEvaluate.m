//
//  LSEvaluate.m
//  BeiYi
//
//  Created by LiuShuang on 16/5/5.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSEvaluate.h"
#import <MJExtension.h>

@implementation LSEvaluate

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"user_id": @"id"
             };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
