//
//  ZZSelectedView.m
//  NewText
//
//  Created by Joe on 15/4/27.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ZZSelectedView.h"
#import "Common.h"

@interface ZZSelectedView()

@end

@implementation ZZSelectedView

- (instancetype)initWithFrame:(CGRect)frame selectOne:(NSString *)one selectTwo:(NSString *)two {
    if (self = [super initWithFrame:frame]) {
        [self.btnMan setImage:[UIImage imageNamed:@"service_mo_ren"] forState:UIControlStateNormal];
        [self.btnMan setImage:[UIImage imageNamed:@"service_xuan_ze"] forState:UIControlStateSelected];
        [self.btnMan setTitleColor:ZZDetailStrColor forState:UIControlStateNormal];
        self.btnMan.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.btnMan setTitle:one forState:UIControlStateNormal];
        [self.btnMan addTarget:self action:@selector(btnManClicked) forControlEvents:UIControlEventTouchUpInside];
        self.btnMan.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        [self addSubview:self.btnMan];
        
        
        [self.btnWoman setImage:[UIImage imageNamed:@"service_mo_ren"] forState:UIControlStateNormal];
        [self.btnWoman setImage:[UIImage imageNamed:@"service_xuan_ze"] forState:UIControlStateSelected];
        [self.btnWoman setTitleColor:ZZDetailStrColor forState:UIControlStateNormal];
        self.btnWoman.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.btnWoman setTitle:two forState:UIControlStateNormal];
        [self.btnWoman addTarget:self action:@selector(btnWomanClicked) forControlEvents:UIControlEventTouchUpInside];
        self.btnWoman.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        [self addSubview:self.btnWoman];
    }
    return self;
}

- (UIButton *)btnMan {
    if (!_btnMan) {
        self.btnMan = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _btnMan;
}

- (UIButton *)btnWoman {
    if (!_btnWoman) {
        self.btnWoman = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _btnWoman;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;

    self.btnMan.frame = CGRectMake(w - w/4 - 50, 0, w/4, h);
    self.btnWoman.frame = CGRectMake(w - w/5 + 5, 0, w/4, h);
}

- (void)btnManClicked {
    if ([self.delegate respondsToSelector:@selector(ZZSelectedViewDidClickedBtnMan:)]) {
        [self.delegate ZZSelectedViewDidClickedBtnMan:self];
    }
}

- (void)btnWomanClicked {
    if ([self.delegate respondsToSelector:@selector(ZZSelectedViewDidClickedBtnWoman:)]) {
        [self.delegate ZZSelectedViewDidClickedBtnWoman:self];
    }
}
@end
