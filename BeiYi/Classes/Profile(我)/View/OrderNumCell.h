//
//  OrderNumCell.h
//  BeiYi
//
//  Created by Joe on 15/7/23.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderNumCell : UITableViewCell

@property (nonatomic, strong) UILabel *lblOrderNum;
@property (nonatomic, strong) UILabel *lblPrice;
@property (nonatomic, strong) UILabel *lblPriceDetail;

+(instancetype)cellWithTableView:(UITableView *)tableVeiw;

@end
