//
//  LSBrokerDoctorTableViewCell.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/1.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSRecommendDoctor;
@class LSBrokerDoctor;

@interface LSBrokerDoctorTableViewCell : UITableViewCell

// 推荐医生模型
@property (nonatomic, strong) LSRecommendDoctor *recommend_doctor;
// 经纪人添加医生模型
@property (nonatomic, strong) LSBrokerDoctor *manage_doctor;
// 经纪人医生模型
@property (nonatomic, copy) LSBrokerDoctor *broker_doctor;

@end
