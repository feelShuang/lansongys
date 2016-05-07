//
//  LSSelectPayModeController.m
//  BeiYi
//
//  Created by LiuShuang on 15/6/24.
//  Copyright (c) 2015年 LiuShuang. All rights reserved.
//

#import "LSSelectPayModeController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AlipayOrder.h"
#import "DataSigner.h"
#import "Common.h"

@interface LSSelectPayModeController ()

/** 订单编号 */
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
/** 订单价格 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/** 可用余额 */
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
/** 选择余额支付按钮 */
@property (weak, nonatomic) IBOutlet UIButton *yu_eButton;
/** 选择支付宝支付按钮 */
@property (weak, nonatomic) IBOutlet UIButton *zhiFuBaoButton;

/** 支付方式 */
@property (nonatomic, copy) NSString *paymentType;

@end

@implementation LSSelectPayModeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.基本设置
    self.view.backgroundColor = ZZBackgroundColor;
    self.title = @"保证金付款";
    
    // 2. 默认余额支付-2
    self.paymentType = @"2";
    
    // 3. 设置订单数据
    [self setOrderData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self GetBalance];// 获取余额
}

#pragma mark - 获取余额
- (void)GetBalance {
    
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/trader/account",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];// 登录token
    
    __weak typeof(self) weakSelf = self;
    
    // 2.发送post请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"---获取余额---%@",responseObj);
        
        if ([responseObj[@"code"] isEqual:@"0000"]) {// 操作成功
            NSDictionary *resultDict = responseObj[@"result"];
            weakSelf.balanceLabel.text = [NSString stringWithFormat:@"可用余额：%.0f 元",[resultDict[@"use_balance"] floatValue]];
            
        }else {// 操作失败
            [MBProgressHUD showError:responseObj[@"message"] toView:weakSelf.view];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"---获取余额---%@",error);
        
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
    }];
}

#pragma mark - 设置订单数据
- (void)setOrderData {
    
    // 订单编号
    self.orderCodeLabel.text = [NSString stringWithFormat:@"订单编号：%@",_orderCode];
    // 订单价格
    self.priceLabel.text = [NSString stringWithFormat:@"%@",_price];
}

#pragma mark  支付方式按钮 监听
- (IBAction)paymentTypeSelectAction:(UIButton *)sender {
    
    if (sender.tag == 1000) {
        self.paymentType = @"2";
        
        [self.yu_eButton setImage:[UIImage imageNamed:@"service_xuan_ze"] forState:UIControlStateNormal];
        [self.zhiFuBaoButton setImage:[UIImage imageNamed:@"service_mo_ren"] forState:UIControlStateNormal];
    } else {
        self.paymentType = @"1";
        
        [self.yu_eButton setImage:[UIImage imageNamed:@"service_mo_ren"] forState:UIControlStateNormal];
        [self.zhiFuBaoButton setImage:[UIImage imageNamed:@"service_xuan_ze"] forState:UIControlStateNormal];
    }
}

#pragma mark - 支付按钮 监听 点击（先获取交易单号，再进行支付）
- (IBAction)payBtnAction:(UIButton *)sender {
    
    // 1.先要获取订单编号
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/trader/gen_code",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary]
    ;
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:self.orderCode forKey:@"order_code"]; // 订单编号
    [params setObject:self.payType forKey:@"pay_type"]; // 付款类型2-发布订单 4-抢单
    [params setObject:self.paymentType forKey:@"pay_source"]; // 付款源1-支付宝 2-帐户余额
    ZZLog(@"%@",params);
    
    /** 交易单号 */
    __block NSString *tradeCode = [NSString string];
    
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"~~获取交易单号--responseObj~%@",responseObj);
        
        tradeCode = responseObj[@"result"];
        // 2.判断是否成功获取交易单号
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {// 成功获取订单编号
            ZZLog(@"~~成功获取交易单号--orderCode~%@",tradeCode);
            
            // 2.1 成功获取，则进行点击之后的网络链接
            if ([weakSelf.paymentType isEqualToString:@"2"]) {
                [weakSelf loadHttpForPay:tradeCode];
            } else {
                // 支付宝
                
                [weakSelf alipay:tradeCode];
            }
            
        }else {// 获取订单编号失败
            // 2.2 获取失败,提示获取失败
            [MBProgressHUD showError:responseObj[@"message"] toView:weakSelf.view];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"~~~%@",error);
        
    }];
}

#pragma mark 支付宝支付--生成支付宝订单
- (void)alipay:(NSString *)tradeCode {
//    __weak typeof(self) weakSelf = self;
//    
//    AlipayOrder *aliOrder = [[AlipayOrder alloc] init];
//    aliOrder.partner = AlipayPartner;
//    aliOrder.seller = AlipaySeller;
//    aliOrder.tradeNO = traderCode;//订单ID（由商家自行制定）
//    aliOrder.productName = @"蓝松医生服务"; //商品标题
//    aliOrder.productDescription = @"蓝松医生订单服务"; //商品描述
//    aliOrder.amount = [NSString stringWithFormat:@"%.2f",weakSelf.price.floatValue]; //商品价格
//    aliOrder.notifyURL =  @"http://www.lansongys.com"; //回调URL
//    
//    aliOrder.service = @"mobile.securitypay.pay";
//    aliOrder.paymentType = @"1";
//    aliOrder.inputCharset = @"utf-8";
//    aliOrder.itBPay = @"30m";
//    aliOrder.showUrl = @"m.alipay.com";
//    
//    
//    ZZLog(@"%@",aliOrder);
//    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//    NSString *appScheme = @"BEIYIPAY";
//    
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [aliOrder description];
//    
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(AlipayRSA_PrivateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
    
    
    __weak typeof(self) weakSelf = self;
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    AlipayOrder *aliOrder = [[AlipayOrder alloc] init];
    aliOrder.partner = AlipayPartner;
    aliOrder.seller = AlipaySeller;
    aliOrder.tradeNO = tradeCode; //订单ID（由商家自行制定）
    aliOrder.productName = @"蓝松医生服务"; //商品标题
    aliOrder.productDescription = @"蓝松医生订单服务"; //商品描述
    aliOrder.amount = [NSString stringWithFormat:@"%.2f",[[_price substringFromIndex:1] floatValue]]; //商品价格
    aliOrder.notifyURL = @"http://www.lansongys.com"; //回调URL
    
    aliOrder.service = @"mobile.securitypay.pay";
    aliOrder.paymentType = @"1";
    aliOrder.inputCharset = @"utf-8";
    aliOrder.itBPay = @"30m";
    aliOrder.showUrl = @"m.alipay.com";
    
    
    ZZLog(@"%@",aliOrder);
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"BEIYIPAY";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [aliOrder description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(AlipayRSA_PrivateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
    
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            ZZLog(@"支付宝----支付结果---reslut = %@",resultDic);
            
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {// 支付成功
                [MBProgressHUD showSuccess:@"支付成功"];
                // 跳转到上一界面
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
                
            }else {// 支付失败
                ZZLog(@"----支付宝-支付失败----");
                [MBProgressHUD showError:@"支付失败，请重试！"];
            }
        }];
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
            
            [MBProgressHUD showSuccess:@"支付成功"];
            
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


@end
