//
//  Avatar.h
//  BeiYi
//
//  Created by Joe on 15/7/2.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  头像单例
 */
@interface Avatar : NSObject

/** NSString 	用户头像 */
@property (nonatomic, copy) NSString *avator;

+ (Avatar *)sharedInstance;

@end
