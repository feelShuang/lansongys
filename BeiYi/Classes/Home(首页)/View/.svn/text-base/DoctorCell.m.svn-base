//
//  DoctorCell.m
//  BeiYi
//
//  Created by Joe on 15/5/18.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "DoctorCell.h"
#import "Doctor.h"
#import "UIImageView+WebCache.h"
#import "Common.h"

@interface DoctorCell()
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *lblTitle;
@property (strong, nonatomic) UILabel *lblLevel;
@end
@implementation DoctorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.lblTitle.font = [UIFont systemFontOfSize:17];
        self.lblLevel.font = [UIFont systemFontOfSize:13];
        self.lblLevel.textColor = [UIColor darkGrayColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"DoctorCell";
    DoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[DoctorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (UIImageView *)iconView {
    if (_iconView == nil) {
        self.iconView = [[UIImageView alloc] init];
        [self addSubview:self.iconView];
    }
    return _iconView;
}

- (UILabel *)lblTitle {
    if (_lblTitle == nil) {
        self.lblTitle = [[UILabel alloc] init];
        [self addSubview:self.lblTitle];
    }
    return _lblTitle;
}

- (UILabel *)lblLevel {
    if (_lblLevel == nil) {
        self.lblLevel = [[UILabel alloc] init];
        [self addSubview:self.lblLevel];
    }
    return _lblLevel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconView.frame = CGRectMake(5, 5, 70, 70);
    self.lblTitle.frame = CGRectMake(90, 20, 200, 20);
    self.lblLevel.frame = CGRectMake(90, 50, 200, 20);
}

- (void)setDoctor:(Doctor *)doctor {
    _doctor = doctor;
    
    // 1.头像
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:doctor.avator] placeholderImage:DEFAULT_LOADING_IMAGE];
    
    // 2.医生姓名
    self.lblTitle.text = doctor.name;
    
    /**  医生级别（1-医师2-主治医师3-副主任医师4-主任医师）*/
    NSString *level;
    switch (doctor.level) {
        case 1:
            level = @"医师";
            break;
        case 2:
            level = @"主治医师";
            break;
        case 3:
            level = @"副主任医师";
            break;
        case 4:
            level = @"主任医师";
            break;
        default:
            break;
    }

    // 3.医生级别
    self.lblLevel.text = level;
}

@end
