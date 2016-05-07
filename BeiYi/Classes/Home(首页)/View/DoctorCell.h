//
//  DoctorCell.h
//  BeiYi
//
//  Created by Joe on 15/5/18.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Doctor;
/**
 *  医生cell
 */
@interface DoctorCell : UITableViewCell
/**
 *  通过一个tableView来创建一个cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/**
 *  医生模型
 */
@property (nonatomic, strong) Doctor *doctor;

@end
