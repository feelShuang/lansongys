//
//  LSOrderTableViewCell.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/1.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSPatientOrder;
@class LSBrokerOrder;

@interface LSOrderTableViewCell : UITableViewCell

/**
 *  患者订单模型
 */
@property (nonatomic, strong) LSPatientOrder *patientOrder;

/**
 *  经纪人订单模型
 */
@property (nonatomic, strong) LSBrokerOrder *brokerOrder;

//
@property (nonatomic, copy) NSString *over_status;

@end
