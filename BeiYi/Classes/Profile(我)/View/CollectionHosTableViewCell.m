//
//  CollectionHosTableViewCell.m
//  BeiYi
//
//  Created by 刘爽 on 16/2/23.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "CollectionHosTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "LSCollectionDoctor.h"
#import "LSCollectionHospital.h"


@implementation CollectionHosTableViewCell

- (void)setHospital:(LSCollectionHospital *)hospital {
    
    _hospital = hospital;
    
    [self.avatorImageView sd_setImageWithURL:_hospital.imageStr placeholderImage:[UIImage imageNamed:@"hos_list_default"]];
    self.HospitalNameLabel.text = _hospital.short_name;
    self.addressNameLabel.text = [NSString stringWithFormat:@"%@%@%@%@",_hospital.province_name,_hospital.city_name,_hospital.county_name,_hospital.address];
    self.hospitalLevelLabel.text = _hospital.level_str;
}

- (void)setDoctor:(LSCollectionDoctor *)doctor {
    
    _doctor = doctor;
    
    [self.avatorImageView sd_setImageWithURL:_doctor.avator placeholderImage:[UIImage imageNamed:@"hos_list_default"]];
    self.HospitalNameLabel.text = [NSString stringWithFormat:@"%@[%@]",_doctor.name,_doctor.level_str];
    self.addressNameLabel.text = [NSString stringWithFormat:@"%@  |  [%@]",_doctor.hospital_name,_doctor.department_name];
    self.hospitalLevelLabel.text = _doctor.good_at;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
