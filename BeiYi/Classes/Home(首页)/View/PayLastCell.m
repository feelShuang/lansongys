//
//  PayLastCell.m
//  BeiYi
//
//  Created by Joe on 15/6/3.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "PayLastCell.h"

@implementation PayLastCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 1.字体设置
        self.lbl1.font = [UIFont systemFontOfSize:15];
        self.lbl2.font = [UIFont systemFontOfSize:15];
        self.lbl3.font = [UIFont systemFontOfSize:15];
        
        // 2.设置cell的分割线完全显示
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cellIdentify";
    PayLastCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PayLastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (UILabel *)lbl1 {
    if (_lbl1 == nil) {
        self.lbl1 = [[UILabel alloc] init];
        [self addSubview:self.lbl1];
    }
    return _lbl1;
}

- (UILabel *)lbl2 {
    if (_lbl2 == nil) {
        self.lbl2 = [[UILabel alloc] init];
        [self addSubview:self.lbl2];
    }
    return _lbl2;
}

- (UILabel *)lbl3 {
    if (_lbl3 == nil) {
        self.lbl3 = [[UILabel alloc] init];
        [self addSubview:self.lbl3];
    }
    return _lbl3;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.lbl1.frame = CGRectMake(10, 5, 300, 20);
    self.lbl2.frame = CGRectMake(10, 25, 300, 20);
    self.lbl3.frame = CGRectMake(10, 45, 300, 20);
    
}

@end
