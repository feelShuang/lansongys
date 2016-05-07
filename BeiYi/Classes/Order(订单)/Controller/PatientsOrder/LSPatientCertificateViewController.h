//
//  LSPatientCertificateViewController.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/15.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSPatientOrderDetail;

@interface LSPatientCertificateViewController : UIViewController

/**
 *  患者订单详情
 */
@property (nonatomic, strong) LSPatientOrderDetail *patientOrderDetail;

@end
