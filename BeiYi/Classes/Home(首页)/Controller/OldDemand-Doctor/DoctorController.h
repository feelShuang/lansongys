//
//  DoctorController.h
//  BeiYi
//
//  Created by Joe on 15/5/18.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  医生选择列表
 */
@interface DoctorController : UITableViewController
/**
 *  接受到的 hospital_id 和 department_id（子科室ID）
 */
@property (nonatomic, strong) NSArray *arrIds;

@end
