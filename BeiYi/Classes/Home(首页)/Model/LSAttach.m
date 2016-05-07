//
//  LSAttach.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/12.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSAttach.h"
#import <MJExtension.h>

@implementation LSAttach

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"attach_id": @"id",
             };
}

@end
