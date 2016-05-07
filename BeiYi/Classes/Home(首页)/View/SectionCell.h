//
//  SectionCell.h
//  BeiYi
//
//  Created by Joe on 15/5/19.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"

@interface SectionCell : UITableViewCell

@property (strong, nonatomic) UITextField *txField;
@property (strong, nonatomic) UILabel *lblTitle;
@property (strong, nonatomic) UIImageView *icon;

@property (nonatomic ,strong) CellModel *cel;

/**
 *  通过一个tableView来创建一个cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

// 点击return按钮，去掉键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

// 点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end
