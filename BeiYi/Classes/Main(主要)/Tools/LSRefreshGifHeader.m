//
//  LSRefreshGifHeader.m
//  BeiYi
//
//  Created by LiuShuang on 16/5/6.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSRefreshGifHeader.h"

@interface LSRefreshGifHeader ()

@property (strong, nonatomic) UIImageView *sloganImage;

@end

@implementation LSRefreshGifHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 100;
    
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    self.stateLabel.hidden = YES;
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=13; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 14; i<=24; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    // slogan
    self.sloganImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slogan"]];
    self.sloganImage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_sloganImage];
}

#pragma mark - 重写布局方法
- (void)placeSubviews
{
    [super placeSubviews];
    
    // 自定义布局
    self.sloganImage.center = CGPointMake(self.mj_w / 2, self.mj_h * 0.755);
    self.gifView.center = CGPointMake(self.mj_w / 2, self.mj_h * 0.36);
    
    if (self.stateLabel.hidden) return;
    
    BOOL noConstrainsOnStatusLabel = self.stateLabel.constraints.count == 0;
    
    if (self.lastUpdatedTimeLabel.hidden) {
        // 状态
        if (noConstrainsOnStatusLabel) self.stateLabel.frame = self.bounds;
    } else {
        CGFloat stateLabelH = self.mj_h * 0.5;
        // 状态
        if (noConstrainsOnStatusLabel) {
            self.stateLabel.mj_x = 0;
            self.stateLabel.mj_y = 0;
            self.stateLabel.mj_w = self.mj_w;
            self.stateLabel.mj_h = stateLabelH;
        }
        
        // 更新时间
        if (self.lastUpdatedTimeLabel.constraints.count == 0) {
            self.lastUpdatedTimeLabel.mj_x = 0;
            self.lastUpdatedTimeLabel.mj_y = stateLabelH;
            self.lastUpdatedTimeLabel.mj_w = self.mj_w;
            self.lastUpdatedTimeLabel.mj_h = self.mj_h - self.lastUpdatedTimeLabel.mj_y;
        }
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
}

@end
