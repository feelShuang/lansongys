//
//  OrderTimeListController.m
//  BeiYi
//
//  Created by Joe on 15/7/2.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "OrderTimeListController.h"
#import "Common.h"
#import "OrderTimeCell.h"

@interface OrderTimeListController ()<OrderTimeCellDelegate>
@property (nonatomic, strong) NSMutableArray *times;

@end

@implementation OrderTimeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.基本设置
    self.view.backgroundColor = ZZColor(245, 245, 245, 1);
    self.title = @"订单时间列表";
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self loadHttpRequest];
}

- (void)loadHttpRequest {
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/order_dates",BASEURL]; // 订单时间列表
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:self.orderCode forKey:@"order_code"];// 订单编号
    
    __weak typeof(self) weakSelf = self;
    
    // 2.发送网络请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"~~~%@~~~",responseObj);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {// 加载成功
            weakSelf.times = responseObj[@"result"];
            [weakSelf.tableView reloadData];
            
            [MBProgressHUD showSuccess:responseObj[@"message"] toView:weakSelf.view];

        }else {// 加载失败
            [MBProgressHUD showError:responseObj[@"message"] toView:weakSelf.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        ZZLog(@"~~~%@~~~",error);
        
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.times.count;
}

- (OrderTimeCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    OrderTimeCell *cell = [OrderTimeCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.textLabel.text = self.times[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - OrderTimeCellDelegate
- (void)orderTimeCellSelectedBtnMorning:(OrderTimeCell *)ordertimeCell {
    NSString *time= [NSString stringWithFormat:@"%@   上午",ordertimeCell.textLabel.text];
    
    if ([self.delegate respondsToSelector:@selector(OrderTimeListPassTime:timeSelected:)]) {
        [self.delegate OrderTimeListPassTime:time timeSelected:1];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)orderTimeCellSelectedBtnAfternoon:(OrderTimeCell *)ordertimeCell {
    NSString *time= [NSString stringWithFormat:@"%@   下午",ordertimeCell.textLabel.text];
    
    if ([self.delegate respondsToSelector:@selector(OrderTimeListPassTime:timeSelected:)]) {
        [self.delegate OrderTimeListPassTime:time timeSelected:2];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
