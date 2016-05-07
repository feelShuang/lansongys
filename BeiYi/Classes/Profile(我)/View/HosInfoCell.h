//
//  HosInfoCell.h
//  BeiYi
//
//  Created by Joe on 15/7/23.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  UITableViewCell-用来显示医院/科室/医生的名称
 */
@interface HosInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblDetailName;

+(instancetype)cellWithTableView:(UITableView *)tableVeiw;

@end
