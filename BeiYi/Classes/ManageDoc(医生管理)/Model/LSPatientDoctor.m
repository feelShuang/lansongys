//
//  LSPatientDoctor.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/7.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSPatientDoctor.h"
#import <MJExtension.h>

@implementation LSPatientDoctor

- (instancetype)init {
    
    if (self = [super init]) {
        self.avg_score = @"0";
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"doctor_id": @"id"
             };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
