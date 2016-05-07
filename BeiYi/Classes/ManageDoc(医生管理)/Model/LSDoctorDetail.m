//
//  LSDoctorDetail.m
//  BeiYi
//
//  Created by LiuShuang on 16/1/28.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSDoctorDetail.h"
#import "MJExtension.h"

@implementation LSDoctorDetail : NSObject 

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"doctor_id": @"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"services": @"Service"
             };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
