//
//  PayCell.m
//  BeiYi
//
//  Created by Joe on 15/6/3.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "PayCell.h"
#import "Common.h"

@implementation PayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 取消选中（点击不变灰）
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 1.字体设置
        self.lbl1.font = [UIFont systemFontOfSize:15];
        self.lbl1.text = @"就诊人信息";
        self.lbl1.textColor = ZZColor(51, 51, 51, 1);

        self.lbl2.font = [UIFont systemFontOfSize:12.5];
        self.lbl2.text = @"患者姓名: ";
        self.lbl2.textColor = ZZColor(51, 51, 51, 1);

        self.lbl2Detail.font = [UIFont systemFontOfSize:12.5];
        self.lbl2Detail.textColor = ZZBaseColor;

        self.lbl3.font = [UIFont systemFontOfSize:12.5];
        self.lbl3.textColor = ZZColor(51, 51, 51, 1);

        self.lbl4.font = [UIFont systemFontOfSize:12.5];
        self.lbl4.textColor = ZZColor(51, 51, 51, 1);

        self.lbl5.font = [UIFont systemFontOfSize:12.5];
        self.lbl5.textColor = ZZColor(51, 51, 51, 1);
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cellIdentify";
    PayCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

- (UILabel *)lbl2Detail {
    if (_lbl2Detail == nil) {
        self.lbl2Detail = [[UILabel alloc] init];
        [self addSubview:self.lbl2Detail];
    }
    return _lbl2Detail;
}

- (UILabel *)lbl3 {
    if (_lbl3 == nil) {
        self.lbl3 = [[UILabel alloc] init];
        [self addSubview:self.lbl3];
    }
    return _lbl3;
}

- (UILabel *)lbl4 {
    if (_lbl4 == nil) {
        self.lbl4 = [[UILabel alloc] init];
        [self addSubview:self.lbl4];
    }
    return _lbl4;
}

- (UILabel *)lbl5 {
    if (_lbl5 == nil) {
        self.lbl5 = [[UILabel alloc] init];
        [self addSubview:self.lbl5];
    }
    return _lbl5;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.lbl1.frame = CGRectMake(15, 8, 200, 30);
    
    CGSize lbl2Size = CGSizeMake(10000, 20);// 宽度自适应
    CGSize lbl2SizeNew = [self.lbl2.text boundingRectWithSize:lbl2Size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.5]} context:nil].size;
    
    self.lbl2.frame = CGRectMake(30, 46, lbl2SizeNew.width, lbl2SizeNew.height);
    
    self.lbl2Detail.frame = CGRectMake(CGRectGetMaxX(self.lbl2.frame), 44, 80, 20);

    self.lbl3.frame = CGRectMake(30, 66, 250, 20);
    self.lbl4.frame = CGRectMake(30, 86, 250, 20);

    self.lbl5.frame = CGRectMake(CGRectGetMaxX(self.lbl2Detail.frame)+20, 44, 100, 20);
}

@end
