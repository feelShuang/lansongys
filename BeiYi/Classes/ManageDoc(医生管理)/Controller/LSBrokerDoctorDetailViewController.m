//
//  LSBrokerDoctorDetailViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/11.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSBrokerDoctorDetailViewController.h"
#import "LSBrokerSelectDoctorViewController.h"
#import "LSBrokerDoctor.h"
#import "LSServicePrice.h"
#import "SettingDocPriceVc.h"
#import <UIImageView+WebCache.h>
#import "Common.h"

@interface LSBrokerDoctorDetailViewController ()

/** contentView 高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightLayout;

/*----------------------医生详情------------------------*/
/** 医生头像 */
@property (weak, nonatomic) IBOutlet UIImageView *doctorHeaderImageView;
/** 医生姓名 */
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
/** 医生级别 */
@property (weak, nonatomic) IBOutlet UILabel *doctorLeaveLabel;
/** 医生所属医院 */
@property (weak, nonatomic) IBOutlet UILabel *doctorHospitalLabel;
/** 医生就诊人数 */
@property (weak, nonatomic) IBOutlet UILabel *doctorVisitCountLabel;
/** 医生擅长 */
@property (weak, nonatomic) IBOutlet UILabel *doctorGootAtLabel;
/** 医生擅长高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doctorGoodAtViewHeight;
/** 医生介绍 */
@property (weak, nonatomic) IBOutlet UILabel *doctorIntroduceLabel;
/** 医生介绍高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doctorIntroduceViewHeight;

/*----------------------预约专家------------------------*/
/** 服务背景高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serviceBgHeightLayout;
/** 服务背景 */
@property (weak, nonatomic) IBOutlet UIView *serviceBgView;
/** 预约专家服务背景 */
@property (weak, nonatomic) IBOutlet UIView *appointBgView;
/** 预约专家服务背景高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appointHeightLayout;
/** 预约专家基本价格 */
@property (weak, nonatomic) IBOutlet UILabel *appointPriceLabel;
/** 预约专家优质服务 */
@property (weak, nonatomic) IBOutlet UILabel *goodServicePriceLabel;
/** 预约专家button */
@property (weak, nonatomic) IBOutlet UIButton *appointButton;
/** 预约专家开通提示 */
@property (weak, nonatomic) IBOutlet UILabel *appointTipLabel;


/*----------------------名医主刀------------------------*/
/** 名医主刀背景 */
@property (weak, nonatomic) IBOutlet UIView *operationBgView;
/** 名医主刀高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationHeightLayout;
/** 名医主刀基本价格 */
@property (weak, nonatomic) IBOutlet UILabel *operationPriceLabel;
/** 名医主刀开通按钮 */
@property (weak, nonatomic) IBOutlet UIButton *operationButton;
/** 名医主刀开通提示 */
@property (weak, nonatomic) IBOutlet UILabel *operationTipLabel;


/*----------------------会诊服务------------------------*/
/** 会诊服务背景 */
@property (weak, nonatomic) IBOutlet UIView *consultationBgView;
/** 会诊服务高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consulationHeightLayout;
/** 会诊服务价格 */
@property (weak, nonatomic) IBOutlet UILabel *consulationPriceLabel;
/** 会诊服务开通按钮 */
@property (weak, nonatomic) IBOutlet UIButton *consulationButton;
/** 会诊服务开通提示 */
@property (weak, nonatomic) IBOutlet UILabel *consulationTipLabel;


/*----------------------病情分析------------------------*/
/** 病情分析服务背景 */
@property (weak, nonatomic) IBOutlet UIView *illnessAnalyzeBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *illnessAnalyzeHeightLayout;
@property (weak, nonatomic) IBOutlet UILabel *illnessAnalyzePriceLabel;
/** 病情分析开通按钮 */
@property (weak, nonatomic) IBOutlet UIButton *illnessAnalyzeButton;
/** 病情分析开通提示 */
@property (weak, nonatomic) IBOutlet UILabel *illnessAnalyzeTipLabel;


/*----------------------离院跟踪------------------------*/
/** 离院跟踪服务背景 */
@property (weak, nonatomic) IBOutlet UIView *leaveTrackBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leaveTrackHeightLayout;
@property (weak, nonatomic) IBOutlet UILabel *leaveTrackPriceLabel;
/** 离院跟踪开通按钮 */
@property (weak, nonatomic) IBOutlet UIButton *leaveTrackButton;
/** 离院跟踪开通标识 */
@property (weak, nonatomic) IBOutlet UILabel *leaveTrackTipLabel;


/** 服务数组 */
@property (nonatomic, strong) NSArray *servicePriceArray;

@end

@implementation LSBrokerDoctorDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"医生详情";
    
    // 设置医生详情UI
    [self setUI];
    
    // 设置服务UI
    [self serviceUI];
    
    // 设置医生详情数据
    [self setDoctorDetail];
    
    // 设置赞分数
    [self priseScore];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 请求医生各项服务的价格
    // 1. 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/offer/offer_doctor_detail",BASEURL];
    
    // 2. 创建请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:_doctor.doctor_id forKey:@"doctor_id"];
    
    // 3. 发送post请求
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(id responseObj) {
        ZZLog(@"%@",responseObj);
        
        NSDictionary *dict = responseObj[@"result"];
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            _servicePriceArray = [LSServicePrice mj_objectArrayWithKeyValuesArray:dict[@"services"]];

            // 设置价格
            [weakSelf setServiceOptionBgView];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"%@",error);
    }];
}

#pragma mark - 设置赞分数
- (void)priseScore {
    
    // 赞分数
    NSInteger zanTag = [self.doctor.avg_score integerValue];
    for (int i = 1; i <= zanTag; i ++) {
        UIImageView *imgView = [self.view viewWithTag:i];
        imgView.image = [UIImage imageNamed:@"zan_xuan_zhong"];
    }
    
    CGFloat score = [self.doctor.avg_score floatValue];
    NSInteger score_point = [[[NSString stringWithFormat:@"%.1f",score] substringFromIndex:2] integerValue];
    
    if (score_point > 0) {
        UIImageView *imageV = [self.view viewWithTag:zanTag + 1];
        if (score_point <= 5) {
            imageV.image = [UIImage imageNamed:@"zan_banxin"];
        }
        if (score_point > 5) {
            imageV.image = [UIImage imageNamed:@"zan_xuan_zhong"];
        }
    }
}

#pragma mark - 设置UI
- (void)setUI {
    
    // 医生头像
    self.doctorHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // 计算医生擅长背景高度
    CGSize goodAtLabelMaxSize = CGSizeMake(SCREEN_WIDTH - 25, CGFLOAT_MAX);
    CGSize goodAtSize = [self.doctor.good_at boundingRectWithSize:goodAtLabelMaxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: _doctorGootAtLabel.font} context:nil].size;
    self.doctorGoodAtViewHeight.constant = goodAtSize.height + 50;
    
    // 计算医生介绍背景高度
//    CGSize introduceSize = [_doctorInfo.memo boundingRectWithSize:goodAtLabelMaxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: _doctorIntroduceLabel.font} context:nil].size;
//    self.doctorIntroduceHeight.constant = introduceSize.height + 50;

    
}

- (void)serviceUI {
    
    // 1. 设置预约专家背景边框
    _appointBgView.layer.borderColor = ZZBorderColor.CGColor;
    _appointBgView.layer.borderWidth = 1.0f;
    
    self.appointHeightLayout.constant = 44;
    
    ZZLog(@"%f",CGRectGetHeight(self.appointBgView.frame));
    
    // 2. 主刀医生
    _operationBgView.layer.borderColor = ZZBorderColor.CGColor;
    _operationBgView.layer.borderWidth = 1.0f;
    
    self.operationHeightLayout.constant = 44;
    
    // 3. 会诊服务
    _consultationBgView.layer.borderColor = ZZBorderColor.CGColor;
    _consultationBgView.layer.borderWidth = 1.0f;
    
    self.consulationHeightLayout.constant = 44;
    
    
    // 4. 病情分析
    _illnessAnalyzeBgView.layer.borderColor = ZZBorderColor.CGColor;
    _illnessAnalyzeBgView.layer.borderWidth = 1.0f;
    
    self.illnessAnalyzeHeightLayout.constant = 44;
    
    // 5. 离院跟踪
    _leaveTrackBgView.layer.borderColor = ZZBorderColor.CGColor;
    _leaveTrackBgView.layer.borderWidth = 1.0f;
    
    self.leaveTrackHeightLayout.constant = 44;
    
    // 设置服务模块的高度
    self.serviceBgHeightLayout.constant = CGRectGetMaxY(_leaveTrackBgView.frame) + 10;
}

#pragma mark - 设置医生详情数据
- (void)setDoctorDetail {
    
    // 医生头像
    [self.doctorHeaderImageView sd_setImageWithURL:_doctor.avator];
    
    // 医生姓名
    self.doctorNameLabel.text = _doctor.name;
    
    // 医生级别（1-医师2-主治医师3-副主任医师4-主任医师)
    NSString *levelStr = [[NSString alloc] init];
    switch ([_doctor.level integerValue]) {
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
    self.doctorLeaveLabel.text = [NSString stringWithFormat:@"[%@]",levelStr];
    
    // 医生所属医院
    NSString *hospital_name = @"";
    if ([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[LSBrokerSelectDoctorViewController class]]) {
        hospital_name = _doctor.hospital_name;
    } else {
        hospital_name = _doctor.short_name;
    }
    self.doctorHospitalLabel.text = [NSString stringWithFormat:@"%@  %@",hospital_name,_doctor.dept_name];
    // 医生就诊人数
    self.doctorVisitCountLabel.text = [NSString stringWithFormat:@"%@人就诊",_doctor.visit_count];
    
    // 医生擅长
    self.doctorGootAtLabel.text = _doctor.good_at;
}

#pragma mark - 按钮监听事件 判断推出的是哪个服务的设置价格页面
- (IBAction)openServiceBtnAction:(UIButton *)sender {
    
    SettingDocPriceVc *setDocPriceVC = [[SettingDocPriceVc alloc] init];
    // 判断点击的是哪一个button，和医生提供的服务
    if (sender.tag == 3000) {
        setDocPriceVC.typeNum = @"1";
        for (LSServicePrice *servicePrice in _servicePriceArray) {
            if ([servicePrice.service_type isEqualToString:@"1"]) {
                setDocPriceVC.price1 = servicePrice.price;
                setDocPriceVC.price2 = servicePrice.attach_price;
                setDocPriceVC.open_flag = servicePrice.open_flag;
                setDocPriceVC.title = @"预约专家";
            }
        }
    }
    else if (sender.tag == 3001) {
        setDocPriceVC.typeNum = @"2";
        for (LSServicePrice *servicePrice in _servicePriceArray) {
            if ([servicePrice.service_type isEqualToString:@"2"]) {
                setDocPriceVC.price1 = servicePrice.price;
                setDocPriceVC.price2 = servicePrice.attach_price;
                setDocPriceVC.open_flag = servicePrice.open_flag;
                setDocPriceVC.title = @"名医主刀";
            }
        }
    }
    else if (sender.tag == 3002) {
        setDocPriceVC.typeNum = @"3";
        for (LSServicePrice *servicePrice in _servicePriceArray) {
            if ([servicePrice.service_type isEqualToString:@"3"]) {
                setDocPriceVC.price1 = servicePrice.price;
                setDocPriceVC.price2 = servicePrice.attach_price;
                setDocPriceVC.open_flag = servicePrice.open_flag;
                setDocPriceVC.title = @"会诊服务";
            }
        }
    }
    else if (sender.tag == 3003) {
        setDocPriceVC.typeNum = @"4";
        for (LSServicePrice *servicePrice in _servicePriceArray) {
            if ([servicePrice.service_type isEqualToString:@"4"]) {
                setDocPriceVC.price1 = servicePrice.price;
                setDocPriceVC.open_flag = servicePrice.open_flag;
                setDocPriceVC.title = @"疾病分析";
            }
        }
    }
    else {
        setDocPriceVC.typeNum = @"5";
        for (LSServicePrice *servicePrice in _servicePriceArray) {
            if ([servicePrice.service_type isEqualToString:@"5"]) {
                setDocPriceVC.price1 = servicePrice.price;
                setDocPriceVC.open_flag = servicePrice.open_flag;
                setDocPriceVC.title = @"离院跟踪";
            }
        }
    }
    
    setDocPriceVC.doctor = _doctor;
    [self.navigationController pushViewController:setDocPriceVC animated:YES];

}

#pragma mark - 设置各项服务价格
- (void)setServiceOptionBgView {
    
    for (LSServicePrice *servicePrice in _servicePriceArray) {
        if ([servicePrice.open_flag isEqualToString:@"1"]) {
            if ([servicePrice.service_type isEqualToString:@"1"]) { //预约专家
                
                self.appointTipLabel.text = @"(已开通)";
                [self.appointButton setTitle:@"修改" forState:UIControlStateNormal];
                self.appointHeightLayout.constant = 132;
                self.appointBgView.backgroundColor = [UIColor colorWithHexString:@"ecfffe"];
                self.appointPriceLabel.text = [NSString stringWithFormat:@"￥%.0f",[servicePrice.price floatValue]];
                self.goodServicePriceLabel.text = [NSString stringWithFormat:@"￥%.0f",[servicePrice.attach_price floatValue]];
            }
            else if ([servicePrice.service_type isEqualToString:@"2"]) { // 名医主刀
                
                self.operationTipLabel.text = @"(已开通)";
                [self.operationButton setTitle:@"修改" forState:UIControlStateNormal];
                self.operationHeightLayout.constant = 88;
                self.operationBgView.backgroundColor = [UIColor colorWithHexString:@"ecfffe"];
                self.operationPriceLabel.text = [NSString stringWithFormat:@"￥%.0f",[servicePrice.price floatValue]];
            }
            else if ([servicePrice.service_type isEqualToString:@"3"]) { // 会诊服务
                
                self.consulationTipLabel.text = @"(已开通)";
                [self.consulationButton setTitle:@"修改" forState:UIControlStateNormal];
                self.consulationHeightLayout.constant = 88;
                self.consultationBgView.backgroundColor = [UIColor colorWithHexString:@"ecfffe"];
                self.consulationPriceLabel.text = [NSString stringWithFormat:@"￥%.0f",[servicePrice.price floatValue]];
            }
            else if ([servicePrice.service_type isEqualToString:@"4"]) { //
                
                self.illnessAnalyzeTipLabel.text = @"(已开通)";
                [self.illnessAnalyzeButton setTitle:@"修改" forState:UIControlStateNormal];
                self.illnessAnalyzeHeightLayout.constant = 88;
                self.illnessAnalyzeBgView.backgroundColor = [UIColor colorWithHexString:@"ecfffe"];
                self.illnessAnalyzePriceLabel.text = [NSString stringWithFormat:@"￥%.0f",[servicePrice.price floatValue]];
            }
            else {
                
                self.leaveTrackTipLabel.text = @"(已开通)";
                [self.leaveTrackButton setTitle:@"修改" forState:UIControlStateNormal];
                self.leaveTrackHeightLayout.constant = 88;
                self.leaveTrackBgView.backgroundColor = [UIColor colorWithHexString:@"ecfffe"];
                self.leaveTrackPriceLabel.text = [NSString stringWithFormat:@"￥%.0f",[servicePrice.price floatValue]];
            }
        }
    }
}

#pragma mark - Did End On Edit事件 点击return键盘返回
- (IBAction)textFieldReturnEditing:(UITextField *)sender {
    
    [sender resignFirstResponder];
}


@end
