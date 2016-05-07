//
//  LSFamousDoctorTableViewCell.m
//  BeiYi
//
//  Created by LiuShuang on 16/3/21.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "LSFamousDoctorTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "LSPatientDoctor.h"

@interface LSFamousDoctorTableViewCell ()

// 医生头像
@property (weak, nonatomic) IBOutlet UIImageView *docHeadImage;
// 医生姓名
@property (weak, nonatomic) IBOutlet UILabel *docNameLabel;
// 医生级别
@property (weak, nonatomic) IBOutlet UILabel *docLevelLabel;
// 医生的就诊人数
@property (weak, nonatomic) IBOutlet UILabel *docVisitNumLabel;
// 医生所属医院
@property (weak, nonatomic) IBOutlet UILabel *docHospitalLabel;
/**
 *  赞没有写
 */

// 医生擅长
@property (weak, nonatomic) IBOutlet UILabel *docGoodAtLabel;

@end

@implementation LSFamousDoctorTableViewCell

- (void)setDoctor:(LSPatientDoctor *)doctor {
    
    _doctor = doctor;
    
    // 医生头像
    [self.docHeadImage sd_setImageWithURL:_doctor.avator placeholderImage:[UIImage imageNamed:@"personal_tou_xiang"]];
    // 医生姓名
    self.docNameLabel.text = _doctor.name;
    // 医生级别
    NSString *levelStr = [[NSString alloc] init];
    switch ([doctor.level integerValue]) {
        case 1:
            levelStr = @"医师";
            break;
        case 2:
            levelStr = @"主治医师";
            break;
        case 3:
            levelStr = @"副主任医师";
            break;
        case 4:
            levelStr = @"主任医师";
            break;
    }
    self.docLevelLabel.text = levelStr;
    // 医生就诊的人数
    self.docVisitNumLabel.text = [NSString stringWithFormat:@"%@人就诊",_doctor.visit_count];
    
    // 医生所属医院
    self.docHospitalLabel.text = [NSString stringWithFormat:@"%@  %@",_doctor.hospital_name,doctor.dept_name];
    
    // 医生评分
    // 1.先将所有图片设置为未选中状态
    for (int i = 1; i <= 5; i ++) {
        UIImageView *imgView = [self viewWithTag:i];
        imgView.image = [UIImage imageNamed:@"zan_mo_ren"];
    }
    // 2.根据个位数设置选中的图片
    NSInteger zanTag = [_doctor.avg_score integerValue];
    for (int i = 1; i <= zanTag; i ++) {
        UIImageView *imgView = [self viewWithTag:i];
        imgView.image = [UIImage imageNamed:@"zan_xuan_zhong"];
    }
    
    // 3. 根据小数位设置下一张图片
    CGFloat score = [_doctor.avg_score floatValue];
    NSInteger score_point = [[[NSString stringWithFormat:@"%.1f",score] substringFromIndex:2] integerValue];
    
    if (score_point > 0) {
        UIImageView *imageV = [self viewWithTag:zanTag + 1];
        if (score_point <= 5) {
            imageV.image = [UIImage imageNamed:@"zan_banxin"];
        }
        if (score_point > 5) {
            imageV.image = [UIImage imageNamed:@"zan_xuan_zhong"];
        }
    }
    // 4.如果医生的分数是0或者没有值 默认满分……
    if (score == 0 || [_doctor.avg_score isKindOfClass:[NSNull class]]) {
        for (int i = 1; i <= 5; i ++) {
            UIImageView *imgView = [self viewWithTag:i];
            imgView.image = [UIImage imageNamed:@"zan_xuan_zhong"];
        }
    }
    
    // 医生擅长
    self.docGoodAtLabel.text = _doctor.good_at;
}

- (void)awakeFromNib {
    // Initialization code
    // 还原图片被压缩的状态
    self.docHeadImage.contentMode = UIViewContentModeScaleAspectFill;
    
    self.docHeadImage.layer.cornerRadius = self.docHeadImage.frame.size.height / 2;
    self.docHeadImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
