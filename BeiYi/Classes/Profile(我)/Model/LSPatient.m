//
//  LSPatient.m
//  BeiYi
//
//  Created by LiuShuang on 15/5/26.
//  Copyright (c) 2015年 LiuShuang. All rights reserved.
//

#import "LSPatient.h"
#import <MJExtension.h>

@implementation LSPatient

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"patient_id": @"id"
             };
}

@end
