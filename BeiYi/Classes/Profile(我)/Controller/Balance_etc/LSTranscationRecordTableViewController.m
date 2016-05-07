//
//  LSTranscationRecordTableViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/2/17.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSTranscationRecordTableViewController.h"
#import "LSTransRecordTableViewCell.h"
#import "LSRecord.h"
#import "LSRefreshGifHeader.h"
#import "MJRefresh.h"
#import "Common.h"


@interface LSTranscationRecordTableViewController ()

// 交易记录数组
@property (nonatomic,strong) NSMutableArray *recordArray;

@end

@implementation LSTranscationRecordTableViewController

static NSString *const reuseIdentifier = @"TransRecordTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"LSTransRecordTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    // 普通的header刷新
    [self addHeaderRefresh];
    
    // 普通的footer刷新
    [self addFooterRefresh];
}

- (void)setUI {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.text = @"交易记录";
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.recordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSTransRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LSTransRecordTableViewCell class]) forIndexPath:indexPath];
    
    if (indexPath.row < self.recordArray.count) {
        
        cell.record = self.recordArray[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 59;
}

#pragma mark - 普通的header刷新
- (void)addHeaderRefresh {
    
    __weak typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [LSRefreshGifHeader headerWithRefreshingBlock:^{
        
        // 1. 清楚所有数据
        [weakSelf.recordArray removeAllObjects];
        // 2. 加载网络请求
        [weakSelf loadHeaderHttpRequest];
        // 3. 拿到当前的下拉刷新控件，结束当前刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    // 4.首次进入页面马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - 普通的footer刷新
- (void)addFooterRefresh {
    
    __weak typeof(self)weakSelf = self;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        // 1. 加载网络请求
        [weakSelf loadFooterHttpRequest];
        // 2. 拿到当前的上拉加载控件，技术当前刷新
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - 下拉刷新网络请求
- (void)loadHeaderHttpRequest {
    
    // 1. 请求网址
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/trader/flow_list",BASEURL];
    
    // 2. 设置请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:@1 forKey:@"pn"];
    
    ZZLog(@"---params = %@",params);
    
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(id responseObj) {
        ZZLog(@"---responseObj = %@",responseObj);
        
        NSArray *dataList = responseObj[@"result"][@"dataList"];
        
        if (!dataList.count) {
            // 隐藏遮盖
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [weakSelf.recordArray removeAllObjects];
            [weakSelf.tableView reloadData];
            [MBProgressHUD showError:@"暂无交易记录" toView:weakSelf.view];
        }
        else {
            
            NSMutableArray *tempArr = [NSMutableArray array];
            
            tempArr = [LSRecord mj_objectArrayWithKeyValuesArray:dataList];
            
            weakSelf.recordArray = tempArr;
            
            // 隐藏遮盖
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"---error = %@",error);
        
        // 隐藏遮盖
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
    }];
}

#pragma mark - 上拉加载网络请求
- (void)loadFooterHttpRequest {
    
    // 2.发送网络请求
    // 2.1准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/trader/flow_list",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];// 登录传token
    
    /** 当前页码 */
    NSUInteger currentPage = 0;
    ZZLog(@"%ld",(unsigned long)self.recordArray.count);
    if (self.recordArray.count <10) {// 当首页显示的数量少于10就说明数据已经取光，直接让current的数值超过1
        currentPage = 2;
        
    }else {
        
        if ((((CGFloat)(self.recordArray.count) / (CGFloat)10)) - (self.recordArray.count / 10) == 0) {
            currentPage = self.recordArray.count / 10 + 1;
            ZZLog(@"%lu",(unsigned long)currentPage);
        }
        if ((((CGFloat)(self.recordArray.count) / (CGFloat)10)) - (self.recordArray.count / 10) > 0) {
            currentPage = self.recordArray.count/10 +2;
            ZZLog(@"%lu",(unsigned long)currentPage);
        }
        
    }
    
    [params setObject:[NSString stringWithFormat:@"%lu",(unsigned long)currentPage] forKey:@"pn"];// 页码
    
    __weak typeof(self) weakSelf = self;
    
    // 2.2发送post请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"%@",params);
        
        NSArray *dataList = responseObj[@"result"][@"dataList"];
        
        if (!dataList.count) {
            
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            
            NSMutableArray *tempArr = [NSMutableArray array];
            
            tempArr = [LSRecord mj_objectArrayWithKeyValuesArray:dataList];
            
            [weakSelf.recordArray addObjectsFromArray:tempArr];
            
            // 隐藏遮盖
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.tableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        ZZLog(@"---%@",error);
        
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)recordArray {
    
    if (_recordArray == nil) {
        self.recordArray = [NSMutableArray array];
    }
    return _recordArray;
}

@end
