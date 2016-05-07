//
//  LSNewFeatureCell.m
//  BeiYi
//
//  Created by 刘爽 on 16/3/2.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "LSNewFeatureCell.h"
#import "ZZTabBarController.h"
#import "Common.h"

@interface LSNewFeatureCell ()

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UIButton *startButton;

@end

@implementation LSNewFeatureCell

- (UIButton *)startButton
{
    if (_startButton == nil) {
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [startBtn setBackgroundImage:[UIImage imageNamed:@"button_3"] forState:UIControlStateNormal];
//        [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
        [startBtn sizeToFit];
        [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startBtn];
        _startButton = startBtn;

    }
    return _startButton;
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        
        _imageView = imageV;
        
        // 注意:一定要加载contentView
        [self.contentView addSubview:imageV];
        
    }
    return _imageView;
}

// 布局子控件的frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    
    // 开始按钮
    self.startButton.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.472, SCREEN_WIDTH * 0.472 * 42 / 177);
     self.startButton.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.79 + CGRectGetHeight(self.startButton.frame) / 2);
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
}

// 判断当前cell是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count
{
    if (indexPath.row == count - 1) { // 最后一页,显示分享和开始按钮

        self.startButton.hidden = NO;
        
        
    }else{ // 非最后一页，隐藏分享和开始按钮

        self.startButton.hidden = YES;
    }
}

// 点击开始微博的时候调用
- (void)start
{
    // 进入tabBarVc
    ZZTabBarController *tabBarVc = [[ZZTabBarController alloc] init];
    
    // 切换根控制器:可以直接把之前的根控制器清空
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;

}

@end
