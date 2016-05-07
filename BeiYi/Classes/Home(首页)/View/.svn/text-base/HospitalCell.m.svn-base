//
//  HospitalCell.m
//  BeiYi
//
//  Created by Joe on 15/5/18.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "HospitalCell.h"
#import "UIImageView+WebCache.h"
#import "Hospital.h"
#import "Common.h"

@interface HospitalCell()
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *lblTitle;
@property (strong, nonatomic) UILabel *lblAddress;
@property (strong, nonatomic) UILabel *lblLevel;
@end
@implementation HospitalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconView.layer.cornerRadius = 30.f;
        self.iconView.layer.masksToBounds = YES;
        
        self.lblTitle.font = [UIFont systemFontOfSize:16];
        self.lblAddress.font = [UIFont systemFontOfSize:13];
        self.lblLevel.font = [UIFont systemFontOfSize:13];
        self.lblAddress.textColor = [UIColor darkGrayColor];
        self.lblLevel.textColor = [UIColor darkGrayColor];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cellIdentify";
    HospitalCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HospitalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        self.iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconView];
    }
    return _iconView;
}

- (UILabel *)lblTitle {
    if (_lblTitle == nil) {
        self.lblTitle = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblTitle];
    }
    return _lblTitle;
}

- (UILabel *)lblAddress {
    if (_lblAddress == nil) {
        self.lblAddress = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblAddress];
    }
    return _lblAddress;
}

- (UILabel *)lblLevel {
    if (_lblLevel == nil) {
        self.lblLevel = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblLevel];
    }
    return _lblLevel;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat w = self.frame.size.width;
//    CGFloat h = self.frame.size.height;

    self.iconView.frame = CGRectMake(10, 10, 60, 60);
    self.lblTitle.frame = CGRectMake(80, 10, w -80, 20);
    self.lblAddress.frame = CGRectMake(80, 35, w -80, 15);
    self.lblLevel.frame = CGRectMake(80, 30, w -80, 70); // ???高度怎么回事
}

- (void)setHos:(Hospital *)hos {
    _hos = hos;
    
    // 1.图片
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:hos.image] placeholderImage:[UIImage imageNamed:@"doctor_head_default"]];
    
    // 2.医院名称
    self.lblTitle.text = hos.short_name;
    
    // 3.医院地址
    self.lblAddress.text = hos.address;
    
    // 4.医院等级
    self.lblLevel.text = hos.level_str;
}

@end
