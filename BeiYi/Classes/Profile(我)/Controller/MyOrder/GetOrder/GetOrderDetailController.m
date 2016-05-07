//
//  getOrderDetailController.m
//  BeiYi
//
//  Created by Joe on 15/6/25.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "GetOrderDetailController.h"
#import "LSSelectPayModeController.h"
#import "HosInfoCell.h"
#import "OrderNumCell.h"
#import "Common.h"

@interface GetOrderDetailController ()

@end

@implementation GetOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.基本设置
    self.view.backgroundColor = ZZColor(245, 245, 245, 1);
    self.title = @"抢单详情";
    self.tableView.tableFooterView = [self footViewCreated];
}

#pragma mark - 返回tableView的footView
- (UIView *)footViewCreated {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), SCREEN_WIDTH, 60)];
    
    CGFloat x = ZZMarins;
    CGFloat w = (SCREEN_WIDTH - 2*ZZMarins);
    
    // 按钮
    UIButton *btn = [ZZUITool buttonWithframe:CGRectMake(x, 20, w, ZZBtnHeight) title:@"提交保证金" titleColor:nil backgroundColor:ZZButtonColor target:self action:@selector(payBtnClicked) superView:footView];
    btn.layer.cornerRadius = 3.0f;

    return footView;
}

#pragma mark - 监听 提交保证金-按钮 点击
- (void)payBtnClicked {
    // 1.跳转到选择支付界面
    LSSelectPayModeController *selectPayModeVc = [[LSSelectPayModeController alloc] init];
    
    // 2.传值：保证金金额、订单编号
    selectPayModeVc.price = [NSString stringWithFormat:@"%.2f 元",[self.orderInfos[@"price"] floatValue]];
    selectPayModeVc.orderCode = self.orderInfos[@"order_code"];
    selectPayModeVc.payType = @"4";
    
    [self.navigationController pushViewController:selectPayModeVc animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![_orderInfos[@"doctor_name"] isEqual:[NSNull null]]) {
        return 4;
    
    }else {
        return 3;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HosInfoCell *cell = [HosInfoCell cellWithTableView:tableView];
    
    if (indexPath.row == 0) {
        cell.lblName.text = @"医 院";
        cell.lblDetailName.text = _orderInfos[@"hospital_name"];
        return cell;
        
    } else if (indexPath.row == 1) {
        cell.lblName.text = @"科 室";
        cell.lblDetailName.text = _orderInfos[@"department_name"];
        return cell;
        
    }else if (indexPath.row == 2) {
        
        if (![_orderInfos[@"doctor_name"] isEqual:[NSNull null]]) {
            cell.lblName.text = @"医  生";
            cell.lblDetailName.text = _orderInfos[@"doctor_name"];
            return cell;
        
        }else {// order_type ＝ 3-床位安排时，不显示医生
            OrderNumCell *cell = [OrderNumCell cellWithTableView:tableView];
            cell.lblOrderNum.text = [NSString stringWithFormat:@"订单号：%@",self.orderInfos[@"order_code"]];
            cell.lblPrice.text = @"价格￥";
            cell.lblPriceDetail.text = [NSString stringWithFormat:@"%.2f",[self.orderInfos[@"price"] floatValue]];
            
            return cell;
        }

    }else {
        OrderNumCell *cell = [OrderNumCell cellWithTableView:tableView];
        cell.lblOrderNum.text = [NSString stringWithFormat:@"订单号：%@",self.orderInfos[@"order_code"]];
        cell.lblPrice.text = @"价格￥";
        cell.lblPriceDetail.text = [NSString stringWithFormat:@"%.2f",[self.orderInfos[@"price"] floatValue]];
        
        return cell;
    }
}

- (OrderNumCell *)getOrderNumCellWithTableView:(UITableView *)tableView {
    OrderNumCell *cell = [OrderNumCell cellWithTableView:tableView];
    cell.lblOrderNum.text = [NSString stringWithFormat:@"订单号：%@",self.orderInfos[@"order_code"]];
    cell.lblPrice.text = @"价格￥";
    cell.lblPriceDetail.text = [NSString stringWithFormat:@"%.2f",[self.orderInfos[@"price"] floatValue]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

@end
