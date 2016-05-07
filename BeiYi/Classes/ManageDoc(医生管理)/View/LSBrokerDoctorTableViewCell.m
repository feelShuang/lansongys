//
//  LSBrokerDoctorTableViewCell.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/1.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "LSBrokerDoctorTableViewCell.h"
#import "LSRecommendDoctor.h"
#import "LSBrokerDoctor.h"
#import <UIImageView+WebCache.h>
#import "Common.h"

@interface LSBrokerDoctorTableViewCell ()

// 医生头像
@property (weak, nonatomic) IBOutlet UIImageView *doctorHeadImage;
// 医生姓名
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
// 医生就诊人数
@property (weak, nonatomic) IBOutlet UILabel *doctorVisiNumLabel;
// 医生级别
@property (weak, nonatomic) IBOutlet UILabel *doctorLevelLabel;
// 医生所属医院
@property (weak, nonatomic) IBOutlet UILabel *doctorHospitalLabel;
// 赞图片
@property (weak, nonatomic) IBOutlet UIImageView *zan_one;
@property (weak, nonatomic) IBOutlet UIImageView *zan_two;
@property (weak, nonatomic) IBOutlet UIImageView *zan_three;
@property (weak, nonatomic) IBOutlet UIImageView *zan_four;
@property (weak, nonatomic) IBOutlet UIImageView *zan_five;

@end

@implementation LSBrokerDoctorTableViewCell

- (void)setRecommend_doctor:(LSRecommendDoctor *)recommend_doctor {
    
    _recommend_doctor = recommend_doctor;
    
    // 医生头像
    [self.doctorHeadImage sd_setImageWithURL:_recommend_doctor.avator];
    // 医生姓名
    self.doctorNameLabel.text = _recommend_doctor.name;
    /**  医生级别（1-医师2-主治医师3-副主任医师4-主任医师）*/
    self.doctorLevelLabel.text = [NSString stringWithFormat:@"[%@]",_recommend_doctor.level_str];
    // 医生所属医院
    self.doctorHospitalLabel.text = [NSString stringWithFormat:@"%@  %@",_recommend_doctor.short_name,_recommend_doctor.dept_name];
    // 医生就诊人数
    self.doctorVisiNumLabel.text = [NSString stringWithFormat:@"%@人就诊",_recommend_doctor.visit_count];
    // 赞分数
    // 1.先将所有图片设置为未选中状态
    for (int i = 1; i <= 5; i ++) {
        UIImageView *imgView = [self viewWithTag:i];
        imgView.image = [UIImage imageNamed:@"zan_mo_ren"];
    }
    // 2.根据个位数设置选中的图片
    NSInteger zanTag = [_recommend_doctor.avg_score integerValue];
    for (int i = 1; i <= zanTag; i ++) {
        UIImageView *imgView = [self viewWithTag:i];
        imgView.image = [UIImage imageNamed:@"zan_xuan_zhong"];
    }
    
    // 3. 根据小数位设置下一张图片
    CGFloat score = [_recommend_doctor.avg_score floatValue];
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
    if (score == 0 || [_recommend_doctor.avg_score isKindOfClass:[NSNull class]]) {
        for (int i = 1; i <= 5; i ++) {
            UIImageView *imgView = [self viewWithTag:i];
            imgView.image = [UIImage imageNamed:@"zan_xuan_zhong"];
        }
    }
}

- (void)setManage_doctor:(LSBrokerDoctor *)manage_doctor {
    
    _manage_doctor = manage_doctor;
    
    // 医生头像
    
    [self.doctorHeadImage sd_setImageWithURL:_manage_doctor.avator];
    // 医生姓名
    self.doctorNameLabel.text = _manage_doctor.name;
    /**  医生级别（1-医师2-主治医师3-副主任医师4-主任医师）*/
    NSString *levelStr = [[NSString alloc] init];
    switch ([_manage_doctor.level integerValue]) {
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
    self.doctorLevelLabel.text = [NSString stringWithFormat:@"[%@]",levelStr];
    // 医生所属医院
    self.doctorHospitalLabel.text = [NSString stringWithFormat:@"%@  %@",_manage_doctor.hospital_name,_manage_doctor.dept_name];
    // 医生就诊人数
    self.doctorVisiNumLabel.text = [NSString stringWithFormat:@"%@人就诊",_manage_doctor.visit_count];
    // 赞分数
    [self setPriseIamgeWithDoctor:_manage_doctor];
}

- (void)setBroker_doctor:(LSBrokerDoctor *)broker_doctor {
    
    _broker_doctor = broker_doctor;
    
    // 医生头像
    [self.doctorHeadImage sd_setImageWithURL:_broker_doctor.avator];
    // 医生姓名
    self.doctorNameLabel.text = _broker_doctor.name;
    /**  医生级别（1-医师2-主治医师3-副主任医师4-主任医师）*/
    NSString *levelStr = [[NSString alloc] init];
    switch ([_broker_doctor.level integerValue]) {
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
    self.doctorLevelLabel.text = [NSString stringWithFormat:@"[%@]",levelStr];
    // 医生所属医院
    self.doctorHospitalLabel.text = [NSString stringWithFormat:@"%@  %@",_broker_doctor.short_name,_broker_doctor.dept_name];
    // 医生就诊人数
    self.doctorVisiNumLabel.text = [NSString stringWithFormat:@"%@人就诊",_broker_doctor.visit_count];
    // 赞分数
    [self setPriseIamgeWithDoctor:_broker_doctor];
}

- (void)setPriseIamgeWithDoctor:(LSBrokerDoctor *)doctor {
    
    // 1.先将所有图片设置为未选中状态
    for (int i = 1; i <= 5; i ++) {
        UIImageView *imgView = [self viewWithTag:i];
        imgView.image = [UIImage imageNamed:@"zan_mo_ren"];
    }
    // 2.根据个位数设置选中的图片
    NSInteger zanTag = [doctor.avg_score integerValue];
    for (int i = 1; i <= zanTag; i ++) {
        UIImageView *imgView = [self viewWithTag:i];
        imgView.image = [UIImage imageNamed:@"zan_xuan_zhong"];
    }
    
    // 3. 根据小数位设置下一张图片
    CGFloat score = [doctor.avg_score floatValue];
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
    if (score == 0 || [doctor.avg_score isKindOfClass:[NSNull class]]) {
        for (int i = 1; i <= 5; i ++) {
            UIImageView *imgView = [self viewWithTag:i];
            imgView.image = [UIImage imageNamed:@"zan_xuan_zhong"];
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
    // 还原图片被压缩的状态
    self.doctorHeadImage.contentMode = UIViewContentModeScaleAspectFill;
    // 超出图片尺寸的范围不显示
//    self.doctorHeadImage.clipsToBounds = YES;
    // 图片切圆角
    self.doctorHeadImage.layer.cornerRadius = self.doctorHeadImage.height / 2;
    self.doctorHeadImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
