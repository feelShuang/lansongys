//
//  LSEvaluationViewController.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/18.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSPatientOrderDetail;

@interface LSEvaluationViewController : UIViewController
/** 就诊人数 */
@property (nonatomic, copy) NSString *visitNum;
/** 患者订单详情 */
@property (nonatomic, strong) LSPatientOrderDetail *patientOrderDetail;

@end
