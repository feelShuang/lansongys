//
//  LSFamousDoctorViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/3/23.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#define COVERVIEW_BACKGROUNDCOLOR ZZColor(102, 102, 102, 0.5)
#define TABLEVIEW_HIGHT 250
#define SELECTBUTTON_HIGHT 40
#define BUTTON_FONT 12
#define CELL_FONT 16

#import "LSFamousDoctorViewController.h"
#import "LSFamousDoctorTableViewCell.h"
#import "LSDoctorDetailViewController.h"
#import "LSPatientDoctor.h"
#import "LSDoctorLevels.h"
#import "Hospital.h"
#import "OrderInfo.h"
#import "Department.h"
#import "ChildDepartment.h"

#import "UIBarButtonItem+Extension.h"
#import "LSRefreshGifHeader.h"
#import <MJRefresh.h>
#import "Common.h"
#import <Masonry.h>



@interface LSFamousDoctorViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

/** 选择医院按钮 */
@property (nonatomic, strong) UIButton *hospitalBtn;
/** 选择医院按钮图片 */
@property (nonatomic, strong) UIImageView *hospitalImg;
/** 记录医院按钮点击次数 */
@property (nonatomic, assign) int countHospital;
/** 医院列表 */
@property (nonatomic, strong) UITableView *hospitalTableView;


/** 选择科室按钮 */
@property (nonatomic, strong) UIButton *departBtn;
/** 可是按钮图片 */
@property (nonatomic, strong) UIImageView *departImg;
/** 记录可是按钮点击次数 */
@property (nonatomic, assign) int countDepart;
/** 科室列表 */
@property (nonatomic, strong) UITableView *departTableView;
/** 子科室列表 */
@property (nonatomic, strong) UITableView *childDepartTableView;


/** 选择医生排序按钮 */
@property (nonatomic, strong) UIButton *levelBtn;
/** 选择医生图片 */
@property (nonatomic, strong) UIImageView *levelImg;
/** 记录医生排序点击次数 */
@property (nonatomic, assign) int countLevel;
/** 医生排序类型tableView */
@property (nonatomic, strong) UITableView *levelTableView;

/** 记录医院ID */
@property (nonatomic, copy)NSString *hospital_id;
/** 记录科室ID */
@property (nonatomic, copy)NSString *childDepart_id;
/** 记录医生级别 */
@property (nonatomic, copy)NSString *doctor_level;
/** 记录排序状态 */
@property (nonatomic, copy)NSString *sort;

/** 记录关键字 */
@property (nonatomic, copy)NSString *keyWord;

/** 医生列表 */
@property (nonatomic, strong) UITableView *famousDocTableView;

// 搜索框背景
@property (nonatomic, strong) UIView *searchBgView;
// 搜索框
@property (nonatomic, strong) UITextField *searchbar;
// 覆盖视图
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *tableBgView;

// NSArray 服务
@property (nonatomic, strong) NSArray *services;

// NSArray 医院名称数组
@property (nonatomic, strong) NSArray *hos_name;
// NSArray 医院id数组
@property (nonatomic, strong) NSArray *hos_ids;

/** NSArray 科室 */
@property (nonatomic, strong) NSArray *departments;
/** NSArray 子科室 */
@property (nonatomic, strong) NSArray *childDepartments;
/** NSArray 里面存放着若干个子科室的数据 */
@property (nonatomic, strong) NSArray *anyChildDepartments;

// NSArray 医生级别
@property (nonatomic, strong) NSArray *levels;
// NSArray 医生
@property (nonatomic, strong) NSMutableArray *doctors;

// 过滤的医生ID
@property (nonatomic, copy) NSString *filterIDs;

@end

@implementation LSFamousDoctorViewController
{
    NSUInteger _currentPage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZZBackgroundColor;
    
    _countHospital = 0;
    _countDepart = 0;
    _countLevel = 0;
    
    self.hospital_id = @"0";
    self.childDepart_id = @"0";
    self.doctor_level = @"0";
    self.sort = @"0";
    self.keyWord = @"";
    
    _currentPage = 1;
    
    // setUI
    [self setUI];
    
    // 添加医生列表
    [self addFamousDocList];
    
    // 注册cell
    [self.famousDocTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LSFamousDoctorTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LSFamousDoctorTableViewCell class])];

    // 添加刷新
    [self addHeaderRefreshWithHospital_id:self.hospital_id department_id:self.childDepart_id sort:self.sort order_type:self.order_type keyword:self.keyWord];
    [self addFooterRefreshWithHospital_id:self.hospital_id department_id:self.childDepart_id sort:self.sort order_type:self.order_type keyword:self.keyWord];

    // 3.根据下单类型加载网络请求，获取该类型下的全部医生
    [self loadHeaderHTTPForDoctorWithHospital_id:self.hospital_id department_id:self.childDepart_id sort:self.sort order_type:self.order_type keyword:self.keyWord];

    // 请求医院列表
    [self loadHTTPForHospital];
    
    // 4.加载科室列表
    [self loadHTTPForDepartWithHosID:@"0"];

}

- (void)setUI {
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    
    titleView.text = @"名医列表";
    titleView.textColor = [UIColor whiteColor];
    titleView.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = titleView;
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"famousDoc_sousuo"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchDoctorData) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    // 添加选择控件
    [self addSelectButtons];
}


#pragma mark 添加选择按钮
- (void)addSelectButtons {
    
    UIView *btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SELECTBUTTON_HIGHT)];
    btnBgView.backgroundColor = [UIColor whiteColor];
    
    // 1. 选择医院按钮
    self.hospitalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hospitalBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH / 3, SELECTBUTTON_HIGHT);
    self.hospitalBtn.titleLabel.font = [UIFont systemFontOfSize:BUTTON_FONT];
    [self.hospitalBtn setTitle:@"全部医院" forState:UIControlStateNormal];
    [self.hospitalBtn setTitleColor:ZZTitleColor forState:UIControlStateNormal];
    [self.hospitalBtn addTarget:self action:@selector(hospitalBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnBgView addSubview:self.hospitalBtn];
    
    self.hospitalImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_xia"]];
    self.hospitalImg.frame = CGRectMake(CGRectGetMaxX(self.hospitalBtn.frame) - 20, 18, 8, 4);
    [self.hospitalBtn addSubview:self.hospitalImg];
    
    // 添加分割线
    [ZZUITool lineVerticalWithPosition:CGPointMake(CGRectGetMaxX(_hospitalBtn.frame), 10) height:20 backGroundColor:ZZSeparateLineColor superView:btnBgView];
    
    // 2. 选择科室按钮
    self.departBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.departBtn.frame = CGRectMake(CGRectGetMaxX(_hospitalBtn.frame), 0, CGRectGetWidth(_hospitalBtn.frame), SELECTBUTTON_HIGHT);
    self.departBtn.titleLabel.font = [UIFont systemFontOfSize:BUTTON_FONT];
    [self.departBtn setTitle:@"全部科室" forState:UIControlStateNormal];
    [self.departBtn setTitleColor:ZZTitleColor forState:UIControlStateNormal];
    [self.departBtn addTarget:self action:@selector(departBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnBgView addSubview:self.departBtn];
    
    self.departImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_xia"]];
    self.departImg.frame = CGRectMake(CGRectGetMidX(self.hospitalImg.frame), CGRectGetMidY(self.hospitalImg.frame), CGRectGetWidth(self.hospitalImg.frame), CGRectGetHeight(self.hospitalImg.frame));
    [self.departBtn addSubview:self.departImg];
    
    // 添加分割线
    [ZZUITool lineVerticalWithPosition:CGPointMake(CGRectGetMaxX(_departBtn.frame), 10) height:20 backGroundColor:ZZSeparateLineColor superView:btnBgView];
    
    // 3. 选择医生级别按钮
    self.levelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.levelBtn.frame = CGRectMake(CGRectGetMaxX(_departBtn.frame), 0, CGRectGetWidth(_hospitalBtn.frame), SELECTBUTTON_HIGHT);
    self.levelBtn.titleLabel.font = [UIFont systemFontOfSize:BUTTON_FONT];
    [self.levelBtn setTitle:@"医生排序" forState:UIControlStateNormal];
    [self.levelBtn setTitleColor:ZZTitleColor forState:UIControlStateNormal];
    [self.levelBtn addTarget:self action:@selector(levelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnBgView addSubview:self.levelBtn];
    
    self.levelImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_xia"]];
    self.levelImg.frame = CGRectMake(CGRectGetMidX(self.hospitalImg.frame), CGRectGetMidY(self.hospitalImg.frame), CGRectGetWidth(self.hospitalImg.frame), CGRectGetHeight(self.hospitalImg.frame));
    [self.levelBtn addSubview:self.levelImg];
    
    // 添加边框
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, CGRectGetHeight(btnBgView.frame) - 1) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:btnBgView];
    
    [self.view addSubview:btnBgView];
}

#pragma mark 监听 选择医院按钮 点击事件
- (void)hospitalBtnClicked:(UIButton *)sender {
    [self removeBgView];
    _countHospital ++;
    if (_countHospital%2) {
        [self addBgView];// 添加遮盖
        // 设置图片
        [self setBtnImageWithBtn:sender];
        // 添加医院 tableView
        self.hospitalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TABLEVIEW_HIGHT) style:UITableViewStylePlain];
        self.hospitalTableView.tableFooterView = [[UIView alloc] init];
        self.hospitalTableView.delegate = self;
        self.hospitalTableView.dataSource = self;
        [self.tableBgView addSubview:self.hospitalTableView];
        
    }else {
        [self removeBgView];// 移除遮盖
        [sender setImage:[UIImage imageNamed:@"filter_xia"] forState:UIControlStateNormal];
    }
    
}

#pragma mark 监听 选择科室按钮 点击事件
- (void)departBtnClicked:(UIButton *)sender {
    ZZLog(@"--_countDepart--%d",_countDepart);
    [self removeBgView];
    
    _countDepart ++;
    // 设置图片
    [self setBtnImageWithBtn:sender];
    
    if (_countDepart%2) {
        [self addBgView];// 添加遮盖
        // 添加科室 tableview
        self.departTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.4, TABLEVIEW_HIGHT) style:UITableViewStylePlain];
        self.departTableView.tableFooterView = [[UIView alloc] init];
        self.departTableView.delegate = self;
        self.departTableView.dataSource = self;
        self.departTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableBgView addSubview:self.departTableView];
        
        // 添加子科室 tableview
        self.childDepartTableView= [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.4, 0, SCREEN_WIDTH*0.6, TABLEVIEW_HIGHT) style:UITableViewStylePlain];
        self.childDepartTableView.tableFooterView = [[UIView alloc] init];
        self.childDepartTableView.backgroundColor = ZZColor(244, 244, 244, 1);
        self.childDepartTableView.delegate = self;
        self.childDepartTableView.dataSource = self;
        self.childDepartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableBgView addSubview:self.childDepartTableView];
        
        
    }else {
        [self removeBgView];// 移除遮盖
        [sender setImage:[UIImage imageNamed:@"filter_xia"] forState:UIControlStateNormal];
    }
}

#pragma mark 监听 选择医生级别按钮 点击事件
- (void)levelBtnClicked:(UIButton *)sender {
    [self removeBgView];
    _countLevel ++;

    if (_countLevel%2) {
        [self addBgView];// 添加遮盖
        // 设置图片
        [self setBtnImageWithBtn:sender];
        // 添加医院 tableView
        self.levelTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TABLEVIEW_HIGHT) style:UITableViewStylePlain];
        // 1.去除tableView多余的分割线
        self.levelTableView.tableFooterView = [[UIView alloc] init];
        self.levelTableView.delegate = self;
        self.levelTableView.dataSource = self;
        [self.tableBgView addSubview:self.levelTableView];

    }else {
        [self removeBgView];// 移除遮盖
        [sender setImage:[UIImage imageNamed:@"filter_xia"] forState:UIControlStateNormal];
    }
}

#pragma mark - 设置按钮图片
- (void)setBtnImageWithBtn:(UIButton *)sender {
    
    if (sender == self.hospitalBtn) {
        self.hospitalImg.image = [UIImage imageNamed:@"filter_shang"];
        self.departImg.image = [UIImage imageNamed:@"filter_xia"];
        self.levelImg.image = [UIImage imageNamed:@"filter_xia"];
    } else if (sender == self.departBtn) {
        self.hospitalImg.image = [UIImage imageNamed:@"filter_xia"];
        self.departImg.image = [UIImage imageNamed:@"filter_shang"];
        self.levelImg.image = [UIImage imageNamed:@"filter_xia"];
    } else {
        self.hospitalImg.image = [UIImage imageNamed:@"filter_xia"];
        self.departImg.image = [UIImage imageNamed:@"filter_xia"];
        self.levelImg.image = [UIImage imageNamed:@"filter_shang"];
    }
}

#pragma mark 添加遮盖
/** 添加遮盖（遮盖上添加tableView）*/
- (void)addBgView {
    self.tableBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + CGRectGetHeight(_hospitalBtn.frame), SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableBgView.backgroundColor = COVERVIEW_BACKGROUNDCOLOR;
    UIView *clickedHiddenView = [ZZUITool viewWithframe:CGRectMake(0, TABLEVIEW_HIGHT, SCREEN_WIDTH, SCREEN_HEIGHT -TABLEVIEW_HIGHT) backGroundColor:[UIColor clearColor] superView:self.tableBgView];
    
    [clickedHiddenView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBgView)]];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_tableBgView];
}

#pragma mark 移除遮盖
/** 移除遮盖 */
- (void)removeBgView {
    
    [self.tableBgView removeFromSuperview];
    self.tableBgView = nil;
    
    self.countHospital = 0;
    self.countDepart = 0;
    self.countLevel = 0;
}

- (void)remove {
    [self.tableBgView removeFromSuperview];
    self.tableBgView = nil;
}

#pragma mark 加载网络请求获取医院
- (void)loadHTTPForHospital {
    
    // 2.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/resource/hospitals",BASEURL];
    
    __weak typeof(self) weakSelf = self;
    
    [ZZHTTPTool get:urlStr params:nil success:^(id responseObj) {
        ZZLog(@"---%@",responseObj);
        
        // 2.加载医院列表
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in responseObj[@"result"]) {
            Hospital *hospital = [Hospital hospitalWithDict:dict];
            [array addObject:hospital];
        }
        
        NSMutableArray *tempHos = [NSMutableArray array];// 医院名称
        [tempHos addObject:@"全部医院"];
        for (Hospital *hos in array) {
            [tempHos addObject:hos.short_name];
        }
        // 刷新tableView
        weakSelf.hos_name = tempHos;
        [weakSelf.hospitalTableView reloadData];
        
        NSMutableArray *tempHos_ids = [NSMutableArray array];// 医院id
        [tempHos_ids addObject:@"0"];// 全部医院
        for (Hospital *hos in array) {
            [tempHos_ids addObject:hos.hospital_id];
        }
        // 赋值
        weakSelf.hos_ids = tempHos_ids;
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请检查您的网络" toView:weakSelf.view];
        ZZLog(@"---%@",error);
        
    }];
}

#pragma mark - 添加医生tableView
- (void)addFamousDocList {
    
    if (self.tabBarController.selectedIndex == 1) {
        self.famousDocTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SELECTBUTTON_HIGHT + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - SELECTBUTTON_HIGHT - 49) style:UITableViewStylePlain];
    } else {
        self.famousDocTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SELECTBUTTON_HIGHT + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 104) style:UITableViewStylePlain];
    }
    
    // 去除多余的tableView分割线
    self.famousDocTableView.tableFooterView = [[UIView alloc] init];    
    // 设置背景色
    self.famousDocTableView.backgroundColor = ZZBackgroundColor;
    // 设置代理
    self.famousDocTableView.delegate = self;
    self.famousDocTableView.dataSource = self;
    [self.view addSubview:_famousDocTableView];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.hospitalTableView) {
        return self.hos_name.count;
    } else if (tableView == self.departTableView) {
        return self.departments.count;
    } else if (tableView == self.childDepartTableView) {
        return self.childDepartments.count;
    }
    else if (tableView == self.levelTableView) {
        return self.levels.count;
    }
    else {
        return self.doctors.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.hospitalTableView) { // 医院
        
        static NSString *ID = @"hosNameCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.textLabel.text = self.hos_name[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:CELL_FONT];
        cell.textLabel.textColor = ZZTitleColor;
        
        return cell;
    } else if (tableView == self.departTableView) { // 科室
        
        static NSString *ID = @"departNameCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }

        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_lan_tiao"]];
        cell.textLabel.text = self.departments[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:CELL_FONT];
        cell.textLabel.textColor = ZZTitleColor;
        
        return cell;
    } else if (tableView == self.childDepartTableView) { // 子科室
        
        ChildDepartment *childDepart = self.childDepartments[indexPath.row];
        
        static NSString *ID = @"childDepartNameCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell
            = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }

        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        cell.backgroundColor = ZZColor(244, 244, 244, 1);
        cell.textLabel.text = childDepart.dept_name;
        cell.textLabel.font = [UIFont systemFontOfSize:CELL_FONT];
        cell.textLabel.textColor = ZZTitleColor;
        
        return cell;
    }else if (tableView == self.levelTableView) { // 级别
        
        LSDoctorLevels *level = self.levels[indexPath.row];
        static NSString *ID = @"levelsCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell
            = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = level.level_name;
        cell.textLabel.font = [UIFont systemFontOfSize:CELL_FONT];
        cell.textLabel.textColor = ZZTitleColor;
        
        return cell;
    } else {
        
        LSFamousDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LSFamousDoctorTableViewCell class]) forIndexPath:indexPath];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row < self.doctors.count) {
            
            cell.doctor = self.doctors[indexPath.row];
        }
        
        return cell;
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _hospitalTableView) { // 医院
        // 0.更改科室内容
        [self.departBtn setTitle:@"全部科室" forState:UIControlStateNormal];
        
        // 1.更改按钮标题/更改按钮tag值
        [self.hospitalBtn setTitle:[self titleWithString:self.hos_name[indexPath.row]] forState:UIControlStateNormal];
        [self.hospitalBtn setTitleColor:[self titleColorWithString:self.hos_name[indexPath.row] currentBtn:self.hospitalBtn] forState:UIControlStateNormal];
        self.hospitalImg.image = [UIImage imageNamed:@"filter_xia"];
        self.hospitalBtn.tag = [self.hos_ids[indexPath.row] integerValue];
        
        // 2.移除遮盖
        [self removeBgView];
        
        // 3.1 记录医院ID
        self.hospital_id = self.hos_ids[indexPath.row];
        
        // 3.2 筛选医生(根据医院id),刷新主tableView
        [self loadHeaderHTTPForDoctorWithHospital_id:self.hospital_id department_id:self.childDepart_id sort:self.sort order_type:self.order_type keyword:self.keyWord];
        
        [self.famousDocTableView reloadData];
    } else if (tableView == _departTableView) { // 科室
        
        if (self.anyChildDepartments.count) {
            self.childDepartments = self.anyChildDepartments[indexPath.row];
            [self.childDepartTableView reloadData];
            
        }else {
            [MBProgressHUD showError:@"缺少数据"];
            
        }
    } else if (tableView == self.childDepartTableView) { // 子科室
        
        ChildDepartment *childDepart = self.childDepartments[indexPath.row];
        
        // 1.更改按钮标题
        [self.departBtn setTitle:[self titleWithString:childDepart.dept_name] forState:UIControlStateNormal];
        [self.departBtn setTitleColor:[self titleColorWithString:childDepart.dept_name currentBtn:self.departBtn] forState:UIControlStateNormal];
        self.departImg.image = [UIImage imageNamed:@"filter_xia"];
        self.departBtn.tag = childDepart.childList_id;
        
        // 2.移除遮盖
        [self removeBgView];
        
        // 3.1 记录科室ID
        self.childDepart_id = [NSString stringWithFormat:@"%d",childDepart.childList_id];
        
        // 3.2 筛选医生(根据医院id和子科室id),刷新主tableView
        [self loadHeaderHTTPForDoctorWithHospital_id:self.hospital_id department_id:self.childDepart_id sort:self.sort order_type:self.order_type keyword:self.keyWord];
        
        
        
    } else if (tableView == _levelTableView) { // 医生级别
        
        LSDoctorLevels *level = self.levels[indexPath.row];
        
        // 1.更改按钮标题
        [self.levelBtn setTitle:[self titleWithString:level.level_name] forState:UIControlStateNormal];
        [self.levelBtn setTitleColor:[self titleColorWithString:level.level_name currentBtn:self.levelBtn] forState:UIControlStateNormal];
        self.levelImg.image = [UIImage imageNamed:@"filter_xia"];
        // 2.移除遮盖
        [self removeBgView];

        // 3.1 记录医生排序类型
        self.sort = level.level_id;
        
        // 3.2 根据医生排序类型,刷新主tableView

        [self loadHeaderHTTPForDoctorWithHospital_id:self.hospital_id department_id:self.childDepart_id sort:self.sort order_type:self.order_type keyword:self.keyWord];
        
    } else {
        
        // 登陆后查看医生详情
        LSDoctorDetailViewController *doctorDetailVC = [LSDoctorDetailViewController new];
        LSPatientDoctor *doctor = self.doctors[indexPath.row];
        doctorDetailVC.doctor_id = doctor.doctor_id;
        [self.navigationController pushViewController:doctorDetailVC animated:YES];
    }
}

#pragma mark - 设置按钮title长度
- (NSString *)titleWithString:(NSString *)string {
    
    if (string.length < 7) {
        
        return string;
    } else {
        return [string substringToIndex:7];
    }
    return string;
}
#pragma mark - 设置按钮颜色
- (UIColor *)titleColorWithString:(NSString *)titleStr currentBtn:(UIButton *)currentBtn {
    
    // 更改按钮标题颜色
    if ([titleStr isEqualToString:@"全部服务"] || [titleStr isEqualToString:@"全部医院"] || [titleStr isEqualToString:@"全部科室"] || [titleStr isEqualToString:@"全部"]) {
        return ZZTitleColor;
    } else {
        return ZZColor(0, 153, 255, 1);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _famousDocTableView) {
        return 124;
    } else {
        return 44;
    }
}


#pragma mark 根据下单类型加载网络请求，获取该类型下的全部医生（根据医院id 和 医生等级level）
#pragma mark - 普通Header刷新
- (void)addHeaderRefreshWithHospital_id:(NSString *)hospital_id department_id:(NSString *)department_id sort:(NSString *)sort order_type:(NSString *)order_type keyword:(NSString *)keyword {
    
    __weak typeof(self) weakSelf = self;
    self.famousDocTableView.mj_header = [LSRefreshGifHeader headerWithRefreshingBlock:^{
        // 1.清除所有数据
        [weakSelf.doctors removeAllObjects];
        
        // 2.加载网络请求
        ZZLog(@"%@",keyword);
        [weakSelf loadHeaderHTTPForDoctorWithHospital_id:self.hospital_id department_id:self.childDepart_id sort:self.sort order_type:self.order_type keyword:self.keyWord];
        
        // 3.拿到当前的下拉刷新控件，结束刷新状态
        [weakSelf.famousDocTableView.mj_header endRefreshing];
    }];
}

#pragma mark - 普通Footer刷新
- (void)addFooterRefreshWithHospital_id:(NSString *)hospital_id department_id:(NSString *)department_id sort:(NSString *)sort order_type:(NSString *)order_type keyword:(NSString *)keyword {
    
    __weak typeof(self) weakSelf = self;
    self.famousDocTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 1.加载网络请求
        ZZLog(@"%@",keyword);
        [weakSelf loadFooterHTTPForDoctorWithHospital_id:self.hospital_id department_id:self.childDepart_id sort:self.sort order_type:self.order_type keyword:self.keyWord];
        
        // 2.拿到当前的上拉刷新控件，结束刷新状态
        [weakSelf.famousDocTableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - 下拉刷新网络请求
- (void)loadHeaderHTTPForDoctorWithHospital_id:(NSString *)hospital_id department_id:(NSString *)department_id sort:(NSString *)sort order_type:(NSString *)order_type keyword:(NSString *)keyword {
    
    // 2.1 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/resource/doctor_list",BASEURL];
    
    // 2.2 创建请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"hospital_id"] = hospital_id;   // 医院ID
    params[@"department_id"] = department_id;   // 科室ID
    params[@"sort"] = sort;     // 排序类型
    params[@"pn"] = @"1";   // 页码
    params[@"order_type"] = order_type;    // 订单类型
    params[@"keyword"] = keyword;   // 关键字
    
    ZZLog(@"params = %@",params);
    
    // 2.3 发送post请求
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"订单-responseObj--%@",responseObj);
        
        // 2.加载医生列表
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {// 数据加载成功
            NSArray *arr = responseObj[@"result"][@"dataList"];

            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *dict in arr) {
                LSPatientDoctor *doctor = [LSPatientDoctor mj_objectWithKeyValues:dict];
                [temp addObject:doctor];
            }
            
            weakSelf.doctors = temp;
            ZZLog(@"---doctors---%@",weakSelf.doctors);
            
            [weakSelf.famousDocTableView reloadData];
        }
    } failure:^(NSError *error) {
        ZZLog(@"---%@",error);
        
        [MBProgressHUD showError:@"发生错误，请重试" toView:weakSelf.view];
    }];
    
}

#pragma mark - 上拉加载网络请求
- (void)loadFooterHTTPForDoctorWithHospital_id:(NSString *)hospital_id department_id:(NSString *)department_id sort:(NSString *)sort order_type:(NSString *)order_type keyword:(NSString *)keyword {
    
    // 2.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/resource/doctor_list",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"hospital_id"] = hospital_id;   // 医院ID
    params[@"department_id"] = department_id;   // 科室ID
    params[@"sort"] = sort;     // 排序类型
    NSMutableArray *temp = [NSMutableArray array];
    if (self.doctors.count <20) {// 当首页显示的数量少于10就说明数据已经取光，直接让current的数值超过1
        _currentPage = 2;
        
    }else { // 首页数据等于20条
        
        _currentPage ++;
    }
    params[@"pn"] = [NSString stringWithFormat:@"%lu",_currentPage];   // 页码
    params[@"order_type"] = order_type;    // 订单类型
    params[@"keyword"] = keyword;   // 关键字
    
    ZZLog(@"%@",params);
    // 3. 发送post请求
    __weak typeof(self) weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"---%@",responseObj);
        
        // 2.加载医生列表
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {// 数据加载成功
            NSArray *arr = responseObj[@"result"][@"dataList"];
            if (arr.count < 20) { // 请求下来的数据少于20，表示已经取完。page增加就没有添加的数据了
                _currentPage ++;
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [self.famousDocTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            for (NSDictionary *dict in arr) {
                LSPatientDoctor *doctor = [LSPatientDoctor mj_objectWithKeyValues:dict];
                [temp addObject:doctor];
            }
            
            [weakSelf.doctors addObjectsFromArray:temp];
            ZZLog(@"---doctors---%@",weakSelf.doctors);
            
            [weakSelf.famousDocTableView reloadData];
            
        }else {// 数据加载失败
            
            [MBProgressHUD showError:responseObj[@"message"]];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请检查您的网络" toView:self.view];
        ZZLog(@"---%@",error);
        
    }];
}

#pragma mark 加载网络请求获取医生（根据医院id和子科室id）当hos_id dept_id为0，根据level请求
- (void)loadHTTPForDoctorWithHosID:(NSString *)hos_id DepartID:(NSString *)dept_id Leval:(NSString *)level{
    //    [MBProgressHUD showMessage:@"加载中..."];
    // 1.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/resource/doctor_list",BASEURL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:hos_id forKey:@"hospital_id"];
    [dict setObject:dept_id forKey:@"department_id"];
    [dict setValue:level forKey:@"level"];
    [dict setValue:@"1" forKey:@"pn"];
    [dict setValue:self.filterIDs forKey:@"filter_doctor_id"];// 过滤的医生ID
    
    __weak typeof(self) weakSelf = self;
    
    // 2.发送post请求
    [ZZHTTPTool post:urlStr params:dict success:^(NSDictionary *responseDict) {
        ZZLog(@"----responseDict---%@", responseDict);
        
        // 加载医生列表
        if ([responseDict[@"code"] isEqualToString:@"0000"]) {// 数据加载成功
            NSArray *arr = responseDict[@"result"][@"dataList"];
            
            if (arr.count == 0) {// 数组数量为0
                [MBProgressHUD showError:@"该科室缺乏对应的医生"];
                
            }
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *dict in arr) {
                LSPatientDoctor *doctor = [LSPatientDoctor mj_objectWithKeyValues:dict];
                [temp addObject:doctor];
            }
            
            weakSelf.doctors = temp;
            ZZLog(@"---doctors---%@",weakSelf.doctors);
            
            [weakSelf.famousDocTableView reloadData];
        }
        
    } failure:^(NSError *error) {
        ZZLog(@"%@",error);
        
        // 1.隐藏遮盖
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查您的网络"];
    }];
}

#pragma mark 加载网络请求获取科室（根据医院id）
- (void)loadHTTPForDepartWithHosID:(NSString *)hos_id {
    // 准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/resource/departments",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:hos_id forKey:@"hospital_id"];
    
    __weak typeof(self) weakSelf = self;
    
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"---%@",responseObj);
        
        // 1.准备数据，刷新科室列表
        NSMutableArray *arrDeptname= [NSMutableArray array]; // 存储科室名称 的数组
        NSMutableArray *arrChildList = [NSMutableArray array]; // 存储子科室模型数组 的数组
        
        for (NSDictionary *dict in responseObj[@"result"]) {
            Department *depart = [Department departWithDict:dict];
            [arrDeptname addObject:depart.dept_name];
            [arrChildList addObject:depart.childList];
        }
        weakSelf.departments = arrDeptname;
        [weakSelf.departTableView reloadData];
        
        weakSelf.anyChildDepartments = arrChildList;
        
        ZZLog(@"---科室名称---%@",arrDeptname);
        ZZLog(@"---子科室名称---%@",arrChildList);
        ZZLog(@"---子科室名称个数---%lu",(unsigned long)arrChildList.count);
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请检查您的网络" toView:self.view];
        ZZLog(@"---%@",error);
        
    }];
    
}

#pragma mark - 搜索按钮事件
- (void)searchDoctorData {
    [self removeBgView];
    
    // 搜索框背景
    _searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 24, SCREEN_WIDTH, 40)];
    _searchBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchBgView];
    
    // 搜索框
    self.searchbar = [[UITextField alloc] init];
    _searchbar.backgroundColor = ZZBackgroundColor;
    _searchbar.delegate = self;
    _searchbar.returnKeyType = UIReturnKeySearch;
    _searchbar.layer.cornerRadius = (CGRectGetHeight(_searchBgView.frame) - 10) / 2;
    _searchbar.layer.borderColor = ZZBorderColor.CGColor;
    _searchbar.textAlignment = NSTextAlignmentCenter;
    _searchbar.placeholder = @"请输入想要搜索的医院、医生、科室";
    _searchbar.font = [UIFont systemFontOfSize:14];
    _searchbar.layer.borderColor = ZZBorderColor.CGColor;
    _searchbar.layer.borderWidth = 1.0f;
    [_searchbar becomeFirstResponder];
    [self.searchBgView addSubview:_searchbar];
    [_searchbar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // 水平居中
        make.centerY.mas_equalTo(_searchBgView);
        // leading
        make.leading.mas_equalTo(_searchBgView).offset = 15;
        // 大小
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 80, CGRectGetHeight(_searchBgView.frame) - 10));
    }];
    
    // 取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:ZZTitleColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_searchBgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        // 水平居中显示
        make.centerY.mas_equalTo(_searchBgView);
        // trailing
        make.trailing.mas_equalTo(_searchBgView).offset = -15;
        // 大小
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    
    [UIView animateWithDuration:0.09 animations:^{
        CGRect frame = _searchBgView.frame;
        frame.origin.y = 64;
        self.searchBgView.frame = frame;
    }];
    
    // 覆盖视图
    [self addCoverView];
}

#pragma mark - 取消按钮
- (void)cancelButtonAction {
    
    // 重置数据
    self.hospital_id = @"0";
    self.childDepart_id = @"0";
    self.doctor_level = @"0";
    self.sort = @"0";
    self.keyWord = @"";
    
    // 隐藏遮盖
    [self hideCoverView];
    
    // 加载数据
    [self loadHeaderHTTPForDoctorWithHospital_id:self.hospital_id department_id:self.childDepart_id sort:self.sort order_type:self.order_type keyword:self.keyWord];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self hideCoverView];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // 结束编辑时搜做医生数据
    self.keyWord = textField.text;
    if (self.keyWord.length != 0) {
        
        [self loadHeaderHTTPForDoctorWithHospital_id:self.hospital_id department_id:self.childDepart_id sort:self.sort order_type:self.order_type keyword:self.keyWord];
    }
}

- (void)addCoverView {
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchBgView.frame), SCREEN_HEIGHT, SCREEN_HEIGHT - CGRectGetHeight(_searchBgView.frame))];
    coverView.backgroundColor = COVERVIEW_BACKGROUNDCOLOR;
   
    [[UIApplication sharedApplication].keyWindow addSubview:coverView];
    _coverView = coverView;
    
    
    // 添加tap手势
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCoverView)];
    [coverView addGestureRecognizer:tapGes];
}

#pragma mark - 手势监听
- (void)hideCoverView {
    
    [UIView animateWithDuration:0.13 animations:^{
        [_searchbar endEditing:YES];
        _coverView.alpha = 0.2;
        CGRect frame = _searchBgView.frame;
        frame.origin.y = 0;
        _searchBgView.frame = frame;
    } completion:^(BOOL finished) {
        [_coverView removeFromSuperview];
        [_searchBgView removeFromSuperview];
    }];
}

#pragma mark - lazy
#pragma mark - 加载数据（医生等级）
- (NSArray *)levels {
    if (_levels == nil) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DoctorSort" ofType:@"plist"]];
        
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            LSDoctorLevels *level = [LSDoctorLevels levelWithDict:dict];
            [temp addObject:level];
        }
        self.levels = temp;
    }
    return _levels;
}

- (NSArray *)services {
    
    if (_services == nil) {
        self.services = @[@"全部服务",@"预约专家",@"主刀医生",@"会诊服务",@"病情分析会",@"离院跟踪"];
    }
    return _services;
}

@end
