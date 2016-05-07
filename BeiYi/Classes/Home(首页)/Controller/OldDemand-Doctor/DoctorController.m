//
//  DoctorController.m
//  BeiYi
//
//  Created by Joe on 15/5/18.
//  Copyright (c) 2015年 Joe. All rights reserved.
//
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]

#import "DoctorController.h"
#import "Common.h"
#import "MJRefresh.h"
#import "LSRefreshGifHeader.h"
#import "DoctorCell.h"
#import "Doctor.h"
#import "UIImageView+WebCache.h"


@interface DoctorController ()
@property (nonatomic, strong) NSMutableArray *arrDoctor;

@end

@implementation DoctorController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.UI设置
    self.title = @"医生选择";
    self.tableView.rowHeight = 80;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    // 2.下拉刷新
    // 普通刷新
    [self addHeaderRefresh];
    
    // 3.加载网络请求
    [self loadHttpRequest];
}

#pragma mark - 普通Header刷新
- (void)addHeaderRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [LSRefreshGifHeader headerWithRefreshingBlock:^{
        // 1.清除所有数据
        [weakSelf.arrDoctor removeAllObjects];
        
        // 2.加载网络请求
        [weakSelf loadHttpRequest];
        
        // 3.拿到当前的下拉刷新控件，结束刷新状态
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    // 4.首次进入页面马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 加载网络请求
- (void)loadHttpRequest {
//    [MBProgressHUD showMessage:@"加载中..."];
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/resource/doctors",BASEURL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.arrIds[0] forKey:@"hospital_id"];
    [dict setObject:self.arrIds[1] forKey:@"department_id"];
    
    __weak typeof(self) weakSelf = self;
    
    // 2.发送post请求
    [ZZHTTPTool post:urlStr params:dict success:^(NSDictionary *responseDict) {
        ZZLog(@"----responseDict---%@", responseDict);
        
        NSArray *arrResult = responseDict[@"result"];
//        ZZLog(@"----arrResult---%@", arrResult);
        
        if (arrResult.count) {
            // 1.隐藏遮盖
            [MBProgressHUD hideHUD];
            
            // 2.加载医院列表
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in arrResult) {
                Doctor *doctor = [Doctor doctorlWithDict:dict];
                [array addObject:doctor];
            }
            weakSelf.arrDoctor = array;

            // 3.刷新列表
            [weakSelf.tableView reloadData];
            
        }else {
            // 1.隐藏遮盖
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"没有对应的医生"];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"%@",error);
        
        // 1.隐藏遮盖
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查您的网络"];
    }];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrDoctor.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DoctorCell *cell = [DoctorCell cellWithTableView:tableView];
    
    if (indexPath.row < self.arrDoctor.count) {
        cell.doctor = self.arrDoctor[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.准备参数（医生id）
    Doctor *doctor = self.arrDoctor[indexPath.row];

    // 3.跳转界面
//    DoctorDetailController *docDetailVc = [[DoctorDetailController alloc] init];
//    docDetailVc.doctorID = [NSString stringWithFormat:@"%d",doctor.doctor_id];
//    [self.navigationController pushViewController:docDetailVc animated:YES];
}

@end
