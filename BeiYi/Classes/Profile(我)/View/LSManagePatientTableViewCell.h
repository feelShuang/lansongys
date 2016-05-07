//
//  LSManagePatientTableViewCell.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/7.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSPatient;

@interface LSManagePatientTableViewCell : UITableViewCell

/**
 *  患者模型
 */
@property (nonatomic, strong) LSPatient *patient;

@end
