//
//  AttendanceInfoCell.h
//  BeiYi
//
//  Created by Joe on 15/7/23.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AttendanceInfoCell;

@protocol AttendanceInfoCellDelegate <NSObject>

- (void)attendanceInfoCellIconBtnClicked:(AttendanceInfoCell *)cell;

@end

@interface AttendanceInfoCell : UITableViewCell
/** UILabel 文字描述*/
@property (nonatomic, strong) UILabel *lblWord;
/** UILabel 取号时间*/
@property (nonatomic, strong) UILabel *lblTime;
/** UILabel 图片展示提示*/
@property (nonatomic, strong) UILabel *lblPriceDetail;
/** UILabel 图片展示提示*/
@property (nonatomic, strong) UILabel *lblIconTip;
/** UIButton 凭证图片*/
@property (nonatomic, strong) UIButton *icon;

@property (nonatomic, weak) id<AttendanceInfoCellDelegate> delegate;

+(instancetype)cellWithTableView:(UITableView *)tableVeiw;

@end
