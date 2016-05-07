//
//  LSPatientOrderInfoViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/3/21.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#define SPACEBETWEEN_IMAGE 36
#define IMAGE_WIDTH 28

#import "LSPatientOrderInfoViewController.h"
#import "LSPatientOrderDetail.h"
#import "LSSelectPayModeController.h"
#import "LSPatientCertificateViewController.h"
#import "LSEvaluationViewController.h"
#import "OrderInfo.h"
#import "UIBarButtonItem+Extension.h"
#import <UIImageView+WebCache.h>
#import "Common.h"

@interface LSPatientOrderInfoViewController ()

/** 患者订单详情模型 */
@property (nonatomic, strong) LSPatientOrderDetail *patientOrderDetail;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomLayout;

/*------------------------进度条-------------------------*/
/** 订单状态提示语 */
@property (weak, nonatomic) IBOutlet UILabel *orderTipTitleLabel;
/** 蓝色进度条宽度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueLineWidthLayout;
/** 接单图片 */
@property (weak, nonatomic) IBOutlet UIImageView *jieDanImageView;
/** 付款图片 */
@property (weak, nonatomic) IBOutlet UIImageView *fuKuanImageView;
/** 出号图片 */
@property (weak, nonatomic) IBOutlet UIImageView *chuHaoImageView;
/** 确认图片 */
@property (weak, nonatomic) IBOutlet UIImageView *queRenImageView;


/*------------------------医生详情-------------------------*/
/** 医生头像 */
@property (weak, nonatomic) IBOutlet UIImageView *doctorHeaderImage;
/** 医生姓名 */
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
/** 医生级别 */
@property (weak, nonatomic) IBOutlet UILabel *doctorLevelLabel;
/** 医生所属医院 */
@property (weak, nonatomic) IBOutlet UILabel *doctorHospitalLabel;
/** 服务类型 */
@property (weak, nonatomic) IBOutlet UILabel *serviceTypeLabel;
/** 预约专家服务优质服务标识 */
@property (weak, nonatomic) IBOutlet UILabel *appointmentGoodServiceLabel;
/** 就诊时间 */
@property (weak, nonatomic) IBOutlet UILabel *visitTimeLabel;
/** 服务金额 */
@property (weak, nonatomic) IBOutlet UILabel *servicePriceLabel;


/*------------------------就诊信息-------------------------*/
/** 就诊信息背景高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *visitInfoBgViewHeightLayout;
/** 医院地址 */
@property (weak, nonatomic) IBOutlet UILabel *hospitalAddressLabel;
/** 医院名称 */
@property (weak, nonatomic) IBOutlet UILabel *hospitalNameLabel;
/** 科室名称 */
@property (weak, nonatomic) IBOutlet UILabel *departmentNameLabel;



/*------------------------患者信息-------------------------*/
/** 就诊人姓名 */
@property (weak, nonatomic) IBOutlet UILabel *visitPersonNameLabel;
/** 就诊人联系方式 */
@property (weak, nonatomic) IBOutlet UILabel *visitPersonMobileLabel;


/*------------------------订单信息-------------------------*/
/** 订单编号 */
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
/** 下单时间 */
@property (weak, nonatomic) IBOutlet UILabel *orderStartTimeLabel;

/*------------------------支付按钮-------------------------*/
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, copy) NSString *result_flag;

@end

@implementation LSPatientOrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"订单详情";
    
    [OrderInfo shareInstance].isUpLoading = YES;
    
    // 设置UI
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([OrderInfo shareInstance].isUpLoading == YES) {
        
        // 请求订单详情数据
        [self loadHttpRequest];
    }
}

#pragma mark - 设置UI
- (void)setUI {
    
    self.visitInfoBgViewHeightLayout.constant = 0;
    
    // 重写navigation返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:nil target:self action:@selector(leftBtnClicked)];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitle:@"查看凭证" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(seeCertificateAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.hidden = YES;
    self.rightBtn = rightBtn;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

#pragma mark - 监听导航栏左侧按钮点击
- (void)leftBtnClicked {
    
    // 点击返回到根视图
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 查看凭证按钮 监听
- (void)seeCertificateAction {
    
    LSPatientCertificateViewController *patientCertificateVC = [LSPatientCertificateViewController new];
    
    patientCertificateVC.patientOrderDetail = _patientOrderDetail;
    
    [self.navigationController pushViewController:patientCertificateVC animated:YES];
}

#pragma mark - 请求订单详情
- (void)loadHttpRequest {
    
    // 2.1 准备请求接口
    NSString *urlString = [NSString stringWithFormat:@"%@/uc/order/order_detail",BASEURL];
    
    // 2.2 创建请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:myAccount.token forKey:@"token"]; // 1.登录token
    [params setObject:self.order_code forKey:@"order_code"];
    ZZLog(@"%@",self.order_code);
    
    
    // 2.2发送post请求
    __weak typeof(self) weakSelf = self;
    [ZZHTTPTool post:urlString params:params success:^(id responseObj) {
        ZZLog(@"订单详情——————%@",responseObj);
        
        // 隐藏遮盖
        [MBProgressHUD hideHUD];
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            
            NSDictionary *dict = responseObj[@"result"];
            _patientOrderDetail = [LSPatientOrderDetail mj_objectWithKeyValues:dict];
            
            // 设置订单不同状态的UI
            [weakSelf setDifferentOrderTypePage];
            
            // 设置进度条
            [weakSelf setProgressState];
            
            // 设置页面数据
            [weakSelf setOrderDetailPageInfo];
        }else {
            [MBProgressHUD showError:@"发生异常，请重试"];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"---%@",error);
        
        // 隐藏遮盖
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
        
    }];
}

#pragma mark - 设置不同状态下展示不同的UI场景
- (void)setDifferentOrderTypePage {
    
    /*------------------------根据订单类型设置UI-------------------------*/
    // 主刀医生服务
    if ([_patientOrderDetail.order_type isEqualToString:@"2"]) {
        
        if ([_patientOrderDetail.attach.visit_type isEqualToString:@"2"]) {
            
        } else {
            self.visitInfoBgViewHeightLayout.constant = 164;
        }
    }
    
    // 会诊服务
    if ([_patientOrderDetail.order_type isEqualToString:@"3"] ) {
        
        self.visitInfoBgViewHeightLayout.constant = 164;
    }
    
    // 付款按钮的配置
    if ([_patientOrderDetail.order_status isEqualToString:@"1"]) {
        // 关闭按钮交互
        _payButton.userInteractionEnabled = NO;
        _payButton.backgroundColor = [UIColor colorWithHexString:@"#d5d5d5"];
    } else if ([_patientOrderDetail.order_status isEqualToString:@"2"]) {
        
        // 开启按钮交互
        _payButton.userInteractionEnabled = YES;
        _payButton.backgroundColor = [UIColor colorWithHexString:@"#fc8924"];
    } else if ([_patientOrderDetail.order_status isEqualToString:@"3"]) {
        
        self.scrollViewBottomLayout.constant = 0;
    } else if ([_patientOrderDetail.order_status isEqualToString:@"5"]) {
        
        self.rightBtn.hidden = NO;
        // 开启按钮交互
        _payButton.userInteractionEnabled = YES;
        _payButton.backgroundColor = [UIColor colorWithHexString:@"#fc8924"];
        // 设置标题
        [_payButton setTitle:@"确认完成" forState:UIControlStateNormal];
    } else if ([_patientOrderDetail.order_status isEqualToString:@"6"]) {
        self.rightBtn.hidden = NO;
        [_payButton setTitle:@"立即评价" forState:UIControlStateNormal];
    } else {
        self.rightBtn.hidden = NO;
        
        self.scrollViewBottomLayout.constant = 0;
    }
}

#pragma mark - 设置进度条状态
- (void)setProgressState {
    
    if ([_patientOrderDetail.order_status isEqualToString:@"1"]) {
    } else if ([_patientOrderDetail.order_status isEqualToString:@"2"]) {  // 待付款
        
        self.orderTipTitleLabel.text = @"30分钟未支付，订单将自动取消";
        self.blueLineWidthLayout.constant = SPACEBETWEEN_IMAGE + IMAGE_WIDTH + SPACEBETWEEN_IMAGE / 2;
        self.jieDanImageView.image = [UIImage imageNamed:@"order_jie_dan"];
    } else if ([_patientOrderDetail.order_status isEqualToString:@"3"]) { // 待出号
        
        self.orderTipTitleLabel.text = @"正在确认医疗资源，请耐心等待";
        self.blueLineWidthLayout.constant = SPACEBETWEEN_IMAGE * 2 + IMAGE_WIDTH * 2 + SPACEBETWEEN_IMAGE / 2;
        self.jieDanImageView.image = [UIImage imageNamed:@"order_jie_dan"];
        self.fuKuanImageView.image = [UIImage imageNamed:@"order_fu_kuan"];
    } else if ([_patientOrderDetail.order_status isEqualToString:@"5"]) { // 待确认
        
        NSString *visitTime = [_patientOrderDetail.over_over.visit_start substringToIndex:10];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *curDate = [NSDate date];
        NSString *curTime = [formatter stringFromDate:curDate];
        ;
        // NSOrderedAscending    左边 < 右边  == -1
        // NSOrderedSame         内容相同     ==  0
        // NSOrderedDescending   左边 > 右边  ==  1
        ZZLog(@"%@,%@",curTime,visitTime);
        if ([curTime compare:visitTime] == 1) {
            ;
            self.orderTipTitleLabel.text = @"24小时未确认，系统将自动确认";
        } else {
            self.orderTipTitleLabel.text = @"平台已出号，请点击右上角查看凭证";
//            _payButton.userInteractionEnabled = NO;
//            _payButton.backgroundColor = [UIColor colorWithHexString:@"#d5d5d5"];
        }
        self.blueLineWidthLayout.constant = SPACEBETWEEN_IMAGE * 3 + IMAGE_WIDTH * 3 + SPACEBETWEEN_IMAGE / 2;
        self.jieDanImageView.image = [UIImage imageNamed:@"order_jie_dan"];
        self.fuKuanImageView.image = [UIImage imageNamed:@"order_fu_kuan"];
        self.chuHaoImageView.image = [UIImage imageNamed:@"order_chu_hao1"];
    } else if ([_patientOrderDetail.order_status isEqualToString:@"6"]) { // 待评价
        
        self.orderTipTitleLabel.text = @"服务已完成，请对本次服务进行评价";
        self.blueLineWidthLayout.constant = SPACEBETWEEN_IMAGE * 4 + IMAGE_WIDTH * 4;
        self.jieDanImageView.image = [UIImage imageNamed:@"order_jie_dan"];
        self.fuKuanImageView.image = [UIImage imageNamed:@"order_fu_kuan"];
        self.chuHaoImageView.image = [UIImage imageNamed:@"order_chu_hao1"];
        self.queRenImageView.image = [UIImage imageNamed:@"order_que_ren"];
    } else  { // 服务完成后的状态显示
        
        self.orderTipTitleLabel.text = @"服务已完成";
        self.blueLineWidthLayout.constant = SPACEBETWEEN_IMAGE * 4 + IMAGE_WIDTH * 4;
        self.jieDanImageView.image = [UIImage imageNamed:@"order_jie_dan"];
        self.fuKuanImageView.image = [UIImage imageNamed:@"order_fu_kuan"];
        self.chuHaoImageView.image = [UIImage imageNamed:@"order_chu_hao1"];
        self.queRenImageView.image = [UIImage imageNamed:@"order_que_ren"];
    }
}

#pragma Mark - 给详情页面添加数据
- (void)setOrderDetailPageInfo {
    
    /*------------------------就诊信息-------------------------*/
    // 医生头像
    [self.doctorHeaderImage sd_setImageWithURL:_patientOrderDetail.doctor_avator];
    // 医生姓名
    self.doctorNameLabel.text = _patientOrderDetail.doctor_name;
    // 医生级别
    self.doctorLevelLabel.text = [NSString stringWithFormat:@"[%@]",_patientOrderDetail.doctor_level];
    // 医生所属医院
    self.doctorHospitalLabel.text = [NSString stringWithFormat:@"%@  %@",_patientOrderDetail.hospital_name,_patientOrderDetail.department_name];
    // 服务类型
    self.serviceTypeLabel.text = _patientOrderDetail.order_type_str;
    // 预约专家优质服务标识
#warning 预约专家这里优质服务标识没有变化
    if ([_patientOrderDetail.order_type isEqualToString:@"1"]) {
        
        if ([_patientOrderDetail.service_attach isEqualToString:@"优质门诊服务"]) {
            self.appointmentGoodServiceLabel.text = @"(门诊优质服务)";
        }
    } else {
        
        self.appointmentGoodServiceLabel.text = @"";
    }
    // 就诊时间
    self.visitTimeLabel.text = _patientOrderDetail.visit_time;
    // 服务金额
    if ([_patientOrderDetail.order_status isEqualToString:@"1"]) {
        self.servicePriceLabel.text = [NSString stringWithFormat:@"%ld",_patientOrderDetail.attach.init_service_price + _patientOrderDetail.attach.init_assure_price];
    } else {
        self.servicePriceLabel.text = [NSString stringWithFormat:@"￥%@",_patientOrderDetail.price];
    }
    
    /*------------------------就诊信息-------------------------*/
    if ([_patientOrderDetail.order_type isEqualToString:@"2"]) {
        
        if ([_patientOrderDetail.attach.visit_type isEqualToString:@"2"]) { // 本院
            
        } else { // 外院
            
            // 医院地址
            self.hospitalAddressLabel.text = _patientOrderDetail.attach.visit_address;
            // 医院名称
            self.hospitalNameLabel.text = _patientOrderDetail.attach.visit_hospital;
            // 科室名称
            self.departmentNameLabel.text = _patientOrderDetail.attach.visit_department;
        }
    }
    if ( [_patientOrderDetail.order_type isEqualToString:@"3"] ) {
        
        // 医院地址
        self.hospitalAddressLabel.text = _patientOrderDetail.attach.visit_address;
        // 医院名称
        self.hospitalNameLabel.text = _patientOrderDetail.attach.visit_hospital;
        // 科室名称
        self.departmentNameLabel.text = _patientOrderDetail.attach.visit_department;
    }
    
    
    /*------------------------患者信息-------------------------*/
    // 就诊人姓名
    self.visitPersonNameLabel.text = _patientOrderDetail.human.name;
    // 就诊人联系方式
    self.visitPersonMobileLabel.text = _patientOrderDetail.human.mobile;
    
    /*------------------------订单信息-------------------------*/
    self.orderCodeLabel.text = _patientOrderDetail.order_code;
    self.orderStartTimeLabel.text = _patientOrderDetail.order_time_show;
}

#pragma mark - 支付按钮 监听
- (IBAction)payBtnAction:(UIButton *)sender {

    
    if ([_patientOrderDetail.order_status isEqualToString:@"2"]) {
        
        // 推出付款页面
        LSSelectPayModeController *selectPayOrderVC = [LSSelectPayModeController new];
        selectPayOrderVC.orderCode = _patientOrderDetail.order_code;
        selectPayOrderVC.payType = @"2";
        selectPayOrderVC.price = self.servicePriceLabel.text;
        
        [self.navigationController pushViewController:selectPayOrderVC animated:YES];
    }
    if ([_patientOrderDetail.order_status isEqualToString:@"5"]) {
        
        [self alertTips];
    }
    if ([_patientOrderDetail.order_status isEqualToString:@"6"]) {
        
        [self gotoEvaluation];
    }
}

- (void)gotoEvaluation {
    
    LSEvaluationViewController *evaluationVC = [LSEvaluationViewController new];
    evaluationVC.patientOrderDetail = _patientOrderDetail;
    [self.navigationController pushViewController:evaluationVC animated:YES];
}

- (void)alertTips {
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"确认成功，是否立即评价？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.result_flag = @"1";
        // 提交确认凭证请求
        [self loadCertificateRequest];
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self loadHttpRequest];
    }];
    
    [alertView addAction:okAction];
    [alertView addAction:cancleAction];
    
    [self presentViewController:alertView animated:YES completion:nil];

}

#pragma mark - 提交确认凭证请求
- (void)loadCertificateRequest {
    
    // 创建请求体
    NSString *urlString = [NSString stringWithFormat:@"%@/uc/order/publish_confirm",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:myAccount.token forKey:@"token"]; // 登陆标识
    [params setObject:_patientOrderDetail.order_code forKey:@"order_code"]; // 订单编号
    [params setObject:self.result_flag forKey:@"result_flag"]; // 是否通过
    [params setObject:@"我已经完成本次服务" forKey:@"memo"];
    ZZLog(@"params = %@",params);
    // 发送post请求
    __weak typeof(self) weakSelf = self;
    [ZZHTTPTool post:urlString params:params success:^(id responseObj) {
        ZZLog(@"确认凭证-----%@",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            
            [self gotoEvaluation];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"---%@",error);
        
        // 隐藏遮盖
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
    }];
    
}

- (IBAction)contactUs:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"立即拨打客服电话" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ZZLog(@"%@",sender.titleLabel.text);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",sender.titleLabel.text]]];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
