//
//  LSPullDownMenu.h
//  BeiYi
//
//  Created by LiuShuang on 16/3/23.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSPullDownMenu;

@protocol LSPullDownMenuDelegate <NSObject>

// 有n个选择标签
- (NSInteger)numberOfItem;
// 每个标签有几行内容
- (NSInteger)numberOfRowsInItem:(NSInteger)item;
// 每个item的title
- (NSString *)titleInItem:(NSInteger)item index:(NSInteger)index;
// 默认选中
- (NSInteger)defaultShowItem:(NSInteger)item;

@end

@interface LSPullDownMenu : UIView

/** 设置Menu的frame */
@property (nonatomic, assign) CGRect menuFrame;
/** 设置字体大小 */
@property (nonatomic, assign) CGFloat font;
/** 设置Menu的tintColor */
@property (nonatomic, strong) UIColor *tintColor;
/** 设置Menu的箭头图片 */
@property (nonatomic, strong) UIImage *arrowImg;

/** Menu代理 */
@property (nonatomic, assign) id<LSPullDownMenuDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame
                   TitleArray:(NSArray *)titleArray
                  selectColor:(UIColor *)selectColor
                       btnImg:(UIImage *)btnImg;
/**
 *  @param titleArr
 */
- (void)setTitleWithTitleArr:(NSArray *)titleArr;

@end
