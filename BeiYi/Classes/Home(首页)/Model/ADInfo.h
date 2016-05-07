//
//  ADInfo.h
//  BeiYi
//
//  Created by Joe on 15/11/11.
//  Copyright © 2015年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADInfo : NSObject

@property (nonatomic, copy) NSString *infoID;
@property (nonatomic, copy) NSString *jump_url;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *name;

+ (instancetype)adInfoWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
