//
//  SeclectTimeTableViewCell.h
//  BeiYi
//
//  Created by 刘爽 on 16/2/22.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeclectTimeTableViewCell : UITableViewCell

// 时间字符串
@property (weak, nonatomic) IBOutlet UILabel *timeStrLabel;
// 选择按钮
@property (weak, nonatomic) IBOutlet UIButton *seclectButton;

@end
