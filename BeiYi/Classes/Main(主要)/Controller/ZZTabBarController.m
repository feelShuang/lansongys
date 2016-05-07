//
//  ZZTabBarController.m
//  BeiYi
//
//  Created by Joe on 15/4/13.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ZZTabBarController.h"
#import "ZZNavigationController.h"

#import "LSPatientHomeController.h"
#import "LSFamousDoctorViewController.h"
#import "LSPatientOrderViewController.h"
#import "ProfileController.h"

#import "Common.h"
#import "LoginController.h"

@interface ZZTabBarController ()

@end

@implementation ZZTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  UITabBar 设置背景色
    UITabBar *appearance = [UITabBar appearance];
    appearance.tintColor = [UIColor colorWithHexString:@"30a5fc"];
    [appearance setBackgroundImage:[UIImage imageNamed:@"tabBarBg"]];
    
    

    // 添加三个选项卡
    // 贝医
    LSPatientHomeController *patientHomeVC = [[LSPatientHomeController alloc] init];
    [self addChildViewController:patientHomeVC nomalImage:[UIImage imageNamed:@"tabBarIcon_home"] selectedImage:[UIImage imageNamed:@"tabBarIcon_homeSelect"] title:@"首页"];
    
    // 名医
    LSFamousDoctorViewController *famousDocVC = [LSFamousDoctorViewController new];
    [self addChildViewController:famousDocVC nomalImage:[UIImage imageNamed:@"tabBarIcon_famousDoc"] selectedImage:[UIImage imageNamed:@"tabBarIcon_famousDocSelect"] title:@"名医"];
    
    // 订单
    LSPatientOrderViewController *patientOrderVC = [LSPatientOrderViewController new];
    [self addChildViewController:patientOrderVC nomalImage:[UIImage imageNamed:@"tabBarIcon_order"] selectedImage:[UIImage imageNamed:@"tabBarIcon_orderSelect"] title:@"订单"];

    
    // 个人
    ProfileController *profileVC = [[ProfileController alloc] init];
    [self addChildViewController:profileVC nomalImage:[UIImage imageNamed:@"tabBarIcon_profile"] selectedImage:[UIImage imageNamed:@"tabBarIcon_profileSelect"] title:@"个人"];
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
    UIImage *img = selectedImage;
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = img;
    ZZNavigationController *navVc = [[ZZNavigationController alloc] initWithRootViewController:childController];;
    [self addChildViewController:navVc];
}

@end
