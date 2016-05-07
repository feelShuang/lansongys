//
//  CollectionHosTableViewCell.h
//  BeiYi
//
//  Created by 刘爽 on 16/2/23.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSCollectionHospital;
@class LSCollectionDoctor;

@interface CollectionHosTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *HospitalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLevelLabel;

@property (nonatomic, strong) LSCollectionDoctor *doctor;

@property (nonatomic, strong) LSCollectionHospital *hospital;

@end
