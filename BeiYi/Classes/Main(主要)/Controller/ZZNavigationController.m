//
//  ZZNavigationController.m
//  BeiYi
//
//  Created by Joe on 15/4/13.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ZZNavigationController.h"
#import "UIBarButtonItem+Extension.h"
#import "LoginController.h"
#import "Common.h"

@interface ZZNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) id popDelegate;

@end

@implementation ZZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.appearance方法返回一个导航栏的外观对象
    // 修改了这个外观对象，相当于修改了整个项目中的外观
    UINavigationBar *bar = [UINavigationBar appearance];
    
    [bar setBarTintColor:ZZBaseColor];
    
   [bar setTitleTextAttributes:@{
                                  NSForegroundColorAttributeName:[UIColor whiteColor]
                                  }];
    
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];

//    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_pushed.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];

    NSDictionary *dict = @{
                           //  iOS8之后改属性取消，使用下面属性代替（下同）
                           // UITextAttributeFont : [UIFont systemFontOfSize:13],
                           NSFontAttributeName : [UIFont systemFontOfSize:13],
                           
                           // UITextAttributeTextColor : [UIColor darkGrayColor],
                           NSForegroundColorAttributeName : [UIColor darkGrayColor]
                           
                           // iOS8之后默认初始状态不设置字体阴影显示
                           // UITextAttributeTextShadowOffset :[NSValue valueWithUIOffset:UIOffsetZero](UIOffset是结构体，不能直接在字典里用，先转换成NSValue)
                           };
    [barItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:dict forState:UIControlStateHighlighted];
    
    
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    
    self.delegate = self;
}

// 导航控制器跳转完成的时候调用
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (viewController == self.viewControllers[0]) { // 根控制器
        // 还原滑动返回手势
        self.interactivePopGestureRecognizer.delegate = _popDelegate;
    } else { // 非根控制器
        // 实现滑动返回功能
        // 清空滑动返回手势的代理，就能实现滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

/**
 *  能拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count>0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:nil target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];

}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
