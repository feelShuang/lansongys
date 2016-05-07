//
//  OfferHospitalTableViewCell.m
//  BeiYi
//
//  Created by LiuShuang on 16/3/10.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "OfferHospitalTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "Hospital.h"

@implementation OfferHospitalTableViewCell

- (void)setHospital:(Hospital *)hospital {
    
    // iamge
    [self.hospitalImageView sd_setImageWithURL:[NSURL URLWithString:hospital.image] placeholderImage:[UIImage imageNamed:@"hos_list_default"]];
    // name
    self.hospitalNameLabel.text = hospital.short_name;
    // address
    self.hospitalAddressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",hospital.province_name,hospital.city_name,hospital.county_name,hospital.address];
    // level
    self.hospitalLevelLabel.text = hospital.level_str;
    // price
    self.hospitalSerPriceLabel.text = [NSString stringWithFormat:@"￥%@.00",hospital.price];
}

- (void)awakeFromNib {
    // Initialization code
    
    self.hospitalImageView.layer.masksToBounds = YES;
    self.hospitalImageView.layer.cornerRadius = _hospitalImageView.frame.size.height / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
