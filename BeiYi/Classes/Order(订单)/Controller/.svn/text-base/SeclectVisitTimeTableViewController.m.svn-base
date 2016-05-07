//
//  SeclectVisitTimeTableViewController.m
//  BeiYi
//
//  Created by 刘爽 on 16/2/19.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "SeclectVisitTimeTableViewController.h"
#import "SelectVisitTimeTableViewCell.h"
#import "SeclectTimeTableViewCell.h"
#import "UpdateInfoViewController.h"
#import "Common.h"

@interface SeclectVisitTimeTableViewController ()

@property (nonatomic, strong) NSArray *timeListArray;

@end

@implementation SeclectVisitTimeTableViewController

static NSString *const reuseIdentifier = @"SelectVisitTimeTableViewCell";
static NSString *const Identifier = @"SeclectTimeTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置title
    self.title = @"选择时间";
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectVisitTimeTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SeclectTimeTableViewCell" bundle:nil] forCellReuseIdentifier:Identifier];
    
    
    // 请求时间列表
    [self loadHttpRequestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.timeListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.order_type isEqualToString:@"1"] || [self.order_type isEqualToString:@"4"]) {
        SelectVisitTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        [cell.amButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        // pmButton
        [cell.pmButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.timeLabel.text = self.timeListArray[indexPath.row];
        
        return cell;
    }
    else {
        SeclectTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
        [cell.seclectButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.timeStrLabel.text = self.timeListArray[indexPath.row];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}

#pragma mark - 监听按钮事件
- (void)buttonClickAction:(UIButton *)sender {

    if ([[[sender superview] superview] isKindOfClass:[SelectVisitTimeTableViewCell class]]) {
        ZZLog(@"---找到cell了");
    }
    if ([[[sender superview] superview] isKindOfClass:[SeclectTimeTableViewCell class]]) {
        ZZLog(@"---找到seclectCell了");
    }
    
    // 根据button的superView找到cell
    SelectVisitTimeTableViewCell *cell = (SelectVisitTimeTableViewCell *)[[sender superview] superview];
    SeclectTimeTableViewCell *seclectCell = (SeclectTimeTableViewCell *)[[sender superview] superview];
    // 根据tag值判断button
    if (sender.tag == 100) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(visitHospitalWithTime:)]) {
            NSString *timeStr = [NSString stringWithFormat:@"%@ 上午",cell.timeLabel.text];
            [self.delegate visitHospitalWithTime:timeStr];
            ZZLog(@"%@",timeStr);
        }
    }
    else if(sender.tag == 101) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(visitHospitalWithTime:)]) {
            NSString *timeStr = [NSString stringWithFormat:@"%@ 下午",cell.timeLabel.text];
            [self.delegate visitHospitalWithTime:timeStr];
        }
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(visitHospitalWithTime:)]) {
            NSString *timeStr = [NSString stringWithFormat:@"%@",seclectCell.timeStrLabel.text];
            [self.delegate visitHospitalWithTime:timeStr];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 加载网络请求，获取时间列表
- (void)loadHttpRequestData {
    
    // 添加遮盖
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    // 1. 准备请求网址
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/order_dates",BASEURL];
    
    // 2. 准备请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:self.order_code forKey:@"order_code"];
    
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(id responseObj) {
        ZZLog(@"--responseObj = %@",responseObj);
        
        // 隐藏遮盖
        [MBProgressHUD hideHUDForView:weakSelf.view  animated:YES];
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            NSArray *temp = responseObj[@"result"];
            
            self.timeListArray = temp;
            
            [weakSelf.tableView reloadData];
        }
        else {
            // 添加遮盖
            [MBProgressHUD showError:responseObj[@"message"] toView:weakSelf.view];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"--error = %@",error);
        // 隐藏遮盖
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
    }];
}

#pragma mark - 懒加载
- (NSArray *)timeListArray {
    
    if (_timeListArray == nil) {
        self.timeListArray = [NSArray array];
    }
    return _timeListArray;
}

@end
