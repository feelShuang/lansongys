//
//  LSManagePatientViewController.m
//  BeiYi
//
//  Created by Joe on 15/5/21.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "LSManagePatientViewController.h"
#import "LSManagePatientTableViewCell.h"
#import "LSAddPatientController.h"
#import "LSEditPatientController.h"
#import "ProfileController.h"
#import "LSPatient.h"
#import "OrderInfo.h"
#import "LSRefreshGifHeader.h"
#import "MJRefresh.h"
#import "Common.h"


@interface LSManagePatientViewController ()<UIAlertViewDelegate>
/**
 *  存放就诊人模型 的数组
 */
@property (nonatomic, strong) NSMutableArray *patients;

@end

@implementation LSManagePatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI]; // 界面布局
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LSManagePatientTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LSManagePatientTableViewCell class])];
    
    // 设置statusBar的字体颜色 为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    // 设置navigationBar的颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#f5f6f7"]];
    
    // 添加刷新模块
    [self addHeaderRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     // 加载网络请求
    [self loadHttpRequest];
}

#pragma mark - 普通Header刷新
- (void)addHeaderRefresh {
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [LSRefreshGifHeader headerWithRefreshingBlock:^{
        // 1.清除所有数据
        [weakSelf.patients removeAllObjects];
        
        // 2.加载网络请求
        [weakSelf loadHttpRequest];
        
        // 3.拿到当前的下拉刷新控件，结束刷新状态
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 普通Footer刷新
- (void)addFooterRefresh {
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 1.清除所有数据
        [weakSelf.patients removeAllObjects];
        
        // 2.加载网络请求
        [weakSelf loadHttpRequest];
        
        // 3.拿到当前的上拉刷新控件，结束刷新状态
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 加载网络请求
- (void)loadHttpRequest {
    
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/visit_human/list",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:myAccount.token forKey:@"token"];
    
    __weak typeof(self) weakSelf = self;

    // 2.发送post请求
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        ZZLog(@"---哇哈哈哈---%@",responseObj);
        
        // 1.取到结果字典
        NSArray *resultArray = responseObj[@"result"];

        if (![responseObj[@"code"] isEqual:@"0000"]) {// 不存在就诊人信息
            
            [MBProgressHUD showError:responseObj[@"message"] toView:weakSelf.view];
            
        }else {
            // 1.取出数据
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *dict in resultArray) {
                LSPatient *patient = [LSPatient mj_objectWithKeyValues:dict];
                [tempArray addObject:patient];
            }
            weakSelf.patients = tempArray;
            
            // 2.刷新列表
            [weakSelf.tableView reloadData];
            if (!resultArray.count) {// 不存在就诊人信息 数量小于0
                
                [weakSelf addPatientAlert];
            }
        }

    } failure:^(NSError *error) {
        ZZLog(@"%@",error);
    }];
}

#pragma mark - 是否添加就诊人
- (void)addPatientAlert {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"没有就诊人，是否添加" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        LSAddPatientController *addPatientVC = [LSAddPatientController new];
        [self.navigationController pushViewController:addPatientVC animated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 界面布局
- (void)setupUI {
    // 1.设置基本信息
    self.view .backgroundColor = ZZBackgroundColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.text = @"就诊人管理";
    titleLabel.textColor = ZZTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;

    
    // 2.设置导航栏右侧按钮
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame = CGRectMake(0, 0, 30, 30);
    [btnAdd setImage:[UIImage imageNamed:@"tian_jia"] forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(gotoAdd) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    
    // 3. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
}

- (void)navBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 添加按钮点击监听
- (void)gotoAdd {
    ZZLog(@"===添加一个就诊人===");
    LSAddPatientController *addVc = [[LSAddPatientController alloc] init];
    [self.navigationController pushViewController:addVc animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.patients.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LSManagePatientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LSManagePatientTableViewCell class])];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row < self.patients.count) {

        cell.patient = self.patients[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[ProfileController class]]) {
        
        LSManagePatientTableViewCell *patientCell = [tableView cellForRowAtIndexPath:indexPath];
        
        LSEditPatientController *editPatientVC = [LSEditPatientController new];
        editPatientVC.patient = patientCell.patient;
        [self.navigationController pushViewController:editPatientVC animated:YES];
        
    } else {
        
        // 2.点击选中，返回前一页，并且传递数据
        LSPatient *patient = self.patients[indexPath.row];
        [OrderInfo shareInstance].patient_id = patient.patient_id;
        if ([self.delegate respondsToSelector:@selector(passPatientName:)]) {
            [self.delegate passPatientName:patient.name];
        }
        // 3.跳转界面
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
