//
//  DeptsCell.m
//  BeiYi
//
//  Created by Joe on 15/9/11.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "DeptsCell.h"
#import "Common.h"
#import "ManageDepts.h"

@interface DeptsCell()
/**
 *  UILabel-医院
 */
@property (nonatomic, strong) UILabel *lblHospital;
/**
 *  UILabel-科室/子科室
 */
@property (nonatomic, strong) UILabel *lblDepts;
/**
 *  UILabel-价格
 */
@property (nonatomic, strong) UILabel *lblPrice;
@end

@implementation DeptsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.lblHospital.font = [UIFont systemFontOfSize:15];
        self.lblHospital.textColor = [UIColor blackColor];
        
        self.lblDepts.font = [UIFont systemFontOfSize:13];
        self.lblDepts.textColor = [UIColor blackColor];
        
        self.lblPrice.font = [UIFont systemFontOfSize:16];
        self.lblPrice.textColor = ZZButtonClickedColor;
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"DeptsCell";
    DeptsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[DeptsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (UILabel *)lblHospital {
    if (_lblHospital == nil) {
        self.lblHospital = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblHospital];
    }
    return _lblHospital;
}

- (UILabel *)lblDepts {
    if (_lblDepts == nil) {
        self.lblDepts = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblDepts];

    }
    return _lblDepts;
}

- (UILabel *)lblPrice {
    if (_lblPrice == nil) {
        self.lblPrice = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblPrice];

    }
    return _lblPrice;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = self.contentView.frame.size.width;
    CGFloat h = self.contentView.frame.size.height;
    
    
    CGFloat lblHosX = 10;
    CGFloat lblHosY = 8;
    CGSize  hosSize = [self sizeWithText:self.lblHospital.text maxSize:CGSizeMake(CGFLOAT_MAX, 20) font:[UIFont systemFontOfSize:15]];
    self.lblHospital.frame = CGRectMake(lblHosX, lblHosY, hosSize.width, hosSize.height);
    
    
    CGFloat lblDeptX = lblHosX;
    CGFloat lblDeptY = 8 +20 +5;
    CGSize deptSize = [self sizeWithText:self.lblDepts.text maxSize:CGSizeMake(CGFLOAT_MAX, 15) font:[UIFont systemFontOfSize:13]];
    self.lblDepts.frame = CGRectMake(lblDeptX, lblDeptY, deptSize.width, deptSize.height);
    


    CGSize  priceSize = [self sizeWithText:self.lblPrice.text maxSize:CGSizeMake(CGFLOAT_MAX, 20) font:[UIFont systemFontOfSize:16]];
    CGFloat lblPriceX = w -10 -priceSize.width;
    CGFloat lblPriceY = (h -priceSize.height)/2;
    self.lblPrice.frame = CGRectMake(lblPriceX, lblPriceY, priceSize.width, priceSize.height);
}

- (void)setDepts:(ManageDepts *)depts {
    _depts = depts;
    
    self.lblHospital.text = depts.hospital_name;
    self.lblDepts.text = [NSString stringWithFormat:@"%@ | %@",depts.parent_name,depts.dept_name];
    self.lblPrice.text = [NSString stringWithFormat:@"￥%.2f",[depts.price floatValue]];
}

/** 根据文本内容计算size*/
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font {
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
}

@end
