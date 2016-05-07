//
//  AppointmentTableViewCell.m
//  BeiYi
//
//  Created by 刘爽 on 16/1/15.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "AppointmentTableViewCell.h"
#import "Common.h"

@implementation AppointmentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 1.字体设置
        self.lbTitle.font = [UIFont systemFontOfSize:15];
        self.lbTitle.textColor = ZZColor(51, 51, 51, 1);
        self.lbTitle.text = @"是否优质服务";
        
        // 2.设置cell的分割线完全显示
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    return self;
}

// 通过tableView创建一个Cell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *AppointmentID = @"AppointcellIdentify";
    AppointmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AppointmentID];
    if (cell == nil) {
        cell = [[AppointmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AppointmentID];
    }
    return cell;
    
}

- (UILabel *)lblTitle {
    if (_lbTitle == nil) {
        self.lbTitle = [[UILabel alloc] init];
        [self addSubview:self.lblTitle];
    }
    return _lbTitle;
}

- (UIImageView *)icon {
    if (_icon == nil) {
        self.icon = [[UIImageView alloc] init];
        [self addSubview:self.icon];
    }
    return _icon;
}

- (UIImageView *)okBtn {
    if (_okBtn == nil) {
        self.okBtn = [[UIImageView alloc] init];
        [self addSubview:self.okBtn];
    }
    return _okBtn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.icon.frame = CGRectMake(10, 10, 20, 20);
    
    self.lblTitle.frame = CGRectMake(40, 5, 100, 30);
    
    self.okBtn.frame = CGRectMake(SCREEN_WIDTH - 50, 10, 20, 20);
}


@end
