//
//  LSSelectPayModeController.h
//  BeiYi
//
//  Created by LiuShuang on 15/6/24.
//  Copyright (c) 2015年 LiuShuang. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  选择支付方式 控制器
 */
@interface LSSelectPayModeController : UIViewController

/**  NSString 保证金金额 */
@property (nonatomic, copy) NSString *price;

/**  NSString 订单号 */
@property (nonatomic, copy) NSString *orderCode;

/**  NSString 付款类型2-发布订单 4-抢单 */
@property (nonatomic, copy) NSString *payType;

@end
