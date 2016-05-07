//
//  GetOrderCell.h
//  BeiYi
//
//  Created by Joe on 15/5/28.
//  Copyright (c) 2015年 Joe. All rights reserved.
//


#import <UIKit/UIKit.h>
@class GetOrder,GetOrderCell;

/** GetOrderCell代理 */
@protocol GetOrderCellDelegate <NSObject>

@optional
/** 监听 抢单按钮 点击 */
- (void)getOrderCell:(GetOrderCell *)getOrderCell didClickedBtnGrab:(UIButton *)btn;

@end

@interface GetOrderCell : UITableViewCell

/** 通过一个tableView来创建一个cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** 抢单 模型 */
@property (nonatomic, strong) GetOrder *getOrder;

/**  代理 */
@property (nonatomic, weak) id<GetOrderCellDelegate> delegate;

@end
