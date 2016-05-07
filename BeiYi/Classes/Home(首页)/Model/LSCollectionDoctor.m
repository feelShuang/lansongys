//
//  LSCollectionDoctor.m
//  BeiYi
//
//  Created by LiuShuang on 16/2/24.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSCollectionDoctor.h"
#import "Common.h"

@implementation LSCollectionDoctor

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"doc_id": @"id"
             };
}

@end
