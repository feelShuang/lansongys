//
//  LSCollectionHospital.m
//  BeiYi
//
//  Created by LiuShuang on 16/2/24.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSCollectionHospital.h"
#import "Common.h"

@implementation LSCollectionHospital

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"hos_id": @"id",
             @"imageStr": @"image"
             };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
