//
//  HosInfoCell.m
//  BeiYi
//
//  Created by Joe on 15/7/23.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "HosInfoCell.h"
#import "Common.h"

@interface HosInfoCell()

@end

@implementation HosInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 取消选中（点击不变灰）
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _lblName = [[UILabel alloc] init];
        _lblName.textColor = ZZColor(51, 51, 51, 1);
        _lblName.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblName];

        _lblDetailName = [[UILabel alloc] init];
        _lblDetailName.textColor = ZZBaseColor;
        _lblDetailName.font = [UIFont systemFontOfSize:15];
        _lblDetailName.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_lblDetailName];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableVeiw {
    static NSString *ID = @"HosInfoCell";
    HosInfoCell *cell = [tableVeiw dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HosInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _lblName.frame = CGRectMake(15, 0, 70, 50);
    _lblDetailName.frame = CGRectMake(self.contentView.frame.size.width -165, 0, 150, 70);
}

@end
