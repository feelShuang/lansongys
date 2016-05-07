//
//  AttendanceTimeCell.h
//  BeiYi
//
//  Created by Joe on 15/7/23.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
/** UITableViewCell 就诊时间*/
@interface AttendanceTimeCell : UITableViewCell
/** UILabel 开始时间*/
@property (nonatomic, strong) UILabel *lblBeginTime;
/** UILabel 结束时间*/
@property (nonatomic, strong) UILabel *lblEndTime;
/** UILabel 申请退单提示*/
@property (nonatomic, strong) UILabel *lblTip;
/** UILabel 退单类型*/
@property (nonatomic, strong) UILabel *lblType;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
