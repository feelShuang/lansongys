//
//  ZZNewTabBarController.m
//  BeiYi
//
//  Created by Joe on 15/11/19.
//  Copyright © 2015年 Joe. All rights reserved.
//

#import "ZZNewTabBarController.h"
#import "ZZNavigationController.h"

#import "LSBrokerGrabOrderViewController.h"
#import "LSBrokerOrderViewController.h"
#import "LSBrokerDoctorTableViewController.h"
#import "ProfileController.h"

#import "Common.h"
#import "LoginController.h"


@interface ZZNewTabBarController ()

@end

@implementation ZZNewTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  UITabBar 设置背景色
    UITabBar *appearance = [UITabBar appearance];
    appearance.tintColor = ZZButtonTintColor;
    [appearance setBackgroundImage:[UIImage imageNamed:@"tabBarBg"]];
    
    // 添加四个选项卡
    LSBrokerGrabOrderViewController *grabOrderVC = [[LSBrokerGrabOrderViewController alloc] init];
    [self addChildViewController:grabOrderVC nomalImage:[UIImage imageNamed:@"tabBarIcon_mo_ren"] selectedImage:[UIImage imageNamed:@"tabBarIcon_xuan_zhong"] title:@"抢单"];
    
    // 订单
    LSBrokerOrderViewController *orderVC = [[LSBrokerOrderViewController alloc] init];
    [self addChildViewController:orderVC nomalImage:[UIImage imageNamed:@"tabBarIcon_order"] selectedImage:[UIImage imageNamed:@"tabBarIcon_ding_dan"] title:@"订单"];
    
    // 医生
    LSBrokerDoctorTableViewController *brokerDoctorVC = [[LSBrokerDoctorTableViewController alloc] init];
    [self addChildViewController:brokerDoctorVC nomalImage:[UIImage imageNamed:@"tabBarIcon_famousDoc"] selectedImage:[UIImage imageNamed:@"tabBarIcon_doctor"] title:@"医生"];
    
    // 个人
    ProfileController *profileVC = [[ProfileController alloc] init];
    [self addChildViewController:profileVC nomalImage:[UIImage imageNamed:@"tabBarIcon_profile"] selectedImage:[UIImage imageNamed:@"tabBarIcon_personal"] title:@"个人"];
}

/**
 *  添加一个选项卡
 *
 *  @param childController   添加的选项卡 控制器
 *  @param title             选项卡 标题
 *  @param imageName         选项卡 图标
 *  @param selectedImageName 选项卡 选中时的图标
 */
- (void)addChildViewController:(UIViewController *)childController nomalImage:(UIImage *)nomalImage selectedImage:(UIImage *)selectedImage title:(NSString *)title {
    
    childController.title = title;
    childController.tabBarItem.image = nomalImage;
    childController.tabBarItem.selectedImage = selectedImage;
    ZZNavigationController *navVc = [[ZZNavigationController alloc] initWithRootViewController:childController];;
    [self addChildViewController:navVc];
}

@end
