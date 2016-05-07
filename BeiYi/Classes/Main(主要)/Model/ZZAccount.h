//
//  ZZAccount.h
//  BeiYi
//
//  Created by Joe on 15/5/20.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject <NSCoding>

// 昵称
@property (nonatomic, copy) NSString *nickName;

// mobile
@property (nonatomic, copy) NSString *mobile;

// token
@property (nonatomic, copy) NSString *token;

// realName
@property (nonatomic, copy) NSString *realName;

@end


@interface Notice : NSObject <NSCoding>

// 患者阅读标记
@property (nonatomic, copy) NSString *publish_order_read_count;

// 经纪人订单阅读标记
@property (nonatomic, copy) NSString *offer_order_read_count;

@end


/**
 *  用户帐号模型
 */
@interface ZZAccount : NSObject <NSCoding>

/** session */
@property (nonatomic, strong) Session *session;

// notice_tag
@property (nonatomic, strong) Notice *notice_tag;

@end
