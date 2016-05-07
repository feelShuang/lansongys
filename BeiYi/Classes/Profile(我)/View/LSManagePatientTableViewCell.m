//
//  LSManagePatientTableViewCell.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/7.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSManagePatientTableViewCell.h"
#import "LSPatient.h"
#import <UIImageView+WebCache.h>

@interface LSManagePatientTableViewCell ()

/** 患者姓名 */
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
/** 患者性别 */
@property (weak, nonatomic) IBOutlet UIImageView *patientSexImageView;
/** 患者联系电话 */
@property (weak, nonatomic) IBOutlet UILabel *patientMobileLabel;

@end

@implementation LSManagePatientTableViewCell

- (void)setPatient:(LSPatient *)patient {
    
    _patient = patient;
    
    // 患者姓名
    self.patientNameLabel.text = _patient.name;
    // 患者性别
    if ([_patient.sex isEqualToString:@"1"]) {// 男性
        self.patientSexImageView.image = [UIImage imageNamed:@"iocn_nan"];
    } else {
        self.patientSexImageView.image = [UIImage imageNamed:@"iocn_nv"];
    }
    // 患者联系电话
    self.patientMobileLabel.text = _patient.mobile;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
