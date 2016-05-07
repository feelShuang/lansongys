//
//  OrderTimeCell.h
//  BeiYi
//
//  Created by Joe on 15/7/2.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderTimeCell;

@protocol OrderTimeCellDelegate <NSObject>

@optional
- (void)orderTimeCellSelectedBtnMorning:(OrderTimeCell *)ordertimeCell;
- (void)orderTimeCellSelectedBtnAfternoon:(OrderTimeCell *)ordertimeCell;
@end
/**
 *  订单时间cell
 */
@interface OrderTimeCell : UITableViewCell
/**
 *  通过一个tableView来创建一个cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<OrderTimeCellDelegate> delegate;

@end
