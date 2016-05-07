//
//  DoctorView.m
//  BeiYi
//
//  Created by Joe on 15/5/19.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#define w self.frame.size.width
#define h self.frame.size.height

#import "DoctorView.h"

@interface DoctorView()
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *lblName;
@property (strong, nonatomic) UILabel *lblEntry;
@property (strong, nonatomic) UILabel *lblHospital;

@end

@implementation DoctorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}
+ (instancetype)doctorViewWithFrame:(CGRect)frame icon:(NSString *)icon name:(NSString *)name entry:(NSString *)entry hospital:(NSString *)hospital {
    return [[self alloc] initWithFrame:frame];
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        self.iconView = [[UIImageView alloc] init];
        [self addSubview:self.iconView];
    }
    return _iconView;
}

- (UILabel *)lblName {
    if (_lblName == nil) {
        self.lblName = [[UILabel alloc] init];
        [self addSubview:self.lblName];
    }
    return _lblName;
}

- (UILabel *)lblEntry {
    if (_lblEntry == nil) {
        self.lblEntry = [[UILabel alloc] init];
        [self addSubview:self.lblEntry];
    }
    return _lblEntry;
}

- (UILabel *)lblHospital {
    if (_lblHospital == nil) {
        self.lblHospital = [[UILabel alloc] init];
        [self addSubview:self.lblHospital];
    }
    return _lblHospital;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconView.frame = CGRectMake(100, 20, 80, 80);
    self.lblName.frame = CGRectMake(100, 120, 200, 20);
    self.lblEntry.frame = CGRectMake(100, 150, 200, 20);
    self.lblHospital.frame = CGRectMake(100, 180, 200, 20);
}

@end
