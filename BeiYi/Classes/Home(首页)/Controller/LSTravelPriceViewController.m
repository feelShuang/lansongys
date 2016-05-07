//
//  LSTravelPriceViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/13.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSTravelPriceViewController.h"
#import "LSBrokerGrabOrderViewController.h"
#import "LSBrokerOrderInfoViewController.h"
#import "LSGrabOrder.h"
#import "LSBrokerOrder.h"
#import <UIImageView+WebCache.h>
#import "Common.h"

@interface LSTravelPriceViewController ()

/*------------------------医生详情-------------------------*/
/** 医生头像 */
@property (weak, nonatomic) IBOutlet UIImageView *doctorHeaderImage;
/** 医生姓名 */
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
/** 服务类型 */
@property (weak, nonatomic) IBOutlet UILabel *serviceTypeLabel;
/** 医生所属医院 */
@property (weak, nonatomic) IBOutlet UILabel *doctorHospitalLabel;
/** 就诊时间 */
@property (weak, nonatomic) IBOutlet UILabel *visitTimeLabel;
/** 服务金额 */
@property (weak, nonatomic) IBOutlet UILabel *servicePriceLabel;
/** 下单时间 */
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;


/*------------------------就诊信息-------------------------*/
/** 预约地址 */
@property (weak, nonatomic) IBOutlet UILabel *hospitalAddressLabel;
/** 医院名称 */
@property (weak, nonatomic) IBOutlet UILabel *hospitalNameLabel;
/** 科室名称 */
@property (weak, nonatomic) IBOutlet UILabel *departmentNameLabel;


/*------------------------差旅费-------------------------*/
@property (weak, nonatomic) IBOutlet UITextField *travelPriceTextField;


/*------------------------确定按钮-------------------------*/

@property (nonatomic, copy) NSString *order_code;

@end

@implementation LSTravelPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"差旅费";
//    /uc/order/add_audit_price
    // 设置订单数据
    [self setOrderData];
}

- (void)setOrderData {
    
    if ([self.navigationController.viewControllers[0] isKindOfClass:[LSBrokerOrderInfoViewController class]]) {
        /*------------------------医生详情-------------------------*/
        // 医生头像
        [self.doctorHeaderImage sd_setImageWithURL:_grabOrder.avator];
        // 医生姓名
        self.doctorNameLabel.text = _grabOrder.doctor_name;
        // 订单类型
        self.serviceTypeLabel.text = _grabOrder.order_type_str;
        // 医生所属医院
        self.doctorHospitalLabel.text = [NSString stringWithFormat:@"%@  %@",_grabOrder.hospital_name,_grabOrder.department_name];
        // 服务价格
        self.servicePriceLabel.text = [NSString stringWithFormat:@"%@",_orderPrice];
        
        
        /*------------------------就诊信息-------------------------*/
        // 预约地址
        self.hospitalAddressLabel.text = _grabOrder.attach.visit_address;
        // 医院名称
        self.hospitalNameLabel.text = _grabOrder.attach.visit_hospital;
        // 所属科室
        self.departmentNameLabel.text = _grabOrder.attach.visit_department;
        
        // 订单编号
        self.order_code = _grabOrder.order_code;
        
    } else {
        /*------------------------医生详情-------------------------*/
        // 医生头像
        [self.doctorHeaderImage sd_setImageWithURL:_brokerOrder.doctor_avator];
        // 医生姓名
        self.doctorNameLabel.text = _brokerOrder.doctor_name;
        // 订单类型
        self.serviceTypeLabel.text = _brokerOrder.order_type_show;
        // 医生所属医院
        self.doctorHospitalLabel.text = [NSString stringWithFormat:@"%@  %@",_brokerOrder.hospital_name,_brokerOrder.department_name];
        // 服务价格
        self.servicePriceLabel.text = [NSString stringWithFormat:@"%@",_orderPrice];
        
        
        /*------------------------就诊信息-------------------------*/
        // 预约地址
        self.hospitalAddressLabel.text = _brokerOrder.attach.visit_address;
        // 医院名称
        self.hospitalNameLabel.text = _brokerOrder.attach.visit_hospital;
        // 所属科室
        self.departmentNameLabel.text = _brokerOrder.attach.visit_department;
        
        // 订单编号
        self.order_code = _brokerOrder.order_code;
    }
}

#pragma mark - 提交差旅费，审核
- (IBAction)commitTravelBtnAction:(UIButton *)sender {
    
    // 1. 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/add_audit_price",BASEURL];
    
    // 2. 创建请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"token"] = myAccount.token;
    params[@"order_code"] = _order_code;
    params[@"price"] = [_orderPrice substringFromIndex:1];
    params[@"price_type"] = @1;
    
    ZZLog(@"params = %@",params);
    
    // 3. 发送post请求
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(id responseObj) {
        ZZLog(@"----差旅费-----%@",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            
            LSBrokerOrderInfoViewController *brokerOrderInfoVC = [LSBrokerOrderInfoViewController new];
            
            brokerOrderInfoVC.order_code = _order_code;
            
            [self.navigationController pushViewController:brokerOrderInfoVC animated:YES];
        } else {
            
            [MBProgressHUD showError:responseObj[@"message"] toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
