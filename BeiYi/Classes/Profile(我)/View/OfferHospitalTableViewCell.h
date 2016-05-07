//
//  OfferHospitalTableViewCell.h
//  BeiYi
//
//  Created by LiuShuang on 16/3/10.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Hospital;

@interface OfferHospitalTableViewCell : UITableViewCell

// 医院图片
@property (weak, nonatomic) IBOutlet UIImageView *hospitalImageView;

// 医院名称
@property (weak, nonatomic) IBOutlet UILabel *hospitalNameLabel;

// 医院地址
@property (weak, nonatomic) IBOutlet UILabel *hospitalAddressLabel;

// 医院级别
@property (weak, nonatomic) IBOutlet UILabel *hospitalLevelLabel;

// 医院服务价格
@property (weak, nonatomic) IBOutlet UILabel *hospitalSerPriceLabel;

@property (nonatomic, strong) Hospital *hospital;
@end
