//
//  AttendanceInfoCell.m
//  BeiYi
//
//  Created by Joe on 15/7/23.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "AttendanceInfoCell.h"
#import "Common.h"

@interface AttendanceInfoCell()
/** UILabel 就诊信息*/
@property (nonatomic, strong) UILabel *lblInfo;
/** UILabel 取号时间提示*/
@property (nonatomic, strong) UILabel *lblTimeTip;

@end

@implementation AttendanceInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 取消选中（点击不变灰）
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.lblInfo.text = @"就诊信息";
        self.lblInfo.textColor = ZZColor(51, 51, 51, 1);
        self.lblInfo.font = [UIFont systemFontOfSize:15];
        
        self.lblWord.textColor = ZZColor(102, 102, 102, 1);
        self.lblWord.font = [UIFont systemFontOfSize:12.5];
        self.lblWord.numberOfLines = 0;
        self.lblWord.hidden = YES;
        self.lblWord.lineBreakMode = NSLineBreakByCharWrapping;
        
        self.lblTimeTip.text = @"取号时间：";
        self.lblTimeTip.textColor = ZZColor(102, 102, 102, 1);
        self.lblTimeTip.font = [UIFont systemFontOfSize:12.5];
        
        self.lblTime.textColor = ZZBaseColor;
        self.lblTime.font = [UIFont systemFontOfSize:12.5];
        
        self.lblIconTip.text = @"图片展示：";
        self.lblIconTip.textColor = ZZColor(102, 102, 102, 1);
        self.lblIconTip.font = [UIFont systemFontOfSize:12.5];
        self.lblIconTip.hidden = YES;
        
        self.icon.hidden = YES;
        self.icon.adjustsImageWhenHighlighted = NO;
        [self.icon addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableVeiw {
    static NSString *ID = @"AttendanceInfoCell";
    AttendanceInfoCell *cell = [tableVeiw dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AttendanceInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (UILabel *)lblWord {
    if (_lblWord == nil) {
        self.lblWord = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblWord];
    }
    return _lblWord;
}

- (UILabel *)lblTime {
    if (_lblTime == nil) {
        self.lblTime = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblTime];
    }
    return _lblTime;
}

- (UILabel *)lblPriceDetail {
    if (_lblPriceDetail== nil) {
        self.lblPriceDetail = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblPriceDetail];
    }
    return _lblPriceDetail;
}

- (UILabel *)lblIconTip {
    if (_lblIconTip == nil) {
        self.lblIconTip = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblIconTip];
    }
    return _lblIconTip;
}

- (UIButton *)icon {
    if (_icon == nil) {
        self.icon = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.icon];
    }
    return _icon;
}

- (UILabel *)lblInfo {
    if (_lblInfo == nil) {
        self.lblInfo = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblInfo];
    }
    return _lblInfo;
}

- (UILabel *)lblTimeTip {
    if (_lblTimeTip == nil) {
        self.lblTimeTip = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblTimeTip];
    }
    return _lblTimeTip;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = self.contentView.frame.size.width;
    
    CGFloat margin = 8;
    
    self.lblInfo.frame = CGRectMake(15, margin, w/2, 30);

    CGSize lblWordSize = CGSizeMake(w - 15*2, 10000);// 高度自适应
    CGSize lblWordSizeNew = [self.lblWord.text sizeWithFont:[UIFont systemFontOfSize:12.5] constrainedToSize:lblWordSize lineBreakMode:NSLineBreakByWordWrapping];
    self.lblWord.frame = CGRectMake(15, CGRectGetMaxY(self.lblInfo.frame), lblWordSizeNew.width, lblWordSizeNew.height);
    
    CGSize lblTimeTipSize = CGSizeMake(10000, 20);// 宽度自适应
    CGSize lblTimeTipNew = [self.lblTimeTip.text sizeWithFont:[UIFont systemFontOfSize:12.5] constrainedToSize:lblTimeTipSize lineBreakMode:NSLineBreakByWordWrapping];
    self.lblTimeTip.frame = CGRectMake(15, CGRectGetMaxY(self.lblWord.frame), lblTimeTipNew.width, 20);
                                    
    self.lblTime.frame = CGRectMake(15 +lblTimeTipNew.width, CGRectGetMaxY(self.lblWord.frame), w -15*2-lblTimeTipNew.width, 20);

    self.lblIconTip.frame = CGRectMake(15, CGRectGetMaxY(self.lblTime.frame), lblTimeTipNew.width, 20);
    
    self.icon.frame = CGRectMake(15 +lblTimeTipNew.width, CGRectGetMaxY(self.lblTime.frame), 44, 44);
    
    if (self.lblIconTip.hidden == YES) {
        CGRect rect = self.frame;
        rect.size.height = CGRectGetMaxY(self.lblTime.frame) +margin;
        self.frame = rect;
        
    }else {
        CGRect rect = self.frame;
        rect.size.height = CGRectGetMaxY(self.icon.frame)+margin;
        self.frame = rect;
    }
}

- (void)btnClicked {
    if ([self.delegate respondsToSelector:@selector(attendanceInfoCellIconBtnClicked:)]) {
        [self.delegate attendanceInfoCellIconBtnClicked:self];
    }
}

@end
