//
//  AlipayOrder.h
//  BeiYi
//
//  Created by Joe on 15/7/15.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  支付宝订单
 */
@interface AlipayOrder : NSObject

/**
 *  商户的唯一的parnter
 */
@property(nonatomic, copy) NSString * partner;
/**
 *  商户的唯一的seller
 */
@property(nonatomic, copy) NSString * seller;
/**
 *  订单ID（由商家自行制定）
 */
@property(nonatomic, copy) NSString * tradeNO;
/**
 *  商品标题
 */
@property(nonatomic, copy) NSString * productName;
/**
 *  商品描述
 */
@property(nonatomic, copy) NSString * productDescription;
/**
 *  商品价格
 */
@property(nonatomic, copy) NSString * amount;
/**
 *  回调URL
 */
@property(nonatomic, copy) NSString * notifyURL;

@property(nonatomic, copy) NSString * service;
@property(nonatomic, copy) NSString * paymentType;
@property(nonatomic, copy) NSString * inputCharset;
@property(nonatomic, copy) NSString * itBPay;
@property(nonatomic, copy) NSString * showUrl;


@property(nonatomic, copy) NSString * rsaDate;//可选
@property(nonatomic, copy) NSString * appID;//可选

@property(nonatomic, readonly) NSMutableDictionary * extraParams;

@end
