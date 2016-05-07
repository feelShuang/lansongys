//
//  LSAccount.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/6.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSAccount : NSObject

// 账号
@property (nonatomic, copy) NSString *user;

// 密码
@property (nonatomic, copy) NSString *pwd;


+ (LSAccount *)sharedInstance;

@end
