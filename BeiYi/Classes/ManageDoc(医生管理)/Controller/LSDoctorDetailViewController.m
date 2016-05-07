//
//  LSDoctorDetailViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/3/24.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//



#import "LSDoctorDetailViewController.h"
#import "LSTimeSelectViewController.h"
#import "LoginController.h"
#import "LSActionSheet.h"
#import "LSDoctorDetail.h"
#import "LSImpression.h"
#import "OrderInfo.h"
#import "Common.h"
#import <UIImageView+WebCache.h>
#import "LSServicePrice.h"
#import "IMJIETagView.h"

#import "LSFamousDoctorViewController.h"
#import "LSEvaluateTableViewCell.h"

#import "LSAppointmentViewController.h"
#import "LSOperationViewController.h"
#import "LSConsultationViewController.h"
#import "LSIllnessAnalyzeViewController.h"
#import "LSLeaveTrackViewController.h"


@interface LSDoctorDetailViewController ()<LSActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>

/** 医生详情模型 */
@property (nonatomic, strong) LSDoctorDetail *doctorInfo;

/** Doctor View */
// 医生头像
@property (weak, nonatomic) IBOutlet UIImageView *doctorHeadImageView;
// 医生姓名
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
// 医生级别
@property (weak, nonatomic) IBOutlet UILabel *doctorLevelLabel;
// 医生所属医院
@property (weak, nonatomic) IBOutlet UILabel *doctorHospitalLabel;
// 医生就诊人数
@property (weak, nonatomic) IBOutlet UILabel *doctorVisitCountLabel;

/** 医生擅长 */
@property (weak, nonatomic) IBOutlet UILabel *doctorGoodAtLabel;
// 医生擅长背景高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doctorGoodAtViewHeight;

/** 医生介绍 */
@property (weak, nonatomic) IBOutlet UILabel *doctorIntroduceLabel;
// 医生介绍背景高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doctorIntroduceHeight;

/** 预约按钮 */
@property (weak, nonatomic) IBOutlet UIButton *appointButton;

// 医生开通服务的情况
@property (nonatomic, strong) NSArray *servicePriceArray;
/** 医生开通的服务数组 */
@property (nonatomic, strong) NSMutableArray *serviceArr;

/** 标签流 */
@property (weak, nonatomic) IBOutlet IMJIETagView *tagView;
/** 标签view的高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeightLayout;

// 印象数组
@property (nonatomic, strong) NSArray *impressionArr;

/** 用户评价列表 */
@property (weak, nonatomic) IBOutlet UITableView *evaluateTableView;

@end

@implementation LSDoctorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"医生详情";

    // 设置按钮名称
    [self setButtonTitle];
    
    // 加载医生详情
    [self loadDoctorDetail];
    
    // 请求医生印象
    [self loadDoctorImpression];
    
    // tableview设置代理
    self.evaluateTableView.delegate = self;
    self.evaluateTableView.dataSource = self;
    
    // 注册cell
    [self.evaluateTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LSEvaluateTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LSEvaluateTableViewCell class])];
}

#pragma mark - 设置按钮名称
- (void)setButtonTitle {
    
    // 预约按钮标题
    NSString *titleStr = [[NSString alloc] init];
    switch ([[OrderInfo shareInstance].service_type integerValue]) {
        case 0:
            titleStr = @"立即预约";
            break;
        case 1:
            titleStr = @"预约专家";
            break;
        case 2:
            titleStr = @"主刀医生";
            break;
        case 3:
            titleStr = @"会诊服务";
            break;
        case 4:
            titleStr = @"病情分析会";
            break;
        case 5:
            titleStr = @"离院跟踪";
            break;
    }
    [self.appointButton setTitle:titleStr forState:UIControlStateNormal];
}

#pragma mark - 加载医生详情
- (void)loadDoctorDetail {
    
    // 1. 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/resource/doctor_detail",BASEURL];
    
    // 2. 创建请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_doctor_id forKey:@"doctor_id"];
    
    // 3. 发送post请求
    __weak typeof(self) weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"%@",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            
            NSDictionary *dictResult = responseObj[@"result"];
            _doctorInfo = [LSDoctorDetail mj_objectWithKeyValues:dictResult];
            _servicePriceArray = [LSServicePrice mj_objectArrayWithKeyValuesArray:dictResult[@"services"]];
            // 设置UI
            [weakSelf setUI];
            
            // 设置医生详情页面数据
            [weakSelf setDoctorDetailData];
            
            // 设置赞价格
            [weakSelf priseScore];
            
        }
    } failure:^(NSError *error) {
        ZZLog(@"%@",error);
    }];
}

#pragma mark - 设置赞分数
- (void)priseScore {
    
    // 赞分数
    NSInteger zanTag = [self.doctorInfo.avg_score integerValue];
    ZZLog(@"%ld",zanTag);
    for (int i = 1; i <= zanTag; i ++) {
        UIImageView *imgView = [self.view viewWithTag:i + 100];
        imgView.image = [UIImage imageNamed:@"zan_xuan_zhong"];
    }
    
    CGFloat score = [self.doctorInfo.avg_score floatValue];
    NSInteger score_point = [[[NSString stringWithFormat:@"%.1f",score] substringFromIndex:2] integerValue];
    
    if (score_point > 0) {
        UIImageView *imageV = [self.view viewWithTag:zanTag + 1 + 100];
        if (score_point <= 5) {
            imageV.image = [UIImage imageNamed:@"zan_banxin"];
        }
        if (score_point > 5) {
            imageV.image = [UIImage imageNamed:@"zan_xuan_zhong"];
        }
    }
}

#pragma mark - 设置UI
- (void)setUI {
    
    // 医生头像
    self.doctorHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.doctorHeadImageView.layer.cornerRadius = self.doctorHeadImageView.height / 2;
    self.doctorHeadImageView.layer.masksToBounds = YES;
    
    // 计算医生擅长背景高度
    CGSize goodAtLabelMaxSize = CGSizeMake(SCREEN_WIDTH - 25, CGFLOAT_MAX);
    CGSize goodAtSize = [_doctorInfo.good_at boundingRectWithSize:goodAtLabelMaxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: _doctorGoodAtLabel.font} context:nil].size;
    self.doctorGoodAtViewHeight.constant = goodAtSize.height + 50;
    
    // 计算医生介绍背景高度
    CGSize introduceSize = [_doctorInfo.memo boundingRectWithSize:goodAtLabelMaxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: _doctorIntroduceLabel.font} context:nil].size;
    self.doctorIntroduceHeight.constant = introduceSize.height + 50;
    
    
}

#pragma mark - 设置医生详情页面数据
- (void)setDoctorDetailData {
    
    /** 医生简介 */
    // 头像
    [self.doctorHeadImageView sd_setImageWithURL:[NSURL URLWithString:_doctorInfo.avator] placeholderImage:[UIImage imageNamed:@"personal_tou_xiang"]];
    // 名字
    self.doctorNameLabel.text = _doctorInfo.name;
    // 级别
    NSString *levelStr = [[NSString alloc] init];
    switch ([_doctorInfo.level integerValue]) {
        case 1:
            levelStr = @"医师";
            break;
        case 2:
            levelStr = @"主治医师";
            break;
        case 3:
            levelStr = @"副主任医师";
            break;
        case 4:
            levelStr = @"主任医师";
            break;
    }
    self.doctorLevelLabel.text = levelStr;
    // 就诊人数
    self.doctorVisitCountLabel.text = [NSString stringWithFormat:@"%@人就诊",_doctorInfo.visit_count];
    
    // 所属医院
    self.doctorHospitalLabel.text = [NSString stringWithFormat:@"%@  %@",_doctorInfo.hospital_name,_doctorInfo.department_name];
    
    /** 医生擅长 */
    self.doctorGoodAtLabel.text = _doctorInfo.good_at;
    
    /** 医生介绍 */
    self.doctorIntroduceLabel.text = _doctorInfo.memo;
}

#pragma mark - 请求医生印象数据
- (void)loadDoctorImpression {
    
    // 1. 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/comment/doctor_auto_comments",BASEURL];
    
    // 2. 准备请求体
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    
    [paras setObject:myAccount.token forKey:@"token"];
    
    // 3. 发送post请求
    __weak typeof(self) weakSelf = self;
    [ZZHTTPTool post:urlStr params:paras success:^(NSDictionary *responseObj) {
        ZZLog(@"--医生印象--%@",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            NSArray *impressionArr = [LSImpression mj_objectArrayWithKeyValuesArray:responseObj[@"result"]];
            NSMutableArray *temp = [NSMutableArray array];
            for (int i = 0; i < impressionArr.count; i ++) {
                LSImpression *impression = impressionArr[i];
                NSString *impressionStr = impression.value;
                [temp addObject:impressionStr];
            }
            weakSelf.impressionArr = (NSArray *)temp;
            // 设置标签
            [self setTagView];
        }
    } failure:^(NSError *error) {
        ZZLog(@"%@",error);
        
    }];
}

- (void)setTagView {
    
    IMJIETagFrame *frame = [[IMJIETagFrame alloc] init];
    frame.tagsMinPadding = 4;
    frame.tagsMargin = 10;
    frame.tagsLineSpacing = 10;
    frame.tagsArray = self.impressionArr;
    
    self.tagViewHeightLayout.constant = frame.tagsHeight;
    self.tagView.clickbool = NO;
    self.tagView.borderSize = 1;
    self.tagView.clickborderSize = 1;
    
    self.tagView.tagsFrame = frame;
    self.tagView.clickBackgroundColor = ZZPriseColor;
    self.tagView.clickTitleColor = ZZPriseColor;
    self.tagView.clickStart = 1;
//    self.tagView.clickString = @"华语";
    self.tagView.clickArray = self.impressionArr;
    //单选
    //tagView.clickStart 为0
    //多选 tagView.clickStart 为1
//    self.tagView.delegate = self;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LSEvaluateTableViewCell class]) forIndexPath:indexPath];
    return cell;
}

#pragma mark - 预约按钮 监听
- (IBAction)appointButtonAction:(UIButton *)sender {
    
    if (myAccount) {
        
        [self.serviceArr removeAllObjects];
        
        [self.serviceArr addObject:@"请选择服务"];
        for (LSServicePrice *servicePrice in _servicePriceArray) {
            if ([servicePrice.open_flag isEqualToString:@"1" ] || [servicePrice.open_flag isEqualToString:@"3"]) {
                if ([servicePrice.service_type isEqualToString:@"1"]) {
                    [self.serviceArr addObject:@"预约专家"];
                }
                else if ([servicePrice.service_type isEqualToString:@"2"]) {
                    [self.serviceArr addObject:@"主刀医生"];
                }
                else if ([servicePrice.service_type isEqualToString:@"3"]) {
                    [self.serviceArr addObject:@"会诊服务"];
                }
                else if ([servicePrice.service_type isEqualToString:@"4"]) {
                    [self.serviceArr addObject:@"病情分析"];
                }
                else {
                    [self.serviceArr addObject:@"离院跟踪"];
                }
            }
        }
        
        /*
         *  进入医生详情的三条线
         *  home -- 预约界面 -- 选择医生 -- 医生详情
         *  home -- 医生详情 -- 预约界面
         *  名 医 -- 选择医生 -- 医生详情 -- 预约界面
         */
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        if (viewControllers.count == 4 && [viewControllers[2] isKindOfClass:[LSFamousDoctorViewController class]]) {
            [OrderInfo shareInstance].doctorInfo = _doctorInfo;
            [self.navigationController popToViewController:viewControllers[1] animated:YES];
        } else {
            
//            switch ([[OrderInfo shareInstance].service_type integerValue]) {
//                case 0: { // 当服务类型为0时表示没有选择服务调用actionSheet选择
                    // actionSheet
                    LSActionSheet *actionSheet = [LSActionSheet showActionSheetWithDelegate:self cancleButtonTitle:@"取消" itemsButtonTitle:_serviceArr];
                    [actionSheet show];
//                }
//                    break;
//                case 1: {
//                    LSAppointmentViewController *appointVC = [LSAppointmentViewController new];
//                    appointVC.doctorInfo = _doctorInfo;
//                    [self.navigationController pushViewController:appointVC animated:YES];
//                }
//                    break;
//                case 2: {
//                    LSOperationViewController *operationVC = [LSOperationViewController new];
//                    operationVC.doctorInfo = _doctorInfo;
//                    [self.navigationController pushViewController:operationVC animated:YES];
//                }
//                    break;
//                case 3: {
//                    LSConsultationViewController *consutationVC = [LSConsultationViewController new];
//                    consutationVC.doctorInfo = _doctorInfo;
//                    [self.navigationController pushViewController:consutationVC animated:YES];
//                }
//                    break;
//                case 4: {
//                    LSIllnessAnalyzeViewController *illnessAnaVC = [LSIllnessAnalyzeViewController new];
//                    illnessAnaVC.doctorInfo = _doctorInfo;
//                    [self.navigationController pushViewController:illnessAnaVC animated:YES];
//                }
//                    break;
//                case 5: {
//                    LSLeaveTrackViewController *leaveTrackVC = [LSLeaveTrackViewController new];
//                    leaveTrackVC.doctorInfo = _doctorInfo;
//                    [self.navigationController pushViewController:leaveTrackVC animated:YES];
//                }
//                    break;
//            }
        }
    } else {
        
        LoginController *loginVC = [LoginController new];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

#pragma mark - LSActionSheetDelegate
- (void)LSActionSheet:(LSActionSheet *)LSActionSheet didClickButtonAtIndex:(NSInteger)index {
    
    if ([[_serviceArr objectAtIndex:index] isEqualToString:@"立即预约"]) {
        
    } else if ([[_serviceArr objectAtIndex:index] isEqualToString:@"预约专家"]) {
        
        LSAppointmentViewController *appointVC = [LSAppointmentViewController new];
        appointVC.doctorInfo = _doctorInfo;
        appointVC.order_type = @"1";
        [self.navigationController pushViewController:appointVC animated:YES];
    } else if ([[_serviceArr objectAtIndex:index] isEqualToString:@"主刀医生"]) {
        
        LSOperationViewController *operationVC = [LSOperationViewController new];
        operationVC.doctorInfo = _doctorInfo;
        operationVC.order_type = @"2";
        [self.navigationController pushViewController:operationVC animated:YES];
    } else if ([[_serviceArr objectAtIndex:index] isEqualToString:@"会诊服务"]) {
        
        LSConsultationViewController *consutationVC = [LSConsultationViewController new];
        consutationVC.doctorInfo = _doctorInfo;
        consutationVC.order_type = @"3";
        [self.navigationController pushViewController:consutationVC animated:YES];
    } else if ([[_serviceArr objectAtIndex:index] isEqualToString:@"病情分析"]) {
        
        LSIllnessAnalyzeViewController *illnessAnaVC = [LSIllnessAnalyzeViewController new];
        illnessAnaVC.doctorInfo = _doctorInfo;
        illnessAnaVC.order_type = @"4";
        [self.navigationController pushViewController:illnessAnaVC animated:YES];
    } else {
        
        LSLeaveTrackViewController *leaveTrackVC = [LSLeaveTrackViewController new];
        leaveTrackVC.doctorInfo = _doctorInfo;
        leaveTrackVC.order_type = @"5";
        [self.navigationController pushViewController:leaveTrackVC animated:YES];
    }
}

#pragma mark - lazy
- (NSMutableArray *)serviceArr {
    
    if (_serviceArr == nil) {
        self.serviceArr = [NSMutableArray array];
    }
    return _serviceArr;
}

- (NSArray *)impressionArr {
    
    if (_impressionArr == nil) {
        self.impressionArr = [NSArray array];
    }
    return _impressionArr;
}

@end
