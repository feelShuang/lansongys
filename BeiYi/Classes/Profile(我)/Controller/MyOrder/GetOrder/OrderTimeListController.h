//
//  OrderTimeListController.h
//  BeiYi
//
//  Created by Joe on 15/7/2.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderTimeListVcDelegate <NSObject>

@optional
/**
 *  传递取号时间 代理方法
 *
 *  @param time         取号日期
 *  @param timeSelected 具体时间1-上午 2-下午
 */
- (void)OrderTimeListPassTime:(NSString *)time timeSelected:(int)timeSelected;

@end
/**
 *  订单时间列表 控制器
 */
@interface OrderTimeListController : UITableViewController

/** NSString 订单编号 */
@property (nonatomic, copy) NSString *orderCode;

@property (nonatomic, weak) id<OrderTimeListVcDelegate> delegate;

@end
