//
//  LSPatientCertificateViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/15.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSPatientCertificateViewController.h"
#import "LSPatientOrderDetail.h"
#import "Common.h"

@interface LSPatientCertificateViewController ()


/** 患者姓名 */
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
/** 患者性别 */
@property (weak, nonatomic) IBOutlet UILabel *patientSexLabel;
/** 医生姓名 */
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
/** 就诊时间 */
@property (weak, nonatomic) IBOutlet UILabel *visitTimeLabel;
/** 就诊医院 */
@property (weak, nonatomic) IBOutlet UILabel *hospitalNameLabel;
/** 就诊科室 */
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;

// 确认凭证标识
@property (nonatomic, assign) NSInteger result_flag;

@end

@implementation LSPatientCertificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置基本属性
    self.title = @"查看凭证";
    
    // 设置证书数据
    [self setCertificateData];
}

#pragma mark - 设置证书数据
- (void)setCertificateData {
    
    // 病人姓名
    self.patientNameLabel.text = _patientOrderDetail.human.name;
    // 病人性别
    if ([_patientOrderDetail.human.sex isEqualToString:@"1"]) {
        
        self.patientSexLabel.text = @"性别：男";
    } else {
        
        self.patientSexLabel.text = @"性别：女";
    }
    // 医生姓名
    self.doctorNameLabel.text = [NSString stringWithFormat:@"医生：%@",_patientOrderDetail.doctor_name];
    // 就诊医院
    self.hospitalNameLabel.text = [NSString stringWithFormat:@"就诊医院：%@",_patientOrderDetail.hospital_name];
    // 就诊科室
    self.departmentLabel.text = [NSString stringWithFormat:@"就诊科室：%@",_patientOrderDetail.department_name];
    // 就诊时间
    NSString *visitimeStr = _patientOrderDetail.over_over.visit_start;
    self.visitTimeLabel.text = [NSString stringWithFormat:@"时间：%@",[visitimeStr substringToIndex:10]];
}

@end
