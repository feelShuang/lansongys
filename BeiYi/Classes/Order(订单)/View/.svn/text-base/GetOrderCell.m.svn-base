//
//  GetOrderCell.m
//  BeiYi
//
//  Created by Joe on 15/5/28.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "GetOrderCell.h"
#import "GetOrder.h"
#import "Common.h"

@interface GetOrderCell()
/** UIImageView 小图标 */
@property (strong, nonatomic) UIImageView *icon;

/** UILabel 医院名称、科室名称 */
@property (strong, nonatomic) UILabel *lblHosName;

/** UILabel 医生名称 */
@property (strong, nonatomic) UILabel *lblDoctorName;

/** UILabel 服务类型 */
@property (strong, nonatomic) UILabel *lblType;

/** UILabel 服务类型Text */
@property (strong, nonatomic) UILabel *lblTypeText;

/** UILabel 就诊时间 */
@property (strong, nonatomic) UILabel *lblTime;

/** UILabel 价格 */
@property (strong, nonatomic) UILabel *lblPrice;

/** UILabel 价格Text */
@property (strong, nonatomic) UILabel *lblPriceText;

/** UIButton 抢单按钮 */
@property (strong, nonatomic) UIButton *btnGrab;

/** UIImageView 被抢提示图标 */
@property (strong, nonatomic) UIImageView *imgTips;

@end

@implementation GetOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 0.小图标
        self.icon.image = [UIImage imageNamed:@"grab_icon01"];
        
        // 1.医院、科室名称
        self.lblHosName.font = [UIFont systemFontOfSize:15];
        self.lblHosName.textColor = ZZColor(51, 51, 51, 1);
        
        // 2.医生名称
        self.lblDoctorName.font = [UIFont systemFontOfSize:12.5];
        self.lblDoctorName.textColor = ZZColor(51, 51, 51, 1);

        // 3.服务类型
        self.lblType.font = [UIFont systemFontOfSize:12.5];
        self.lblType.textColor = ZZColor(51, 51, 51, 1);
        self.lblType.textAlignment = NSTextAlignmentRight;

        // 4.服务类型Text
        self.lblTypeText.font = [UIFont systemFontOfSize:12.5];
        self.lblTypeText.textColor = ZZBaseColor;
        self.lblTypeText.textAlignment = NSTextAlignmentRight;
        
        // 5.就诊时间
        self.lblTime.font = [UIFont systemFontOfSize:11];
        self.lblTime.textColor = ZZColor(153, 153, 153, 1);
        
        // 6.价格
        self.lblPrice.font = [UIFont systemFontOfSize:11];
        self.lblPrice.textColor = ZZColor(252, 106, 69, 1);
        self.lblPrice.textAlignment = NSTextAlignmentRight;

        // 7.价格Text
        self.lblPriceText.font = [UIFont systemFontOfSize:15];
        self.lblPriceText.textColor = ZZColor(252, 106, 69, 1);
        self.lblPriceText.textAlignment = NSTextAlignmentRight;

        // 8.抢单按钮
        [self.btnGrab setBackgroundImage:[UIImage imageNamed:@"grab_buttom"] forState:UIControlStateNormal];
        [self.btnGrab setBackgroundImage:[UIImage imageNamed:@"grab_buttom_clicked"] forState:UIControlStateHighlighted];
        [self.btnGrab setBackgroundImage:[UIImage imageNamed:@"grab_buttom_grabed"] forState:UIControlStateSelected];
        [self.btnGrab addTarget:self action:@selector(btnGrabClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // 9.被抢提示图标
        self.imgTips.hidden = YES;
        self.imgTips.image = [UIImage imageNamed:@"grab_tips"];
    }
    return self;
}

#pragma mark  - 抢单按钮监听
- (void)btnGrabClicked:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(getOrderCell:didClickedBtnGrab:)]) {
        [self.delegate getOrderCell:self didClickedBtnGrab:btn];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cellIdentify";
    GetOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[GetOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (UIImageView *)icon {
    if (_icon == nil) {
        self.icon = [[UIImageView alloc] init];
        [self addSubview:self.icon];
    }
    return _icon;
}

- (UILabel *)lblHosName {
    if (_lblHosName == nil) {
        self.lblHosName = [[UILabel alloc] init];
        [self addSubview:self.lblHosName];
    }
    return _lblHosName;
}

- (UILabel *)lblType {
    if (_lblType == nil) {
        self.lblType = [[UILabel alloc] init];
        [self addSubview:self.lblType];
    }
    return _lblType;
}

- (UILabel *)lblTypeText {
    if (_lblTypeText == nil) {
        self.lblTypeText = [[UILabel alloc] init];
        [self addSubview:self.lblTypeText];
    }
    return _lblTypeText;
}

- (UILabel *)lblTime {
    if (_lblTime == nil) {
        self.lblTime = [[UILabel alloc] init];
        [self addSubview:self.lblTime];
    }
    return _lblTime;
}

- (UILabel *)lblDoctorName {
    if (_lblDoctorName == nil) {
        self.lblDoctorName = [[UILabel alloc] init];
        [self addSubview:self.lblDoctorName];
    }
    return _lblDoctorName;
}

- (UILabel *)lblPrice {
    if (_lblPrice == nil) {
        self.lblPrice = [[UILabel alloc] init];
        [self addSubview:self.lblPrice];
    }
    return _lblPrice;
}

- (UILabel *)lblPriceText {
    if (_lblPriceText == nil) {
        self.lblPriceText = [[UILabel alloc] init];
        [self addSubview:self.lblPriceText];
    }
    return _lblPriceText;
}

- (UIButton *)btnGrab {
    if (_btnGrab == nil) {
        self.btnGrab = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.btnGrab];
    }
    return _btnGrab;
}

- (UIImageView *)imgTips {
    if (_imgTips == nil) {
        self.imgTips = [[UIImageView alloc] init];
        [self addSubview:self.imgTips];
    }
    return _imgTips;
}

#pragma mark - cell布局
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.contentView.frame.size.width;
    CGFloat h = self.contentView.frame.size.height;
    
    CGFloat margin = 10;
    // 0.小图标
    self.icon.frame = CGRectMake(margin, margin, 20, 20);
    
    // 1.医院、科室名称
    CGSize hosSize = [self sizeWithText:self.lblHosName.text maxSize:CGSizeMake(CGFLOAT_MAX, 25) font:[UIFont systemFontOfSize:15]];
    self.lblHosName.frame = CGRectMake(CGRectGetMaxX(self.icon.frame)+5, margin,  hosSize.width, hosSize.height);
    
    // 2.医生名称
    CGSize doctorSize = [self sizeWithText:self.lblDoctorName.text maxSize:CGSizeMake(CGFLOAT_MAX, 15) font:[UIFont systemFontOfSize:12.5]];
    self.lblDoctorName.frame = CGRectMake(CGRectGetMaxX(self.icon.frame)+5, CGRectGetMaxY(self.lblHosName.frame)+10, doctorSize.width, doctorSize.height);
    
    // 3.服务类型
    CGSize typeSize = [self sizeWithText:self.lblType.text maxSize:CGSizeMake(CGFLOAT_MAX, 15) font:[UIFont systemFontOfSize:12.5]];
    self.lblType.frame = CGRectMake(CGRectGetMaxX(self.lblDoctorName.frame) +2*ZZMarins, CGRectGetMaxY(self.lblHosName.frame)+10, typeSize.width, typeSize.height);
    
    // 4.服务类型Text
    CGSize typeTextSize = [self sizeWithText:self.lblTypeText.text maxSize:CGSizeMake(CGFLOAT_MAX, 15) font:[UIFont systemFontOfSize:12.5]];
    self.lblTypeText.frame = CGRectMake(CGRectGetMaxX(self.lblType.frame), CGRectGetMaxY(self.lblHosName.frame)+10, typeTextSize.width, typeTextSize.height);
    
    // 5.就诊时间
    self.lblTime.frame = CGRectMake(CGRectGetMaxX(self.icon.frame)+5, CGRectGetMaxY(self.lblType.frame)+10, w*0.6, 10);
    
    // 6.价格Text
    CGSize priceTextSize = [self sizeWithText:self.lblPriceText.text maxSize:CGSizeMake(CGFLOAT_MAX, 25) font:[UIFont systemFontOfSize:15]];
    self.lblPriceText.frame = CGRectMake(w-10-priceTextSize.width, margin, priceTextSize.width, priceTextSize.height);
    
    // 7.价格
    CGSize priceSize = [self sizeWithText:self.lblPrice.text maxSize:CGSizeMake(CGFLOAT_MAX, 15) font:[UIFont systemFontOfSize:11]];
    self.lblPrice.frame = CGRectMake(CGRectGetMinX(self.lblPriceText.frame) - priceSize.width, CGRectGetMaxY(self.lblPriceText.frame) - 14, priceSize.width, priceSize.height);
    
    
    self.btnGrab.frame = CGRectMake(w-10-40, h -50, 40, 40);
    
    self.imgTips.frame = CGRectMake(w-65, h -54, 60, 40);
}

- (void)setGetOrder:(GetOrder *)getOrder {
    _getOrder = getOrder;
    
    // 1.医院、科室名称(当order_type = 床位安排时，显示科室名称)
    self.lblHosName.text = [NSString stringWithFormat:@"%@ [%@]",getOrder.hospital_name,getOrder.department_name];
    
    // 2.医生名称(当order_type = 床位安排时，显示科室名称)
    self.lblDoctorName.text = [NSString stringWithFormat:@"医生: %@",getOrder.doctor_name];
    
    // 3.服务类型
    self.lblType.text = @"类型：";

    // 4.服务类型
    self.lblTypeText.text = [NSString stringWithFormat:@"%@",getOrder.order_type_str];

    // 4.就诊时间
    if (getOrder.end_time.length == 0) {
        self.lblTime.text = [NSString stringWithFormat:@"就诊时间 : %@",getOrder.start_time];
    }
    else {
        self.lblTime.text = [NSString stringWithFormat:@"就诊时间 : %@ ~ %@",getOrder.start_time,getOrder.end_time];
    }
    
    // 5.是否可以抢单
    if (getOrder.grab_flag) {// grab_flag = 1(未抢)
        self.btnGrab.selected = YES;
        self.imgTips.hidden = NO;// 订单被抢走则显示被抢图标

    } else {
        self.btnGrab.selected = NO;
        self.imgTips.hidden = YES;// 订单被抢走则显示被抢图标

    }

}

/** 根据文本内容计算size*/
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font {

    return [text boundingRectWithSize:maxSize  options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil].size;;
}

@end
