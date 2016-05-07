//
//  LSBrokerGrabOrderTableViewCell.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/1.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSBrokerGrabOrderTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "LSGrabOrder.h"

@interface LSBrokerGrabOrderTableViewCell ()

/** 医生头像 */
@property (weak, nonatomic) IBOutlet UIImageView *doctorHeadIamge;

/** 医生姓名 */
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;

/** 订单服务类型 */
@property (weak, nonatomic) IBOutlet UILabel *serviceTypeLabel;

/** 医生所属医院 */
@property (weak, nonatomic) IBOutlet UILabel *doctorHospitalLabel;



/** 预约时间 */
@property (weak, nonatomic) IBOutlet UILabel *appointTimeLabel;

/** 下单时间 */
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;

/** 抢单按钮 */
@property (weak, nonatomic) IBOutlet UIButton *grabBtn;

@end

@implementation LSBrokerGrabOrderTableViewCell

- (void)setGrabOrder:(LSGrabOrder *)grabOrder {
    _grabOrder = grabOrder;
    
    // 医生头像
    [self.doctorHeadIamge sd_setImageWithURL:_grabOrder.avator];
    // 医生姓名
    self.doctorNameLabel.text = _grabOrder.doctor_name;
    // 服务类型
    self.serviceTypeLabel.text = _grabOrder.order_type_str;
    self.doctorHospitalLabel.text = [NSString stringWithFormat:@"%@  %@",_grabOrder.hospital_name,_grabOrder.department_name];
    // 服务价格
    if ([_grabOrder.order_type isEqualToString:@"5"]) {
        CGFloat totalPrice = _grabOrder.attach.init_month_price * [_grabOrder.attach.month_number  floatValue];
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.0f",totalPrice];
    } else {
        
        self.priceLabel.text = [NSString stringWithFormat:@"￥%ld",_grabOrder.attach.init_service_price];
    }
    // 预约时间
    if ([_grabOrder.order_type isEqualToString:@"5"]) {
        
        self.appointTimeLabel.text = [NSString stringWithFormat:@"%@",_grabOrder.start_time];
    } else {
        
        self.appointTimeLabel.text = [NSString stringWithFormat:@"%@-%@",_grabOrder.start_time,_grabOrder.end_time];
    }

    
    // 几天前
    self.orderTimeLabel.text = _grabOrder.show_time;
    
    
}

#pragma mark - 抢单按钮监听
- (IBAction)btnClickedAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(grabOrderCell:didClickedGrabBtn:)]) {
        [self.delegate grabOrderCell:self didClickedGrabBtn:sender];
    }
}

- (void)awakeFromNib {
    // Initialization code
    // 还原图片被压缩的状态
    self.doctorHeadIamge.contentMode = UIViewContentModeScaleAspectFill;

    // 头像切圆角
    self.doctorHeadIamge.layer.masksToBounds = YES;
    self.doctorHeadIamge.layer.cornerRadius = self.doctorHeadIamge.frame.size.width / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
