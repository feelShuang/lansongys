//
//  LSBrokerGrabOrderTableViewCell.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/1.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSGrabOrder,LSBrokerGrabOrderTableViewCell;

@protocol LSBrokerGrabOrderDelegate <NSObject>

- (void)grabOrderCell:(LSBrokerGrabOrderTableViewCell *)grabOrderCell didClickedGrabBtn:(UIButton *)grabBtn;

@end

@interface LSBrokerGrabOrderTableViewCell : UITableViewCell

/** 抢单 模型 */
@property (nonatomic, strong) LSGrabOrder *grabOrder;

/** 价格 */ // 方便比较余额和订单的价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

/** 抢单Cell代理 */
@property (nonatomic, assign) id<LSBrokerGrabOrderDelegate> delegate;

@end
