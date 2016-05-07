//
//  LSRechargeViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/10.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSRechargeViewController.h"
#import "Common.h"
#import "UIBarButtonItem+Extension.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AlipayOrder.h"
#import "DataSigner.h"

@interface LSRechargeViewController ()

/**  */
@property (weak, nonatomic) IBOutlet UITextField *addPriceTextFeild;


@end

@implementation LSRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置UI
    [self setUI];
    
    // 设置textField的属性
    _addPriceTextFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
    _addPriceTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    
}

- (void)setUI {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.text = @"余额充值";
    titleLabel.textColor = ZZTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    // 2. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
}

- (void)navBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rechargeBtnAction:(UIButton *)sender {
    
    [self.addPriceTextFeild resignFirstResponder];
    
    if ([self.addPriceTextFeild.text floatValue] < 1.0f) {
        [MBProgressHUD showError:@"请输入正确的价格(金额必须大于1元)"];
        
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/trader/recharge",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary]
    ;
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:self.addPriceTextFeild.text forKey:@"price"];// 充值金额
    [params setObject:@"1" forKey:@"pay_source"];// 付款源1-支付宝
    
    ZZLog(@"%@",params);
    // 获取订单交易号
    __weak typeof(self) wSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"~~--responseObj~%@",responseObj);
        
        // 判断是否成功获取交易单号
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {// 成功获取订单编号
            ZZLog(@"~~成功获取交易单号--orderCode~%@",responseObj[@"result"]);
            
            NSString *tradeCode = responseObj[@"result"];
            
            // 2.1 成功获取，则进行点击之后的网络链接
            [wSelf alipayWithTradeCode:tradeCode];// 用支付宝进行支付
            
        }else {// 获取订单编号失败
            // 2.2 获取失败,提示获取失败
            [MBProgressHUD showError:responseObj[@"message"] toView:wSelf.view];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"~~~%@",error);
        
    }];
}

#pragma mark 支付宝支付--生成支付宝订单
- (void)alipayWithTradeCode:(NSString *)tradeCode {
    
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
    aliOrder.amount = [NSString stringWithFormat:@"%.2f",[self.addPriceTextFeild.text floatValue]]; //商品价格
    aliOrder.notifyURL = @"http://www.lansongys.com"; //回调URL
    
    aliOrder.service = @"mobile.securitypay.pay";
    aliOrder.paymentType = @"1";
    aliOrder.inputCharset = @"utf-8";
    aliOrder.itBPay = @"30m";
    aliOrder.showUrl = @"m.alipay.com";
    
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
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD showSuccess:@"充值成功"];
                
            }else {// 支付失败
                ZZLog(@"----支付宝-支付失败----");
                [MBProgressHUD showError:@"充值失败，请重试！"];
            }
        }];
    }
}

#pragma mark - 拦截view的触摸动作
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
