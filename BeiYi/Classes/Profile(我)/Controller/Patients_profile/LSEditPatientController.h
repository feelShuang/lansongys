//
//  LSEditPatientController.h
//  BeiYi
//
//  Created by LiuShuang on 15/6/16.
//  Copyright (c) 2015年 LiuShuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPatient.h"
/**
 *  修改就诊人 控制器
 */
@interface LSEditPatientController : UIViewController

/** 修改就诊人 控制器 的就诊人模型  */
@property (nonatomic, strong) LSPatient *patient;

@end
