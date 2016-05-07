//
//  PayCell.h
//  BeiYi
//
//  Created by Joe on 15/6/3.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayCell : UITableViewCell
/** UILabel 就诊人信息 */
@property (strong, nonatomic) UILabel *lbl1;
/** UILabel 患者姓名*/
@property (strong, nonatomic) UILabel *lbl2;
/** UILabel 患者姓名Detail*/
@property (strong, nonatomic) UILabel *lbl2Detail;
/** UILabel 身份证号*/
@property (strong, nonatomic) UILabel *lbl3;
/** UILabel 手机号码*/
@property (strong, nonatomic) UILabel *lbl4;
/** UILabel 性别*/
@property (strong, nonatomic) UILabel *lbl5;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
