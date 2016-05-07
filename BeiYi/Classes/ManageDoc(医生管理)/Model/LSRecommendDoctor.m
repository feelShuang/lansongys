//
//  LSRecommendDoctor.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/6.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSRecommendDoctor.h"
#import <MJExtension.h>

@implementation LSRecommendDoctor

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"doctor_id": @"id"
             };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
