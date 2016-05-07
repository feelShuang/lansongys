//
//  OrderTimeCell.m
//  BeiYi
//
//  Created by Joe on 15/7/2.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "OrderTimeCell.h"
#import "Common.h"

@interface OrderTimeCell()
/** UIButton 上午 */
@property (nonatomic, strong) UIButton *btnMorning;
/** UIButton 下午 */
@property (nonatomic, strong) UIButton *btnAfternoon;

@end

@implementation OrderTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.btnMorning setTitle:@"上午" forState:UIControlStateNormal];
        [self.btnMorning setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnMorning.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.btnMorning setImage:[UIImage imageNamed:@"OKBtn"] forState:UIControlStateNormal];
        [self.btnMorning setImage:[UIImage imageNamed:@"OKBtn_Clicked"] forState:UIControlStateSelected];
        [self.btnMorning addTarget:self action:@selector(btnMorningClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnAfternoon setTitle:@"下午" forState:UIControlStateNormal];
        [self.btnAfternoon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnAfternoon.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.btnAfternoon setImage:[UIImage imageNamed:@"OKBtn"] forState:UIControlStateNormal];
        [self.btnAfternoon setImage:[UIImage imageNamed:@"OKBtn_Clicked"] forState:UIControlStateSelected];
        [self.btnAfternoon addTarget:self action:@selector(btnAfternoonClicked) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    OrderTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[OrderTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (UIButton *)btnMorning {
    if (_btnMorning == nil) {
        self.btnMorning = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.btnMorning];
    }
    return _btnMorning;
}

- (UIButton *)btnAfternoon {
    if (_btnAfternoon == nil) {
        self.btnAfternoon = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.btnAfternoon];
    }
    return _btnAfternoon;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = self.contentView.frame.size.width;
    CGFloat h = self.contentView.frame.size.height;
    
    self.btnMorning.frame = CGRectMake(w -150, 0, 50, h);
    self.btnAfternoon.frame = CGRectMake(w -75, 0, 50, h);
}

- (void)btnMorningClicked {
    self.btnMorning.selected = YES;
    self.btnAfternoon.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(orderTimeCellSelectedBtnMorning:)]) {
        [self.delegate orderTimeCellSelectedBtnMorning:self];
    }
}

- (void)btnAfternoonClicked {
    self.btnAfternoon.selected = YES;
    self.btnMorning.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(orderTimeCellSelectedBtnAfternoon:)]) {
        [self.delegate orderTimeCellSelectedBtnAfternoon:self];
    }
}

@end
