//
//  ZZSelectedView.h
//  NewText
//
//  Created by Joe on 15/4/27.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZSelectedView;

@protocol ZZSelectedViewDelegate <NSObject>
@optional
- (void)ZZSelectedViewDidClickedBtnMan:(ZZSelectedView *)selectedView;
- (void)ZZSelectedViewDidClickedBtnWoman:(ZZSelectedView *)selectedView;

@end

@interface ZZSelectedView : UIView

@property (nonatomic, strong) UIButton *btnMan;
@property (nonatomic, strong) UIButton *btnWoman;

- (instancetype)initWithFrame:(CGRect)frame selectOne:(NSString *)one selectTwo:(NSString *)two;

@property (nonatomic, weak) id<ZZSelectedViewDelegate> delegate;

@end
