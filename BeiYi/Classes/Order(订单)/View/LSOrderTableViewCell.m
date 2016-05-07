//
//  LSOrderTableViewCell.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/1.
//  Copyright © 2016年 Joe. All rights reserved.
//

#define IMAGE_CORNERRADIUS 22

#import "LSOrderTableViewCell.h"
#import "LSBrokerOrder.h"
#import "LSPatientOrder.h"
#import <UIImageView+WebCache.h>
#import "Common.h"

@interface LSOrderTableViewCell ()

/** Cell背景 */
@property (weak, nonatomic) IBOutlet UIView *cellBgView;

/** 医生头像 */
@property (weak, nonatomic) IBOutlet UIImageView *doctorHeaderImage;

/** 医生名字 */
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;

/** 医生级别 */
@property (weak, nonatomic) IBOutlet UILabel *doctorLevelLabel;

/** 医院名字 */
@property (weak, nonatomic) IBOutlet UILabel *doctorHospitalNameLabel;

/** 订单类型 */
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;

/** 预约专家优质服务标志 */
@property (weak, nonatomic) IBOutlet UILabel *appointGoodServiceLabel;

/** 预约时间 */
@property (weak, nonatomic) IBOutlet UILabel *appointmentTimeLabel;

/** 服务金额 */
@property (weak, nonatomic) IBOutlet UILabel *servicePriceLabel;

/** 订单状态 */
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;

/** 订单状态提示 */
@property (weak, nonatomic) IBOutlet UILabel *orderStatuesTipLabel;

/** 下单时间 */
@property (weak, nonatomic) IBOutlet UILabel *makeOrderTimeLabel;

@end

@implementation LSOrderTableViewCell

- (void)setPatientOrder:(LSPatientOrder *)patientOrder {
    
    _patientOrder = patientOrder;
    
    self.appointGoodServiceLabel.hidden = YES;
    if ([_patientOrder.order_type_show isEqualToString:@"预约专家"] && [_patientOrder.service_attach isEqualToString:@"优质门诊服务"]) {
        self.appointGoodServiceLabel.hidden = NO;
    }
    
    self.doctorHeaderImage.backgroundColor = [UIColor whiteColor];
    // cell背景
    if ([_patientOrder.read_flag isEqualToString:@"1"]) {
        self.cellBgView.backgroundColor = [UIColor colorWithHexString:@"#ecfffe"];
        self.doctorNameLabel.backgroundColor = [UIColor colorWithHexString:@"#ecfffe"];
        self.doctorLevelLabel.backgroundColor = [UIColor colorWithHexString:@"#ecfffe"];
        self.doctorHospitalNameLabel.backgroundColor = [UIColor colorWithHexString:@"#ecfffe"];
        self.orderTypeLabel.backgroundColor = [UIColor colorWithHexString:@"#ecfffe"];
        self.appointmentTimeLabel.backgroundColor = [UIColor colorWithHexString:@"#ecfffe"];
        self.servicePriceLabel.backgroundColor = [UIColor colorWithHexString:@"#ecfffe"];
        self.orderStateLabel.backgroundColor = [UIColor colorWithHexString:@"#ecfffe"];
        self.makeOrderTimeLabel.backgroundColor = [UIColor colorWithHexString:@"@ecfffe"];

    } else {
        self.cellBgView.backgroundColor = [UIColor whiteColor];
        self.doctorNameLabel.backgroundColor = [UIColor whiteColor];
        self.doctorLevelLabel.backgroundColor = [UIColor whiteColor];
        self.doctorHospitalNameLabel.backgroundColor = [UIColor whiteColor];
        self.orderTypeLabel.backgroundColor = [UIColor whiteColor];
        self.appointmentTimeLabel.backgroundColor = [UIColor whiteColor];
        self.servicePriceLabel.backgroundColor = [UIColor whiteColor];
        self.orderStateLabel.backgroundColor = [UIColor whiteColor];
        self.makeOrderTimeLabel.backgroundColor = [UIColor whiteColor];
    }
    // 医生头像
    [self.doctorHeaderImage sd_setImageWithURL:_patientOrder.doctor_avator];
    // 医生姓名
    self.doctorNameLabel.text = _patientOrder.doctor_name;
    // 医生级别
    self.doctorLevelLabel.text = _patientOrder.doctor_level;
    // 医院名称
    self.doctorHospitalNameLabel.text = [NSString stringWithFormat:@"%@  %@",_patientOrder.hospital_name,_patientOrder.department_name];
    // 订单类型
    self.orderTypeLabel.text = _patientOrder.order_type_show;
    // 预约时间
    self.appointmentTimeLabel.text = _patientOrder.visit_time;
    // 服务金额
    self.servicePriceLabel.text = [NSString stringWithFormat:@"￥%@",_patientOrder.price];
    // 订单状态
    self.orderStateLabel.text = _patientOrder.order_status_show;
    // 订单状态提示语
    if ([_patientOrder.order_status isEqualToString:@"1"]) {
        
        self.orderStatuesTipLabel.text = @"（平台还未接单，请耐心等待）";
    } else if ([_patientOrder.order_status isEqualToString:@"2"]) {  // 待付款
        
        self.orderStatuesTipLabel.text = @"（30分钟未支付，订单将自动取消！）";
    } else if ([_patientOrder.order_status isEqualToString:@"3"]) { // 待出号
        
        self.orderStatuesTipLabel.text = @"（正在确认医疗资源，请耐心等待）";
    } else if ([_patientOrder.order_status isEqualToString:@"5"]) { // 待确认
        
//        NSString *visitTime = [_patientOrder.over_over.visit_start substringToIndex:10];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd"];
//        NSDate *curDate = [NSDate date];
//        NSString *curTime = [formatter stringFromDate:curDate];
//        ;
//        // NSOrderedAscending    左边 < 右边  == -1
//        // NSOrderedSame         内容相同     ==  0
//        // NSOrderedDescending   左边 > 右边  ==  1
//        ZZLog(@"%@,%@",curTime,visitTime);
//        if ([curTime compare:visitTime] == 1) {
//            ;
//            self.orderStatuesTipLabel.text = @"（24小时未确认，系统将自动确认）";
//        } else {
            self.orderStatuesTipLabel.text = @"（平台已出号）";
//        }
    } else if ([_patientOrder.order_status isEqualToString:@"6"]) { // 待评价
        
        self.orderStatuesTipLabel.text = @"（服务已完成，请对本次服务进行评价）";
    } else  { // 服务完成后的状态显示
        
        self.orderStatuesTipLabel.text = @"（服务已完成）";
    }
    // 下单时间
    NSString *timeStr = [_patientOrder.order_time_show substringWithRange:NSMakeRange(11, 5)];
    
    self.makeOrderTimeLabel.text = timeStr;
}

- (void)setBrokerOrder:(LSBrokerOrder *)brokerOrder {
    
    _brokerOrder = brokerOrder;
    
    // 医生头像
    [self.doctorHeaderImage sd_setImageWithURL:_brokerOrder.doctor_avator];
    // 医生姓名
    self.doctorNameLabel.text = _brokerOrder.doctor_name;
    // 医生级别
    self.doctorLevelLabel.text = _brokerOrder.doctor_level;
    // 医院名称
    self.doctorHospitalNameLabel.text = [NSString stringWithFormat:@"%@  %@",_brokerOrder.hospital_name,_brokerOrder.department_name];
    // 订单类型
    self.orderTypeLabel.text = _brokerOrder.order_type_show;
    // 预约时间
    self.appointmentTimeLabel.text = _brokerOrder.visit_time;
    // 服务金额
    self.servicePriceLabel.text = [NSString stringWithFormat:@"￥%@",_brokerOrder.price];
    // 订单状态
    self.orderStateLabel.text = _brokerOrder.order_status_show;
    
    // 订单状态提示语
    if ([_brokerOrder.order_status isEqualToString:@"1"]) { // 未确定接单
        self.orderStatuesTipLabel.text = @"（30分钟未确认，订单将自动释放！）";
    }else if ([_brokerOrder.order_status isEqualToString:@"2"]) {
        // 已接单
        self.orderStatuesTipLabel.text = @"（患者还未付款，请耐心等待）";
    } else if ([_brokerOrder.order_status isEqualToString:@"3"]) {
        // 待出号
        self.orderStatuesTipLabel.text = @"（请及时提交就诊信息！）";
    } else if ([_brokerOrder.order_status isEqualToString:@"5"]) {
        // 已出号
        self.orderStatuesTipLabel.text = @"（服务进行中，请等待患者确认）";
    } else if ([_brokerOrder.order_status isEqualToString:@"6"]) {
        // 服务已确认
        self.orderStatuesTipLabel.text = @"（患者已确认）";
    } else {
        
        self.orderStatuesTipLabel.text = @"（服务已完成）";
    }
    
    // 下单时间的Label进行隐藏
    self.makeOrderTimeLabel.hidden = YES;
}

- (void)awakeFromNib {
    // Initialization code
    // 还原图片被压缩的状态
    self.doctorHeaderImage.contentMode = UIViewContentModeScaleAspectFill;

    self.doctorHeaderImage.layer.cornerRadius = IMAGE_CORNERRADIUS;
    self.doctorHeaderImage.layer.masksToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
