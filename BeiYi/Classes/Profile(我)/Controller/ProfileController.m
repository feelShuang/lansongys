//
//  ProfileController.m
//  BeiYi
//
//  Created by Joe on 15/4/13.
//  Copyright (c) 2015年 Joe. All rights reserved.
//
#define HeadIconPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"headIcon.png"]

#import "ProfileController.h"
#import "ZZTabBarController.h"
#import "ZZNewTabBarController.h"

#import "LoginController.h"
#import "LSApplyBrokerViewController.h"


#import "LSManagePatientViewController.h"
#import "RegisteOfferController.h"
#import "Avatar.h"
#import "ZZRechargeBtn.h"

#import "LSBalanceViewController.h"
#import "LSCardViewController.h"
#import "LSPointsViewController.h"
#import "SettingVc.h"

#import "LSBrokerDoctorTableViewController.h"
#import "MyCollectionViewController.h"

#import "WKWebViewController.h"
#import "AboutUSViewController.h"
#import "WeChatViewController.h"

#import "AccountInfo.h"
#import "LSBaseCellModel.h"

#import "UIBarButtonItem+Item.h"
#import <UIImageView+WebCache.h>
#import "Common.h"
#import <Masonry.h>

@interface ProfileController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *personalTableView;

@property (retain,nonatomic)UIPopoverController *imagePicker;

/** 用户头像 */
@property (nonatomic, strong) UIImageView *avatorImage;

/** 点击头像登录提示语 */
@property (nonatomic, strong) UILabel *btnLabel;

/** 切换模式按钮 */
@property (nonatomic, strong) UIButton *changeRoleBtn;

/** 当前模式标记 */
@property (nonatomic, assign) BOOL roleStyle;

/** 患者模式的tabBarController */
@property (nonatomic, strong) ZZTabBarController *tabBarVC;

/** tableView数据数组 */
@property (nonatomic, strong) NSArray *tableArray;

/** 显示余额的Label */
@property (nonatomic, strong) UILabel *balanceLabel;

/** 意见反馈界面 */
@property (nonatomic, strong) WeChatViewController *weChatVC;

@end

@implementation ProfileController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZZBackgroundColor;
    self.title = @"个人";

    // 设置UI
    [self setUpUI];
    
    // 添加角色转换按钮
    [self changeRoleBtnCreated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 每次进入都去获取账号信息，防止出现多端登录被下线
    [AccountInfo getAccount];

    // 设置导航条颜色
    [self.navigationController.navigationBar setBarTintColor:ZZBaseColor];
    
    // 设置状态条文字颜色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 刷新余额
    if (myAccount) {
        [self refreshBalance];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 设置登录页面的导航条颜色
    // 在视图返回到 AViewContoller 或者 BViewController 时将颜色改回 A
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#f5f6f7"]];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    if (myAccount) {// 判断是否为登录状态
        
        // 刷新头像
        // 判断头像是否有本地缓存
        BOOL isEXist = [[NSFileManager defaultManager] fileExistsAtPath:HeadIconPath];
        if (isEXist) {// 设置本地头像
            UIImage *headImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:HeadIconPath]];
            self.avatorImage.image = headImage;
            
        }else {// 没有本地缓存
            // 判断头像单例是否为空
            ZZLog(@"---判断头像单例是否为空---%@",[Avatar sharedInstance].avator);
            
            if (![[Avatar sharedInstance].avator isEqual:[NSNull null]]) {// 不为空
                
                // 先从网络读取图片再缓存头像到本地
                [self.avatorImage sd_setImageWithURL:[NSURL URLWithString:[Avatar sharedInstance].avator] placeholderImage:[UIImage imageNamed:@"personal_tou_xiang"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    NSData *headIconData = UIImageJPEGRepresentation(image, 0.4);
                    [headIconData writeToFile:HeadIconPath atomically:YES];
                }];

            }else {// 单例为空
                // 需要读取账号信息，得到单例,再根据单例获取头像
                [AccountInfo getAccount];
                //                [self getAccount];
                
                // 如果单例不为空
                if (![[Avatar sharedInstance].avator isEqual:[NSNull null]]) {
                    [self.avatorImage sd_setImageWithURL:[NSURL URLWithString:[Avatar sharedInstance].avator] placeholderImage:[UIImage imageNamed:@"personal_tou_xiang"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        NSData *headIconData = UIImageJPEGRepresentation(image, 0.4);
                        [headIconData writeToFile:HeadIconPath atomically:YES];
                    }];
                    // 如果单例还是为空
                }else {
                    self.avatorImage.image = [UIImage imageNamed:@"personal_tou_xiang"];
                }
                
            }
        }
        self.btnLabel.text = myAccount.mobile;
    }
    else {
        self.avatorImage.image = [UIImage imageNamed:@"personal_tou_xiang"];
        self.btnLabel.text = @"注册/登录";
    }
}

#pragma mark - UI布局
- (void)setUpUI {
    
    self.personalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 45) style:UITableViewStyleGrouped];
    self.personalTableView.delegate = self;
    self.personalTableView.dataSource = self;
    self.personalTableView.backgroundColor = ZZBackgroundColor;
    self.personalTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_personalTableView];
    
    // 重写导航条右侧按钮
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.frame = CGRectMake(0, 0, 20, 20);
    [rightbtn setImage:[UIImage imageNamed:@"personal_shezhi"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(rightBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];

    
}

#pragma mark - 导航条设置item
- (void)rightBarButtonItemAction {
    
    if (myAccount) { // 已登录
        
        // 推出设置页面
        [self.navigationController pushViewController:[[SettingVc alloc] init] animated:YES];
    }
    else { // 未登录

        LoginController *loginVC = [LoginController new];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

#pragma mark - 返回tableView的headerView
- (UIView *)headerViewCreated {
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 87)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.userInteractionEnabled = YES;
    
    
    // 1.设置头像
    self.avatorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_tou_xiang"]];
    self.avatorImage.contentMode = UIViewContentModeScaleAspectFill;
    self.avatorImage.userInteractionEnabled = YES;
    
    // 1.1 裁剪头像为圆形
    self.avatorImage.layer.cornerRadius = 25;
    self.avatorImage.layer.masksToBounds = YES;
    [headerView addSubview:_avatorImage];
    
    [_avatorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // 左对齐
        make.leading.mas_equalTo(headerView).with.offset(SCREEN_WIDTH * 0.04);
        // 居中对齐
        make.centerY.mas_equalTo(headerView);
        // 大小
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    // 2.设置昵称
    UILabel *lblName = [[UILabel alloc] init];
    lblName.textAlignment = NSTextAlignmentLeft;
    lblName.font = [UIFont systemFontOfSize:14];
    lblName.textColor = ZZTitleColor;
    if (myAccount) {
        lblName.text = myAccount.mobile;// 显示昵称
    }
    else {
        lblName.text = @"请点击头像登录";
    }
    self.btnLabel = lblName;
    [headerView addSubview:self.btnLabel];
    
    [_btnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // 居中对齐
        make.centerY.mas_equalTo(headerView);
        // 左对齐
        make.leading.mas_equalTo(headerView).with.offset(SCREEN_WIDTH * 0.08 + 50);
        // 大小
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
    
    return headerView;
}

#pragma mark - 添加余额Label
- (void)addBalanceLabelWithCell:(UITableViewCell *)cell {
    
    UILabel *balanceLab = [[UILabel alloc] init];
    
    balanceLab.textAlignment = NSTextAlignmentRight;
    balanceLab.textColor = ZZColor(255, 138, 0, 1);
    balanceLab.font = [UIFont systemFontOfSize:14];
    _balanceLabel = balanceLab;
    
    [cell.contentView addSubview:balanceLab];
    
    [balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // 设置大小
        make.size.mas_equalTo(CGSizeMake(100, 30));
        // 居中对齐
        make.centerY.mas_equalTo(cell.contentView);
        // 尾部对齐
        make.trailing.mas_equalTo(cell.contentView);
    }];
}

#pragma mark - 刷新余额
- (void)refreshBalance {
    
    // 1.刷新余额
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/trader/account",BASEURL];
    
    __weak typeof(self) wSelf = self;
    [ZZHTTPTool post:urlStr params:[NSDictionary dictionaryWithObject:myAccount.token forKey:@"token"] success:^(NSDictionary *responseObj) {
        ZZLog(@"---余额---%@",responseObj);
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            NSString *balance = [NSString stringWithFormat:@"￥%.0f",[responseObj[@"result"][@"use_balance"] floatValue]];
            wSelf.balanceLabel.text = balance;
        }
        
    } failure:^(NSError *error) {

    }];
}

#pragma mark - 更改头像
- (void)changeAvatar {
    if (myAccount) {
        
        //一个菜单列表 选择照相机还是 相册
        UIActionSheet  *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
        [sheet showInView:[self.view window]];
    }
    else {
        [self.navigationController pushViewController:[LoginController new] animated:YES];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {//第一个按钮
        //照相机
        [self addOfCamera];
    }
    else if(buttonIndex == 1)//第二个按钮
    {
        //相册
        [self addOfAlbum];
    }
}

#pragma mark - 调用照相机
- (void) addOfCamera {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc .delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - 调用相册
- (void) addOfAlbum {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark Camera View Delegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    ZZLog(@"--调用相册/机--%@",info);

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *headIcon = info[@"UIImagePickerControllerOriginalImage"];// 头像图片
    
    // 1.修改本地头像
    // 1.1设置本地头像
    self.avatorImage.image = headIcon;
    
    // 1.2缓存图片到本地
    NSData *headIconData = UIImageJPEGRepresentation(headIcon, 0.4);
    [headIconData writeToFile:HeadIconPath atomically:YES];
    

    // 2.修改服务器头像
    // 2.1准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/my/update_avator",BASEURL] ;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:myAccount.token forKey:@"token"];
    
    // 2.2头像数据(BASE64加密后的数据)
    NSData *imgData = UIImageJPEGRepresentation(info[@"UIImagePickerControllerOriginalImage"], 0.4);
    NSString *imgStr = [imgData base64Encoding];
    
    [params setObject:imgStr forKey:@"avator_str"];
    [params setObject:@".jpg" forKey:@"suffix"];// 图片后缀名
    
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseDict) {
        ZZLog(@"%@",responseDict);
        
        if ([responseDict[@"code"] isEqualToString:@"0000"]) {// 修改成功
            // 1.显示提示信息
            [MBProgressHUD showSuccess:@"头像修改成功"];
            // 2.缓存头像地址到单例地址
            [Avatar sharedInstance].avator = responseDict[@"result"];
            
        } else {
            [MBProgressHUD showError:@"头像修改失败"];
        }
        
    } failure:^(NSError *error) {
        // 隐藏遮盖
        [MBProgressHUD hideHUD];
        ZZLog(@"%@",error);
    }];
    
    // 获取账号信息
    [AccountInfo getAccount];
}

//点击cancel调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark 删除账号信息
- (void)deleteAccountInfo {
    // 0.删除本地头像图片，防止多账号冲突
    [[NSFileManager defaultManager] removeItemAtPath:HeadIconPath error:nil];
    
    // 1.移除账号存储信息
    [ZZAccountTool deleteAccount];
    
    // 2.显示遮盖
    [MBProgressHUD showSuccess:@"请重新登录！"];
    
    // 3.返回首页
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (ROLESTYLE) {
        if (section == 0) {
            return 1;
        } else if (section == 1) {
            return 1;
        } else {
            return 4;
        }
    } else {
        if (section == 0) {
            return 1;
        } else if (section == 1) {
            return 3;
        } else {
            return 5;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = ZZTitleColor;
    
    
    LSBaseCellModel *model = self.tableArray[indexPath.section][indexPath.row];
    
    cell.imageView.image = model.image;
    cell.textLabel.text = model.title;
    if (indexPath.section == 0) {
        [cell.contentView addSubview:[self headerViewCreated]];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        // 添加余额label
        [self addBalanceLabelWithCell:cell];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self changeAvatar];
    }
    
    LSBaseCellModel *model = self.tableArray[indexPath.section][indexPath.row];
    UIViewController *VC = [[model.targetClass alloc] init];
    if (ROLESTYLE) { // 经纪人模式
        
        if ([VC isKindOfClass:[LSBalanceViewController class]] || [VC isKindOfClass:[LSCardViewController class]] || [VC isKindOfClass:[LSPointsViewController class]] || [VC isKindOfClass:[RegisteOfferController class]]) {
            
            if (myAccount) {
                [self.navigationController pushViewController:VC animated:YES];
            } else {
                LoginController *loginVC = [LoginController new];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        } else {
            
            if (indexPath.section == 2) {
                
                if (indexPath.row == 1 || indexPath.row == 2) {
                    WKWebViewController *VC = [[model.targetClass alloc] init];
                    switch (indexPath.row) {
                        case 1: VC.num = 2; VC.titleStr = @"常见问题";
                            break;
                        case 2: VC.num = 3; VC.titleStr = @"服务协议";
                            break;
                    }
                    [self.navigationController pushViewController:VC animated:YES];
                } else {
                    [self.navigationController pushViewController:VC animated:YES];
                }
                /*
                 if (indexPath.row == 1) {
                 
                 
                 
                 // 隐藏没有安装的客户端
                 [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
                 
                 // 我的分享
                 [UMSocialSnsService presentSnsIconSheetView:self
                 appKey:@"56deb10b67e58e036b001222"
                 shareText:@"贝医-让您的需求更简单"
                 shareImage:[UIImage imageNamed:@"comment_clicked"]
                 shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ,nil]
                 delegate:nil];
                 } else {
                 [self.navigationController pushViewController:VC animated:YES];
                 }
                 */
            }
        }
    } else { // 普通用户
        
        if ([VC isKindOfClass:[LSBalanceViewController class]] || [VC isKindOfClass:[LSCardViewController class]] || [VC isKindOfClass:[LSPointsViewController class]] || [VC isKindOfClass:[LSManagePatientViewController class]]) {
            
            if (myAccount) {
                [self.navigationController pushViewController:VC animated:YES];
            } else {
                LoginController *loginVC = [LoginController new];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        } else {
            
            if (indexPath.section == 2) {
                
                if (indexPath.row == 2 || indexPath.row == 3) {
                    WKWebViewController *VC = [[model.targetClass alloc] init];
                    switch (indexPath.row) {
                        case 2: VC.num = 2; VC.titleStr = @"常见问题";
                            break;
                        case 3: VC.num = 3; VC.titleStr = @"服务协议";
                            break;
                    }
                    [self.navigationController pushViewController:VC animated:YES];
                } else {
                    [self.navigationController pushViewController:VC animated:YES];
                }
            }
        }
    }
}

- (void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"即将开放" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 87;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}

#pragma mark - 创建角色切换按钮
- (void)changeRoleBtnCreated {

    UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnConfirm.frame = CGRectMake(0, CGRectGetMaxY(_personalTableView.frame), SCREEN_WIDTH, 45);
    btnConfirm.backgroundColor = !ZZBaseColor;
    btnConfirm.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnConfirm setTitle:ROLESTYLE?@"普通模式":@"经纪人模式" forState:UIControlStateNormal];
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnConfirm addTarget:self action:@selector(changeRoleStyle) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnConfirm];
}

- (void)changeRoleStyle {
    
    self.roleStyle = !ROLESTYLE;
    
    // 已登录
    if (myAccount) {
        
        // 判断当前角色
        if (_roleStyle) { // 当前为患者模式，需要切换到经纪人模式
            
            /** 检测用户是否是经纪人 */
            // 1. 准备请求接口
            NSString *urlStr = [NSString stringWithFormat:@"%@/uc/offer/offer_check",BASEURL];
            
            // 2. 创建请求体
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            params[@"token"] = myAccount.token;
            
            // 3. 发送post请求
            __weak typeof(self)weakSelf = self;
            [ZZHTTPTool post:urlStr params:params success:^(id responseObj) {
                ZZLog(@"--经纪人检测--%@",responseObj);
                
                if ([responseObj[@"code"] isEqualToString:@"0001"]) { // 还不是经纪人
                    
//                    RegisteOfferController *registerOfferVC = [RegisteOfferController new];
//                    [self.navigationController pushViewController:registerOfferVC animated:YES];
                    
                    // 推出 经纪人申请界面
                    LSApplyBrokerViewController *applyBrokerVC = [LSApplyBrokerViewController new];
                    [self.navigationController pushViewController:applyBrokerVC animated:YES];
                } else { // 是经纪人
                
                    // 保存角色为经纪人
                    weakSelf.roleStyle = !ROLESTYLE;
                    [[NSUserDefaults standardUserDefaults] setBool:_roleStyle forKey:@"RoleStyle"];
                    // 切换
                    ZZNewTabBarController *newTabController = [[ZZNewTabBarController alloc] init];
                    [UIApplication sharedApplication].keyWindow.rootViewController = newTabController;
                }
                
            } failure:^(NSError *error) {
                ZZLog(@"%@",error);
            }];
        } else { // 当前为经纪人模式，需要切换到普通模式
            
            // 保存为普通模式
            self.roleStyle = !ROLESTYLE;
            [[NSUserDefaults standardUserDefaults] setBool:_roleStyle forKey:@"RoleStyle"];
            // 切换
            ZZTabBarController *tabController = [[ZZTabBarController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabController;
        }
    } else { // 未登录
        
        LoginController *loginVC = [LoginController new];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

#pragma mark - 懒加载
- (NSArray *)tableArray {
    
    if (_tableArray == nil) {
        
        LSBaseCellModel *nomalInfo = [LSBaseCellModel modelWithImage:nil targetClass:nil clickHandler:nil title:nil subTitle:nil];
        LSBaseCellModel *yu_e = [LSBaseCellModel modelWithImage:[UIImage imageNamed:@"personal_yu_e"] targetClass:[LSBalanceViewController class] clickHandler:nil title:@"我的余额" subTitle:nil];
        LSBaseCellModel *kaquan = [LSBaseCellModel modelWithImage:[UIImage imageNamed:@"personal_ka_quan"] targetClass:[LSCardViewController class] clickHandler:nil title:@"我的卡券" subTitle:nil];
        LSBaseCellModel *jifen = [LSBaseCellModel modelWithImage:[UIImage imageNamed:@"personal_ji_fen"] targetClass:[LSPointsViewController class] clickHandler:nil title:@"我的积分" subTitle:nil];
        LSBaseCellModel *jiuzhenren = [LSBaseCellModel modelWithImage:[UIImage imageNamed:@"personal_jiu_zhen_ren"] targetClass:[LSManagePatientViewController class] clickHandler:nil title:@"就诊人管理" subTitle:nil];
        LSBaseCellModel *yijian = [LSBaseCellModel modelWithImage:[UIImage imageNamed:@"personal_yi_jian"] targetClass:[WeChatViewController class] clickHandler:nil title:@"意见反馈" subTitle:nil];
        LSBaseCellModel *wenti = [LSBaseCellModel modelWithImage:[UIImage imageNamed:@"personal_wen_ti"] targetClass:[WKWebViewController class] clickHandler:nil title:@"常见问题" subTitle:nil];
        LSBaseCellModel *xieyi = [LSBaseCellModel modelWithImage:[UIImage imageNamed:@"personal_xie_yi"] targetClass:[WKWebViewController class] clickHandler:nil title:@"服务协议" subTitle:nil];
        LSBaseCellModel *guanyu = [LSBaseCellModel modelWithImage:[UIImage imageNamed:@"personal_guan_yu"] targetClass:[AboutUSViewController class] clickHandler:nil title:@"关于我们" subTitle:nil];
        
        
//        LSBaseCellModel *offerInfo = [LSBaseCellModel modelWithImage:nil targetClass:nil clickHandler:nil title:nil subTitle:nil];
//        LSBaseCellModel *offerHospital = [LSBaseCellModel modelWithImage:[UIImage imageNamed:@"profile10"] targetClass:[RegisteOfferController class] clickHandler:nil title:@"设置医院" subTitle:nil];
//        LSBaseCellModel *share = [LSBaseCellModel modelWithImage:[UIImage imageNamed:@"profile07"] targetClass:nil clickHandler:nil title:@"我的分享" subTitle:nil];
//        LSBaseCellModel *offer_yijian = [LSBaseCellModel modelWithImage:[UIImage imageNamed:@"profile12"] targetClass:[WeChatViewController class] clickHandler:nil title:@"意见反馈" subTitle:nil];

        if (ROLESTYLE) { // 经纪人模式
            _tableArray = @[@[nomalInfo],@[yu_e],@[yijian,wenti,xieyi,guanyu]];
        } else {
            _tableArray = @[@[nomalInfo],@[yu_e,kaquan,jifen],@[jiuzhenren,yijian,wenti,xieyi,guanyu]];
        }
    }
    return _tableArray;
}


@end
