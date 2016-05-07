//
//  AppDelegate.m
//  BeiYi
//
//  Created by Joe on 15/4/13.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#define LSVersionKey @"version"

#import "AppDelegate.h"
#import "ZZTabBarController.h"
#import "ZZNewTabBarController.h"
#import "SDWebImageManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Common.h"
#import "JPUSHService.h"
#import "LSNewFeatureController.h"


#import "LSSelectPayModeController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.window makeKeyAndVisible];
#pragma mark - 新特性的展示
    [self chooseRootViewController];
//    self.window.rootViewController = [LSSelectPayModeController new];
    
#pragma mark - 友盟统计、分享
    [self setYouMeng];
    
#pragma mark - JPush
    [self setJPushWithLaunchOptions:launchOptions];

    // 设置启动延迟
    [NSThread sleepForTimeInterval:1.5];
    
    return YES;
}

#pragma mark - 友盟统计、分享
- (void)setYouMeng {
    
    // 友盟统计
    
    // 使用version号做统计
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:version];
    // 设置发送策略
//    [MobClick startWithAppkey:@"56deb10b67e58e036b001222" reportPolicy:BATCH channelId:@"App Store"];
    
    
    // 友盟分享
    
    // 设置Appkey
//    [UMSocialData setAppKey:@"56deb10b67e58e036b001222"];
#warning 微信 Url改成apple Store的
    //设置微信分享url
//    [UMSocialWechatHandler setWXAppId:@"wxcdf8d0c55d5fa903" appSecret:@"8f619a85d01ee4dfd72d91b190155318" url:@"http://www.umeng.com/social"];
    //
    //#warning 微博分享后台没有设置好，没有通过开发者审核
    //    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。
    //    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3316927526"
    //                                              secret:@"3c863d11c9f007d8e223a575d8fddf43"
    //                                         RedirectURL:@"http://www.umeng.com/social"];
    //#warning QQ后台没有设置好 ID AppKey没有设置
    //    //设置分享到QQ/Qzone的应用Id，和分享url 链接
    //    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
}

#pragma mark - 选择跟控制器
- (void)chooseRootViewController {
    
    // 1. 获取当钱的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    
    // 2.获取上一次的版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:LSVersionKey];
    
    // 判断当前是否有新的版本
    if ([currentVersion isEqualToString:lastVersion]) {
        // 创建tabBar
        BOOL roleStyle = [[NSUserDefaults standardUserDefaults] boolForKey:@"RoleStyle"];
        
        if (roleStyle) {// 切换经纪人模式
            ZZNewTabBarController *newTabController = [[ZZNewTabBarController alloc] init];
            self.window.rootViewController = newTabController;
            
        }else {
            // 切换普通模式
            ZZTabBarController *tabController = [[ZZTabBarController alloc] init];
            self.window.rootViewController = tabController;
        }
    }
    else { // 有最新的版本号
        // 进入新特性界面
        // 新特性控制器
        LSNewFeatureController *newFeatureVC = [LSNewFeatureController new];
        self.window.rootViewController = newFeatureVC;
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:LSVersionKey];
    }
}

#pragma mark - 极光推送配置
- (void)setJPushWithLaunchOptions:(NSDictionary *)launchOptions {
    
    // 图标清零
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    // Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
#warning 发布模式aps需要更改为  1
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppkey channel:@"App Store" apsForProduction:1];
    // Required JPush
    
    // 设备收到一条推送（APNs），用户点击推送通知打开应用时(app未运行)，那么此函数将被调用
    NSDictionary *remoteNotification =  [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    ZZLog(@"---app未运行--APNs---%@",remoteNotification);
    
    
    // 获取自定义消息推送内容
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    ZZLog(@"---deviceToken---%@",deviceToken);

    // Required（上传DeviceToken给极光推送的服务器）
    [JPUSHService registerDeviceToken:deviceToken];
}

// 设备收到一条推送（APNs），用户点击推送通知打开应用时(app状态为正在前台或者后台运行)，那么此函数将被调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    ZZLog(@"---app状态为正在前台或者后台运行---userInfo---%@",userInfo);

    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得自定义字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    
    ZZLog(@"content =[%@], badge=[%ld], sound=[%@], customize field =[%@]",content,(long)badge,sound,customizeField1);
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    ZZLog(@"this is iOS7 Remote Notification");
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //Optional
    ZZLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    // 1.停止下载所有图片
    [[SDWebImageManager sharedManager] cancelAll];
    
    // 2.清除内存中的图片
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
//    BOOL result = [UMSocialSnsService handleOpenURL:url];
//    if (result == FALSE) {
//        //调用其他SDK，例如支付宝SDK等
//        
//        
//    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    
}

/*
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    
    ZZLog(@"-----networkDidReceiveMessage---userInfo----%@",userInfo);
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新消息来了" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
//    [alert show];

}
 */

@end
