//
//  GetOrderDetailVC.m
//  BeiYi
//
//  Created by Joe on 15/6/26.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "GetOrderDetailVC.h"
#import "PayCell.h"
#import "Common.h"
#import "SubmitController.h"
#import "HosInfoCell.h"
#import "OrderNumCell.h"
#import "AttendanceTimeCell.h"
#import "AttendanceInfoCell.h"
#import "UIButton+WebCache.h"

@interface GetOrderDetailVC ()<UIAlertViewDelegate,AttendanceInfoCellDelegate>
@property (nonatomic, strong) UIButton *imageBgView;

@end

@implementation GetOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.基本设置
    self.view.backgroundColor = ZZColor(245, 245, 245, 1);
    self.title = @"抢单详情";
    
    // 2.设置tableView
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 2*ZZMarins, 0);
    
    switch ([self.orderInfos[@"order_status"] intValue]) {
//        case 3:// 待付款：已经单独处理
//            break;
        case 4:// 已付款
             // 已付款，需要继续完成交易——>提交凭证
            self.tableView.tableFooterView = [self footViewCreatedWithBtnTitle:@"提交凭证"];
            break;
            
        case 5:// （对方）申请退单中
            // 进入详情显示同意退单还是不同意退单
            self.tableView.tableFooterView = [self footViewDoubleBtn];
            break;
            
        case 6:// 拒绝退单
            // 已经拒绝对方退单，需要继续完成交易——>提交凭证
            self.tableView.tableFooterView = [self footViewCreatedWithBtnTitle:@"提交凭证"];
            break;
            
        case 7:// 凭证已提交
                self.tableView.tableFooterView = [[UIView alloc] init];// 隐藏tableview剩余部分
                break;

        case 8:// 凭证被拒绝
                self.tableView.tableFooterView = [[UIView alloc] init];// 隐藏tableview剩余部分
                break;
            
        case 9:// 交易完成
                self.tableView.tableFooterView = [[UIView alloc] init];// 隐藏tableview剩余部分
                break;
            
        case 10:// 交易关闭
                self.tableView.tableFooterView = [[UIView alloc] init];// 隐藏tableview剩余部分
                break;
            
        case 11:// 待评价（等待对方评价）
                self.tableView.tableFooterView = [[UIView alloc] init];// 隐藏tableview剩余部分
                break;
    }
}

#pragma mark - 返回tableView的footView
- (UIView *)footViewCreatedWithBtnTitle:(NSString *)title {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), SCREEN_WIDTH, ZZBtnHeight)];
    
    CGFloat x = ZZMarins;
    CGFloat w = (SCREEN_WIDTH - 2*ZZMarins);
    
    // 按钮
    UIButton *btn = [ZZUITool buttonWithframe:CGRectMake(x, 20, w, ZZBtnHeight) title:title titleColor:nil backgroundColor:ZZButtonColor target:self action:@selector(payBtnClicked) superView:footView];
    btn.layer.cornerRadius = 3.0f;

    self.tableView.contentSize = CGSizeMake(1, CGRectGetMaxY(btn.frame)+10);

    return footView;
}

#pragma mark - 返回双按钮的footView
- (UIView *)footViewDoubleBtn {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), SCREEN_WIDTH, ZZBtnHeight)];
    
    CGFloat x = ZZMarins;
    CGFloat btnW = ((SCREEN_WIDTH - 2*ZZMarins)-ZZMarins)/2;
    
    // 同意-按钮
    UIButton *btn1 = [ZZUITool buttonWithframe:CGRectMake(x, 20, btnW, ZZBtnHeight) title:@"同意" titleColor:nil backgroundColor:ZZButtonColor target:self action:@selector(agreeBtnClicked) superView:footView];
    btn1.layer.cornerRadius = 3.0f;

    // 不同意-按钮
    UIButton *btn2 = [ZZUITool buttonWithframe:CGRectMake(2*x +btnW, 20, btnW, ZZBtnHeight) title:@"不同意" titleColor:nil backgroundColor:ZZButtonColor target:self action:@selector(disAgreeBtnClicked) superView:footView];
    btn2.layer.cornerRadius = 3.0f;

    return footView;
}

#pragma mark - 监听 “支付按钮” 点击
- (void)payBtnClicked {
    ZZLog(@"~-----#$!$#^$!#$#^!#-----~");
    
    switch ([self.orderInfos[@"order_status"] intValue]) {
            
//        case 3:// 待付款：(已经单独处理)
//            break;
            
        case 4:// 已付款
            [self submitProof];// 提交凭证
            break;
            
        case 5:// 申请退单中
            // （按钮已隐藏）(已经单独处理)
            break;
            
        case 6:// 拒绝退单
            [self submitProof];// 提交凭证
            break;
            
        case 7:// 凭证已提交
            // （按钮已隐藏）
            break;
            
        case 8:// 凭证被拒绝
            // （按钮已隐藏）(已经单独处理)
            break;
            
        case 9:// 交易完成
            // （按钮已隐藏）
            break;
            
        case 10:// 交易关闭
            // （按钮已隐藏）
            break;
        
        case 11:// 待评价
            // （按钮已隐藏）
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 监听 “提交凭证” 点击
- (void)submitProof {
    // 进入提交凭证界面，选择相关数据，点击提交凭证
    SubmitController *submitVc = [[SubmitController alloc] init];
    submitVc.orderCode = self.orderInfos[@"order_code"];
    [self.navigationController pushViewController:submitVc animated:YES];
}

#pragma mark - 监听 “同意-按钮” 点击
- (void)agreeBtnClicked {
    // 补偿金 ＝ 订单价格 * 退还比例
    CGFloat refundPrice = [_orderInfos[@"refund_info"][@"refund_price"] floatValue];
    ZZLog(@"---refund_price---%.2f",refundPrice);
    NSString *alertMsg = [NSString stringWithFormat:@"您将获得%.2f元补偿金",refundPrice];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:alertMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"同意", nil];
    [alert show];
}

#pragma mark - 监听 “不同意-按钮” 点击
- (void)disAgreeBtnClicked {
    // 点击同意/不同意 按钮连接网络请求(tag = 1-同意 0-不同意)
    [self agreeHttploadWithTag:0];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { //点击了确认按钮
        
        // 点击同意/不同意 按钮连接网络请求(tag = 1-同意 0-不同意)
        [self agreeHttploadWithTag:1];
    }
}

#pragma mark - 点击同意/不同意 按钮连接网络请求
// tag = 1-同意 0-不同意
- (void)agreeHttploadWithTag:(int)tag {
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/confirm_refund",BASEURL]; // 确认退单接口
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];// 登录token
    [params setObject:self.orderInfos[@"order_code"] forKey:@"order_code"];// 订单编号
    
    // 确认结果 1-是 0-否
    [params setObject:[NSString stringWithFormat:@"%d",tag] forKey:@"result_flag"];
    
    __weak typeof(self) weakSelf = self;
    
    // 2.发送post请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        
        // 2.1隐藏遮盖
        [MBProgressHUD hideHUD];
        
        // 2.2获取操作是否成功
        NSDictionary *resultDict = responseObj[@"result"];
        ZZLog(@"---获取我的抢单---%@",resultDict);
        
        if ([responseObj[@"code"] isEqual:@"0000"]) {// 操作成功
            [MBProgressHUD showSuccess:responseObj[@"message"]];
            
            [weakSelf.navigationController popToViewController:weakSelf.navigationController.viewControllers[1] animated:YES];
            
        }else {// 操作失败
            [MBProgressHUD showError:responseObj[@"message"]];
            
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"抢单---%@",error);
        
        // 隐藏遮盖
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"发生错误，请重试"];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else {
        int stateValue = [self.orderInfos[@"order_status"] intValue];
        if (stateValue == 7 || stateValue == 9) {// 7——>对方已提交凭证，可以看到对方凭证；9——>交易完成，可以看到完成信息
            return 4;
            
        }else {
            return 3;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {// 第一组三行分别显示医院，科室，医生
        HosInfoCell *cell = [HosInfoCell cellWithTableView:tableView];
        
        if (indexPath.row == 0) {
            cell.lblName.text = @"医 院";
            cell.lblDetailName.text = _orderInfos[@"hospital_name"];
            return cell;
            
        } else if (indexPath.row == 1) {
            cell.lblName.text = @"科 室";
            cell.lblDetailName.text = _orderInfos[@"department_name"];
            return cell;
            
        }else {
            cell.lblName.text = @"医  生";
            if (![_orderInfos[@"doctor_name"] isEqual:[NSNull null]]){
                cell.lblDetailName.text = _orderInfos[@"doctor_name"];

            }
            return cell;
        }
    }else {// 第二组cell
        
        if (indexPath.row == 0) {// 就诊人信息
            PayCell *cell = [PayCell cellWithTableView:tableView];
            cell.lbl2Detail.text = _orderInfos[@"human"][@"name"];
            cell.lbl3.text = [NSString stringWithFormat:@"身份证号: %@",_orderInfos[@"human"][@"id_card"]];
            cell.lbl4.text = [NSString stringWithFormat:@"手机号码: %@",_orderInfos[@"human"][@"mobile"]];
            
            if ([_orderInfos[@"human"][@"sex"] isEqual:@1]) {
                cell.lbl5.text = @"性别：男";
            }else {
                cell.lbl5.text = @"性别：女";
            }
            
            return cell;
            
        }
        else if (indexPath.row == 1) {// 就诊时间
            AttendanceTimeCell *cell = [AttendanceTimeCell cellWithTableView:tableView];
            
            cell.lblBeginTime.text = _orderInfos[@"start_time"];
            cell.lblEndTime.text = _orderInfos[@"end_time"];
            
            if ([_orderInfos[@"order_status"] intValue] == 5) {// 申请退单
                
                cell.lblTip.hidden = NO;
                cell.lblTip.text = @"对方正在申请退单";
                cell.lblType.hidden = NO;
                cell.lblType.text = [NSString stringWithFormat:@"如果您同意退单，将获得%.2f元补偿金",[_orderInfos[@"refund_info"][@"refund_price"] floatValue]];

            }
            return cell;
            
        }
        else if (indexPath.row == 2) {// 当状态值为7或者9时，显示的就诊信息，其余情况下显示订单号和价格
            
            // 状态值
            int state = [_orderInfos[@"order_status"] intValue];
            
            if (state == 7|| state == 8|| state == 9) {// 显示就诊信息
                
                AttendanceInfoCell *cell = [AttendanceInfoCell cellWithTableView:tableView];
                cell.delegate = self;
                
                // 文字说明
                if (![_orderInfos[@"over_over"][@"memo"] isEqual:[NSNull null]]) {// 如果文字说明返回不为null
                    cell.lblWord.hidden = NO;
                    cell.lblWord.text = [NSString stringWithFormat:@"文字说明：%@",_orderInfos[@"over_over"][@"memo"]];
                }
                
                // 取号时间
                cell.lblTime.text = _orderInfos[@"over_over"][@"take_time"];
                
                if (![_orderInfos[@"over_over"][@"images"] isEqual:[NSNull null]]) {// 如果 图片数组 返回不为null
                    cell.lblIconTip.hidden = NO;
                    cell.icon.hidden = NO;
                    NSString *urlStr = [_orderInfos[@"over_over"][@"images"] lastObject];
                    [cell.icon sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:nil];
                }
                
                return cell;
                
            }else {// 显示订单号
                OrderNumCell *cell = [OrderNumCell cellWithTableView:tableView];
                cell.lblOrderNum.text = [NSString stringWithFormat:@"订单号：%@",self.orderInfos[@"order_code"]];
                cell.lblPrice.text = @"价格￥";
                cell.lblPriceDetail.text = [NSString stringWithFormat:@"%.2f",[self.orderInfos[@"price"] floatValue]];
                
                return cell;
            }
            
        }
        else {// 当状态值为7或者9时，才显示该行
            OrderNumCell *cell = [OrderNumCell cellWithTableView:tableView];
            cell.lblOrderNum.text = [NSString stringWithFormat:@"订单号：%@",self.orderInfos[@"order_code"]];
            cell.lblPrice.text = @"价格￥";
            cell.lblPriceDetail.text = [NSString stringWithFormat:@"%.2f",[self.orderInfos[@"price"] floatValue]];
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
        
    }else {
        if (indexPath.row == 0) {// 就诊人信息
            return 116;
            
        }else if (indexPath.row == 1) {// 就诊时间
            if ([_orderInfos[@"order_status"] intValue] == 5) {// 申请退单
                return 120;
                
            }else {
                return 66;
            }
            
        }else if (indexPath.row == 2){// 该行cell，当状态值为7或者9时，显示的就诊信息，其余情况下显示订单号和价格
            
            int state = [_orderInfos[@"order_status"] intValue];
            if (state == 7|| state == 8|| state == 9) {// 显示就诊信息
                //                return 150;// 动态返回
                AttendanceInfoCell *cell =  (AttendanceInfoCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
                
                if ([_orderInfos[@"over_over"][@"images"] isEqual:[NSNull null]]) {// 没有图片凭证
                    
                    CGRect rect = cell.frame;
                    
                    if ([_orderInfos[@"over_over"][@"memo"] isEqual:[NSNull null]]) {// 没有图片凭证，没有文字描述
                        
                        rect.size.height = 66;
                        cell.frame = rect;
                        
                    }else {// 没有图片凭证，有文字描述
                        CGSize lblWordSize = CGSizeMake(SCREEN_WIDTH - 15*2, 10000);// 高度自适应
                        CGSize lblWordSizeNew = [_orderInfos[@"over_over"][@"memo"] sizeWithFont:[UIFont systemFontOfSize:12.5] constrainedToSize:lblWordSize lineBreakMode:NSLineBreakByWordWrapping];
                        
                        rect.size.height = 66 + lblWordSizeNew.height;
                        cell.frame = rect;
                    }
                    
                }else {// 有图片凭证
                    
                    CGRect rect = cell.frame;
                    
                    if ([_orderInfos[@"over_over"][@"memo"] isEqual:[NSNull null]]) {// 有图片凭证，没有文字描述
                        
                        rect.size.height = 110;
                        cell.frame = rect;
                        
                    }else {// 有图片凭证，有文字描述
                        CGSize lblWordSize = CGSizeMake(SCREEN_WIDTH - 15*2, 10000);// 高度自适应
                        CGSize lblWordSizeNew = [_orderInfos[@"over_over"][@"memo"] sizeWithFont:[UIFont systemFontOfSize:12.5] constrainedToSize:lblWordSize lineBreakMode:NSLineBreakByWordWrapping];
                        rect.size.height = 110 + lblWordSizeNew.height;
                        cell.frame = rect;
                    }
                    
                }
                
                ZZLog(@"----cell.frame.size.height----%f",cell.frame.size.height);
                
                return cell.frame.size.height;
                
            }else {// 显示订单号
                return 66;
            }
            
        }else {// 当状态值为7或者9时，才显示该行
            return 66;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 20;

    }else {
        return 0.01;
    }
}


#pragma mark - AttendanceInfoCellDelegate
- (void)attendanceInfoCellIconBtnClicked:(AttendanceInfoCell *)cell {
    
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imgBtn.frame = self.tableView.frame;
    imgBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [imgBtn setImage:cell.icon.imageView.image forState:UIControlStateNormal];
    imgBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imgBtn addTarget:self action:@selector(clearImage) forControlEvents:UIControlEventTouchUpInside];
    imgBtn.adjustsImageWhenHighlighted = NO;
    [self.tableView addSubview:imgBtn];
    
    self.imageBgView = imgBtn;
    
}

- (void)clearImage {
    [self.imageBgView removeFromSuperview];
    self.imageBgView = nil;
}

@end
