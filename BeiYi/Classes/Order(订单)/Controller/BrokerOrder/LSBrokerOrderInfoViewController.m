//
//  LSBrokerOrderInfoViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/14.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#define SPACEBETWEEN_IMAGE 36
#define IMAGE_WIDTH 28

#import "LSBrokerOrderInfoViewController.h"
#import "LSSelectPayModeController.h"
#import "LSBrokerCertificateViewController.h"
#import "LSPatientCertificateViewController.h"
#import "LSPatientOrderDetail.h"
#import <UIImageView+WebCache.h>
#import "Common.h"

@interface LSBrokerOrderInfoViewController ()

/**
 *  订单详情模型
 */
@property (nonatomic, strong) LSPatientOrderDetail *brokerOrderDetail;

/*------------------------进度条-------------------------*/
/** 订单状态提示语 */
@property (weak, nonatomic) IBOutlet UILabel *orderTipTitleLabel;
/** 蓝色进度条宽度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueLineWidthLayout;
/** 接单图片 */
@property (weak, nonatomic) IBOutlet UIImageView *jieDanImageView;
/** 确认图片 */
@property (weak, nonatomic) IBOutlet UIImageView *queRenImageView;
/** 出号图片 */
@property (weak, nonatomic) IBOutlet UIImageView *chuHaoImageView;
/** 完成图片 */
@property (weak, nonatomic) IBOutlet UIImageView *wanChengImageView;


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

@end

@implementation LSBrokerOrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"订单详情";
    // 设置UI
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 请求订单详情数据
    [self loadBrokerOrderDetail];
}

#pragma mark - 设置UI
- (void)setUI {
    
    self.visitInfoBgViewHeightLayout.constant = 0;
    // 设置头像填充模式
    self.doctorHeaderImage.contentMode = UIViewContentModeScaleAspectFill;
}

#pragma mark - 加载经纪人订单详情
- (void)loadBrokerOrderDetail {
    
    // 2.1 准备请求接口
    NSString *urlString = [NSString stringWithFormat:@"%@/uc/order/offer_order_detail",BASEURL];
    
    // 2.2 创建请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:myAccount.token forKey:@"token"]; // 1.登录token
    [params setObject:self.order_code forKey:@"order_code"];

    ZZLog(@"%@",params);
    // 2.2发送post请求
    __weak typeof(self) weakSelf = self;
    [ZZHTTPTool post:urlString params:params success:^(id responseObj) {
        ZZLog(@"订单详情——————%@",responseObj);
        
        // 隐藏遮盖
        [MBProgressHUD hideHUD];
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            
            NSDictionary *dict = responseObj[@"result"];
            _brokerOrderDetail = [LSPatientOrderDetail mj_objectWithKeyValues:dict];

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
    if ([_brokerOrderDetail.order_type isEqualToString:@"2"]) {
        
        if ([_brokerOrderDetail.attach.visit_type isEqualToString:@"2"]) {
            
        } else {
            self.visitInfoBgViewHeightLayout.constant = 164;
        }
    }
    
    // 会诊服务
    if ([_brokerOrderDetail.order_type isEqualToString:@"3"] ) {
        
        self.visitInfoBgViewHeightLayout.constant = 164;
    }
    
    
    // 按钮操作
    if ([_brokerOrderDetail.order_status isEqualToString:@"1"]) {
        
    } else if ([_brokerOrderDetail.order_status isEqualToString:@"2"]) {
        
        _payButton.userInteractionEnabled = NO;
        _payButton.backgroundColor = [UIColor colorWithHexString:@"#d5d5d5"];
        [_payButton setTitle:@"提交凭证" forState:UIControlStateNormal];
    } else if ([_brokerOrderDetail.order_status isEqualToString:@"3"]) {
        
        [_payButton setTitle:@"提交凭证" forState:UIControlStateNormal];
    } else {
        
        _payButton.userInteractionEnabled = YES;
        [_payButton setTitle:@"查看凭证" forState:UIControlStateNormal];
    }
}

#pragma mark - 设置进度条状态
- (void)setProgressState {
    
    if ([_brokerOrderDetail.order_status isEqualToString:@"1"]) { // 未确定接单
        self.orderTipTitleLabel.text = @"30分钟未确认，订单将自动释放";
    }else if ([_brokerOrderDetail.order_status isEqualToString:@"2"]) { // 已接单
        self.orderTipTitleLabel.text = @"患者还未付款，请耐心等待";
        self.blueLineWidthLayout.constant = SPACEBETWEEN_IMAGE + IMAGE_WIDTH + SPACEBETWEEN_IMAGE / 2;
        self.queRenImageView.image = [UIImage imageNamed:@"order_que_ren"];
    } else if ([_brokerOrderDetail.order_status isEqualToString:@"3"]) { // 待出号
        self.orderTipTitleLabel.text = @"请及时提交就诊信息";
        self.blueLineWidthLayout.constant = SPACEBETWEEN_IMAGE + IMAGE_WIDTH + SPACEBETWEEN_IMAGE / 2;
        self.queRenImageView.image = [UIImage imageNamed:@"order_que_ren"];
    } else if ([_brokerOrderDetail.order_status isEqualToString:@"5"]) { // 已出号
        self.orderTipTitleLabel.text = @"服务进行中，请等待患者确认";
        self.blueLineWidthLayout.constant = SPACEBETWEEN_IMAGE * 2 + IMAGE_WIDTH * 2 + SPACEBETWEEN_IMAGE / 2;
        self.queRenImageView.image = [UIImage imageNamed:@"order_que_ren"];
        self.chuHaoImageView.image = [UIImage imageNamed:@"order_chu_hao1"];
    } else if ([_brokerOrderDetail.order_status isEqualToString:@"6"]) { // 服务已确认
        self.orderTipTitleLabel.text = @"患者已确认";
        self.blueLineWidthLayout.constant = SPACEBETWEEN_IMAGE * 3 + IMAGE_WIDTH * 2;
        self.queRenImageView.image = [UIImage imageNamed:@"order_que_ren"];
        self.chuHaoImageView.image = [UIImage imageNamed:@"order_chu_hao1"];
        self.wanChengImageView.image = [UIImage imageNamed:@"order_wan_cheng1"];
    } else {
        self.orderTipTitleLabel.text = @"服务已完成";
        self.blueLineWidthLayout.constant = SPACEBETWEEN_IMAGE * 3 + IMAGE_WIDTH * 2;
        self.queRenImageView.image = [UIImage imageNamed:@"order_que_ren"];
        self.chuHaoImageView.image = [UIImage imageNamed:@"order_chu_hao1"];
        self.wanChengImageView.image = [UIImage imageNamed:@"order_wan_cheng1"];
    }
}


#pragma Mark - 给详情页面添加数据
- (void)setOrderDetailPageInfo {
    
    /*------------------------就诊信息-------------------------*/
    // 医生头像
    [self.doctorHeaderImage sd_setImageWithURL:_brokerOrderDetail.doctor_avator];
    // 医生姓名
    self.doctorNameLabel.text = _brokerOrderDetail.doctor_name;
    // 医生级别
    self.doctorLevelLabel.text = [NSString stringWithFormat:@"[%@]",_brokerOrderDetail.doctor_level];
    // 医生所属医院
    self.doctorHospitalLabel.text = [NSString stringWithFormat:@"%@  %@",_brokerOrderDetail.hospital_name,_brokerOrderDetail.department_name];
    // 服务类型
    self.serviceTypeLabel.text = _brokerOrderDetail.order_type_str;
    // 预约专家优质服务标识
#warning 预约专家这里优质服务标识没有变化
    if ([_brokerOrderDetail.order_type isEqualToString:@"1"]) {

        if ([_brokerOrderDetail.service_attach isEqualToString:@"优质门诊服务"]) {
            self.appointmentGoodServiceLabel.text = @"(门诊优质服务)";
        }
    } else {
        
        self.appointmentGoodServiceLabel.text = @"";
    }
    // 就诊时间
    self.visitTimeLabel.text = _brokerOrderDetail.visit_time;
    // 服务金额
    self.servicePriceLabel.text = [NSString stringWithFormat:@"￥%@",_brokerOrderDetail.price];
    
    
    /*------------------------就诊信息-------------------------*/
    if ([_brokerOrderDetail.order_type isEqualToString:@"2"]) {
        
        if ([_brokerOrderDetail.attach.visit_type isEqualToString:@"2"]) { // 本院
            
        } else { // 外院
            
            // 医院地址
            self.hospitalAddressLabel.text = _brokerOrderDetail.attach.visit_address;
            // 医院名称
            self.hospitalNameLabel.text = _brokerOrderDetail.attach.visit_hospital;
            // 科室名称
            self.departmentNameLabel.text = _brokerOrderDetail.attach.visit_department;
        }
    }
    if ( [_brokerOrderDetail.order_type isEqualToString:@"3"] ) {
        
        // 医院地址
        self.hospitalAddressLabel.text = _brokerOrderDetail.attach.visit_address;
        // 医院名称
        self.hospitalNameLabel.text = _brokerOrderDetail.attach.visit_hospital;
        // 科室名称
        self.departmentNameLabel.text = _brokerOrderDetail.attach.visit_department;
    }
    
    
    /*------------------------患者信息-------------------------*/
    // 就诊人姓名
    self.visitPersonNameLabel.text = _brokerOrderDetail.human.name;
    // 就诊人联系方式
    self.visitPersonMobileLabel.text = _brokerOrderDetail.human.mobile;
    
    /*------------------------订单信息-------------------------*/
    self.orderCodeLabel.text = _brokerOrderDetail.order_code;
    self.orderStartTimeLabel.text = _brokerOrderDetail.order_time_show;
}

#pragma mark - 支付按钮 监听
- (IBAction)brokerPaybtnAction:(UIButton *)sender {
    
    if ([_brokerOrderDetail.order_status isEqualToString:@"1"]) {
        
        // 支付
//        LSSelectPayModeController *selectPayVC = [LSSelectPayModeController new];
//        selectPayVC.price = _servicePriceLabel.text;
//        selectPayVC.orderCode = _brokerOrderDetail.order_code;
//        selectPayVC.payType = @"4";

        // 1.先要获取订单编号
        NSString *urlStr = [NSString stringWithFormat:@"%@/uc/trader/gen_code",BASEURL];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary]
        ;
        [params setObject:myAccount.token forKey:@"token"];
        [params setObject:_brokerOrderDetail.order_code forKey:@"order_code"]; // 订单编号
        [params setObject:@"4" forKey:@"pay_type"]; // 付款类型2-发布订单 4-抢单
        [params setObject:@"2" forKey:@"pay_source"]; // 付款源1-支付宝 2-帐户余额
        
        /** 交易单号 */
        __block NSString *tradeCode = [NSString string];
        
        __weak typeof(self)weakSelf = self;
        [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
            ZZLog(@"~~获取交易单号--responseObj~%@",responseObj);
            
            tradeCode = responseObj[@"result"];
            // 2.判断是否成功获取交易单号
            if ([responseObj[@"code"] isEqualToString:@"0000"]) {// 成功获取订单编号
                ZZLog(@"~~成功获取交易单号--orderCode~%@",tradeCode);
                
                [weakSelf loadHttpForPay:tradeCode];
                
            }else {// 获取订单编号失败
                // 2.2 获取失败,提示获取失败
                [MBProgressHUD showError:responseObj[@"message"] toView:weakSelf.view];
            }
            
        } failure:^(NSError *error) {
            ZZLog(@"~~~%@",error);
            
        }];
    } else if ([_brokerOrderDetail.order_status isEqualToString:@"2"]) {
        
    } else if ([_brokerOrderDetail.order_status isEqualToString:@"3"]) {
        
        // 提交凭证
        LSBrokerCertificateViewController *brokerCertificateVC = [LSBrokerCertificateViewController new];
        brokerCertificateVC.brokerOrderDetail = _brokerOrderDetail;
        [self.navigationController pushViewController:brokerCertificateVC animated:YES];
    } else {
        
        // 查看凭证
        LSPatientCertificateViewController *patientCertificateVC = [LSPatientCertificateViewController new];
        patientCertificateVC.patientOrderDetail = _brokerOrderDetail;
        [self.navigationController pushViewController:patientCertificateVC animated:YES];
    }
}

#pragma mark  余额支付
- (void)loadHttpForPay:(NSString *)orderCode {
    
    [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/trader/pay",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary]
    ;
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:orderCode forKey:@"trader_code"];
    
    __weak typeof(self) weakSelf = self;
    
    [ZZHTTPTool post:urlStr params:params success:^(id responseObj) {
        ZZLog(@"~~*&*&*~%@",responseObj);
        
        // 隐藏遮盖
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            
            [MBProgressHUD showSuccess:@"操作成功"];
            
            // 跳转返回 "我的订单" 列表界面
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else {
            [MBProgressHUD showError:responseObj[@"message"] toView:weakSelf.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        ZZLog(@"~~~%@",error);
        
    }];
    
}

#pragma mark - 拨打电话
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
