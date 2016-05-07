//
//  LSRegularEx.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/8.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSRegularEx : NSObject

/**
 *  验证手机号码
 *
 *  @param phoneNum 手机号码
 *
 *  @return 返回值类型 BOOL
 */
+ (BOOL)validatePhoneNum:(NSString *)phoneNum;

/**
 *  验证身份证号码
 *
 *  @param identityCard 身份证号码
 *
 *  @return 返回值类型 BOOL
 */
+ (BOOL)validateIdentityCard: (NSString *)identityCard;

@end
