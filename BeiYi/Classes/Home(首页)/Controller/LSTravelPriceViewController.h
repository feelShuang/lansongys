//
//  LSTravelPriceViewController.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/13.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSGrabOrder;
@class LSBrokerOrder;

@interface LSTravelPriceViewController : UIViewController

/**
 *  抢单模型
 */
@property (nonatomic, strong) LSGrabOrder *grabOrder;

/**
 *  经纪人订单模型
 */
@property (nonatomic, strong) LSBrokerOrder *brokerOrder;

/**
 *  订单价格
 */
@property (nonatomic, copy) NSString *orderPrice;

@end
