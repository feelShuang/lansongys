//
//  AttendanceTimeCell.m
//  BeiYi
//
//  Created by Joe on 15/7/23.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "AttendanceTimeCell.h"
#import "Common.h"

@interface AttendanceTimeCell()
@property (nonatomic, strong) UIImageView *iconBegin;
@property (nonatomic, strong) UIImageView *iconEnd;
@property (nonatomic, strong) UILabel *lblTime;

@end

@implementation AttendanceTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 取消选中（点击不变灰）
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.lblTime.text = @"就诊时间";
        self.lblTime.textColor = ZZColor(51, 51, 51, 1);
        self.lblTime.font = [UIFont systemFontOfSize:15];
        
        self.iconBegin.image = [UIImage imageNamed:@"TimeBegin"];
        self.iconEnd.image = [UIImage imageNamed:@"TimeEnd"];

        self.lblBeginTime.textColor = ZZColor(102, 102, 102, 1);
        self.lblBeginTime.font = [UIFont systemFontOfSize:12.5];
//        self.lblBeginTime.backgroundColor = [UIColor redColor];

        self.lblEndTime.textColor = ZZColor(102, 102, 102, 1);
        self.lblEndTime.font = [UIFont systemFontOfSize:12.5];
        
        self.lblTip.textColor = ZZButtonClickedColor;
        self.lblTip.font = [UIFont systemFontOfSize:15];
        self.lblTip.hidden = YES;
        self.lblTip.textAlignment = NSTextAlignmentLeft;
        
        self.lblType.textColor = ZZColor(51, 51, 51, 1);
        self.lblType.font = [UIFont systemFontOfSize:12.5];
        self.lblType.hidden = YES;
        self.lblType.textAlignment = NSTextAlignmentLeft;

    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"AttendanceTimeCell";
    AttendanceTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AttendanceTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (UIImageView *)iconBegin {
    if (_iconBegin == nil) {
        self.iconBegin = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconBegin];
    }
    return _iconBegin;
}

- (UIImageView *)iconEnd {
    if (_iconEnd == nil) {
        self.iconEnd = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconEnd];
    }
    return _iconEnd;
}

- (UILabel *)lblTime {
    if (_lblTime == nil) {
        self.lblTime = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblTime];
    }
    return _lblTime;
}

- (UILabel *)lblBeginTime {
    if (_lblBeginTime == nil) {
        self.lblBeginTime = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblBeginTime];
    }
    return _lblBeginTime;
}

- (UILabel *)lblEndTime {
    if (_lblEndTime == nil) {
        self.lblEndTime = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblEndTime];
    }
    return _lblEndTime;
}

- (UILabel *)lblTip {
    if (_lblTip == nil) {
        self.lblTip = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblTip];
    }
    return _lblTip;
}

- (UILabel *)lblType {
    if (_lblType == nil) {
        self.lblType = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblType];
    }
    return _lblType;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = self.contentView.frame.size.width;
    
    CGFloat margin = 8;
    
    self.lblTime.frame = CGRectMake(15, margin, w/4, 30);

    self.iconBegin.frame = CGRectMake(15, CGRectGetMaxY(self.lblTime.frame), 20, 20);
    
    self.iconEnd.frame = CGRectMake(w *0.45, CGRectGetMaxY(self.lblTime.frame), 20, 20);

    self.lblBeginTime.frame = CGRectMake(CGRectGetMaxX(self.iconBegin.frame)+5, CGRectGetMaxY(self.lblTime.frame), w/4, 20);
    
    self.lblEndTime.frame = CGRectMake(CGRectGetMaxX(self.iconEnd.frame)+5, CGRectGetMaxY(self.lblTime.frame), w/4, 20);
    
    self.lblTip.frame = CGRectMake(15, CGRectGetMaxY(self.iconBegin.frame) +5, w/2, 30);
    
    self.lblType.frame = CGRectMake(15, CGRectGetMaxY(self.lblTip.frame), w -30, 20);
}

@end
