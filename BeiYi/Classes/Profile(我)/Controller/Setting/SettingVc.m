//
//  SettingVc.m
//  BeiYi
//
//  Created by Joe on 15/8/25.
//  Copyright (c) 2015年 Joe. All rights reserved.
//
#define HeadIconPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"headIcon.png"]
#define BUTTON_HEIGHT 44

#import "SettingVc.h"
#import "Common.h"
#import "ZZTabBarController.h"
#import "LSChangePwdController.h"
#import "LSUpdateAccountController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface SettingVc ()

@end

@implementation SettingVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZZBackgroundColor;
    
    self.tableView.tableFooterView = [self footViewCreated];
    ZZLog(@"%@",self.navigationController.viewControllers);
    
    // 更改状态栏的文字颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.text = @"设置";
    titleLabel.textColor = ZZTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    // 3. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
}

- (void)navBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 返回tableView的footView
- (UIView *)footViewCreated {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 100)];
    UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnLogout.frame = CGRectMake(0, 50, SCREEN_WIDTH, BUTTON_HEIGHT);
    btnLogout.backgroundColor = [UIColor whiteColor];
    btnLogout.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnLogout setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnLogout setTitle:@"安全退出" forState:UIControlStateNormal];
    [btnLogout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btnLogout];
    
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, 0) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:btnLogout];
    
    [ZZUITool linehorizontalWithPosition:CGPointMake(0, BUTTON_HEIGHT) width:SCREEN_WIDTH backGroundColor:ZZBorderColor superView:btnLogout];
    return footView;
}

#pragma mark - 监听登出按钮点击
- (void)logout {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/uc/my/exit",BASEURL];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:myAccount.token forKey:@"token"];// 登录token
        [ZZHTTPTool post:urlStr params:params success:^(NSDictionary * responseObj) {
            if ([responseObj[@"code"] isEqualToString:@"0000"]) {// 退出成功
                ZZLog(@"---退出成功---%@",responseObj);
                
                [self deleteAccountInfo];// 删除账号信息
                
            }else {// 因为版本等问题，登出失败
                
                [self deleteAccountInfo];// 删除账号信息
            }
        } failure:^(NSError *error) {
            ZZLog(@"---退出失败，发生错误---%@",error);
            [MBProgressHUD showError:@"发生异常"];
            
            [self deleteAccountInfo];// 删除账号信息
        }];
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancleAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark 删除账号信息
- (void)deleteAccountInfo {
    // 0.删除本地头像图片，防止多账号冲突
    [[NSFileManager defaultManager] removeItemAtPath:HeadIconPath error:nil];
    
    // 1.移除账号存储信息
    [ZZAccountTool deleteAccount];
    
    // 2.显示遮盖
    [MBProgressHUD showSuccess:@"退出成功"];
    
    // 3.返回
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 2;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = ZZTitleColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = @"关闭推送";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 监听推送
        UISwitch *notiSwitch = [[UISwitch alloc] init];
        // 在iOS7 后不再起任何作用
        notiSwitch.onImage = [UIImage imageNamed:@"switch_on"];
        notiSwitch.offImage = [UIImage imageNamed:@"switch_off"];
        [notiSwitch addTarget:self action:@selector(closeNotify:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = notiSwitch;
        
        
    }
    else if (indexPath.section ==1) {
        if (indexPath.row == 0) {

            cell.textLabel.text = @"密码修改";
            
        }else {

            cell.textLabel.text = @"个人信息";
        }
    }
    else {

        cell.textLabel.text = @"检查更新";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {// 密码修改
            LSChangePwdController *changeVc = [[LSChangePwdController alloc] init];
            [self.navigationController pushViewController:changeVc animated:YES];
            
        }else {// 账号修改
            LSUpdateAccountController *UpdateVc = [[LSUpdateAccountController alloc] init];
            [self.navigationController pushViewController:UpdateVc animated:YES];
        }
    }
    else {
        ZZLog(@"---检查更新---");
        [self checkVersion];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 9)];
    
    sectionView.backgroundColor = ZZBackgroundColor;
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

#pragma mark - 关闭推送
- (void)closeNotify:(UISwitch *)theSwitch {
    if (theSwitch.on == YES) {// 开关打开
        ZZLog(@"---打开推送---");
        if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
            [MBProgressHUD showError:@"无法打开指纹识别"];
        
        }else {
            LAContext *ctx = [[LAContext alloc] init];
            // 判断设备是否支持指纹识别
            if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]) {//支持指纹识别
                // 输入指纹，异步
                // 提示：指纹识别只是判断当前用户是否是手机的主人！程序原本的逻辑不会受到任何的干扰！
                [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹登录" reply:^(BOOL success, NSError *error) {
                    ZZLog(@"%d %@", success, error);
                    
                    if (success) {
                        // 登录成功
                    }
                }];
                
                ZZLog(@"come here");
            } else {
                ZZLog(@"不支持");
                [MBProgressHUD showError:@"当前不支持指纹识别"];
                theSwitch.on = NO;
            }
        }
        
    }else {
        ZZLog(@"---关闭推送---");

    }
}

#pragma mark - 检查更新
- (void)checkVersion {
    
    // 检查当前版本
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    // 保存当前版本号
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    ZZLog(@"%@",currentVersion);

    // 准备应用URL
    NSString *urlStr = APP_URL;
    
    __weak typeof(self)weakSelf = self;
    [ZZHTTPTool post:urlStr params:nil success:^(id responseObj) {
        ZZLog(@"&&&&&&&&%@",responseObj);
        
        NSArray *results = responseObj[@"results"];
        // 获取最新版本号
        NSString *lastVersion = [results firstObject][@"version"];
        ZZLog(@"%@",lastVersion);
        
        if (![lastVersion isEqualToString:currentVersion]) {
            // 有新版本弹框提示更新
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"客户端有新的版本啦，是否前往更新？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *trackViewUrl = [results firstObject][@"trackViewUrl"];
                NSURL *urlApp = [NSURL URLWithString:trackViewUrl];
                // 打开Apple Stroe
                [[UIApplication sharedApplication] openURL:urlApp];
            }];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:okAction];
            [alertController addAction:cancleAction];
            
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        else {
            // 提示没有最新版本
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"当前版本已经是最新版本" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alertController addAction:cancleAction];
            
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
@end
