//
//  LSBrokerCertificateViewController.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/15.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSPatientOrderDetail;

@interface LSBrokerCertificateViewController : UIViewController

/**
 *  订单详情模型
 */
@property (nonatomic, strong)  LSPatientOrderDetail *brokerOrderDetail;

@end
