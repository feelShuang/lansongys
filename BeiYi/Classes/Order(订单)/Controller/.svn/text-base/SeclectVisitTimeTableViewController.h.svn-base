//
//  SeclectVisitTimeTableViewController.h
//  BeiYi
//
//  Created by 刘爽 on 16/2/19.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectVisitTimeDelegate <NSObject>

- (void)visitHospitalWithTime:(NSString *)time;

@end

@interface SeclectVisitTimeTableViewController : UITableViewController

// 订单编号
@property (nonatomic, copy) NSString *order_code;
// 订单类型
@property (nonatomic, copy) NSString *order_type;
// 代理
@property (nonatomic, assign) id<selectVisitTimeDelegate> delegate;

@end
