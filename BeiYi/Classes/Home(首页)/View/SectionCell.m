//
//  SectionCell.m
//  BeiYi
//
//  Created by Joe on 15/5/19.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "SectionCell.h"
#import "Common.h"

@implementation SectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 1.字体设置
        self.lblTitle.font = [UIFont systemFontOfSize:14];
        self.lblTitle.textColor = ZZTitleColor;
        
        self.txField.font = [UIFont systemFontOfSize:14];
        self.txField.textColor = ZZDetailStrColor;
        self.txField.textAlignment = NSTextAlignmentRight;
        
        // 2.设置cell的分割线完全显示
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cellIdentify";
    SectionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

// 点击return按钮，去掉键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.txField resignFirstResponder];
    return YES;
}

- (void)setCel:(CellModel *)cel {
    self.icon.image = [UIImage imageNamed:cel.img];
    self.lblTitle.text = cel.title;
    self.txField.placeholder = cel.pleaceholder;
}

- (UILabel *)lblTitle {
    if (_lblTitle == nil) {
        self.lblTitle = [[UILabel alloc] init];
        [self addSubview:self.lblTitle];
    }
    return _lblTitle;
}

- (UIImageView *)icon {
    if (_icon == nil) {
        self.icon = [[UIImageView alloc] init];
        [self addSubview:self.icon];
    }
    return _icon;
}

- (UITextField *)txField {
    if (_txField == nil) {
        self.txField = [[UITextField alloc] init];
        [self addSubview:self.txField];
    }
    return _txField;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.icon.frame = CGRectMake(10, 10, 20, 20);

    self.lblTitle.frame = CGRectMake(15, 5, 80, 30);
    
    self.txField.frame = CGRectMake(110, 5, self.contentView.frame.size.width - 125, 30);
}

@end
