//
//  LSCardViewController.m
//  BeiYi
//
//  Created by LiuShuang on 15/8/25.
//  Copyright (c) 2015年 LiuShuang. All rights reserved.
//

#import "LSCardViewController.h"
#import "Common.h"

@interface LSCardViewController ()

@end

@implementation LSCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpUI];
    
    // 更改状态栏的文字颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)setUpUI {
    
    // 1. 设置title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.text = @"我的卡券";
    titleLabel.textColor = ZZTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    // 2. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
}

- (void)navBackAction {
    
    // 页面将要消失的时候设置状态条文字颜色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self.navigationController popViewControllerAnimated:YES];
}



@end
