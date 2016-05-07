//
//  GetOrderDetailController.h
//  BeiYi
//
//  Created by Joe on 15/6/25.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  抢单订单(订单被抢未付款时) 控制器
 */
@interface GetOrderDetailController : UITableViewController

/** 抢单信息 */
@property (nonatomic, strong) NSDictionary *orderInfos;

@end
