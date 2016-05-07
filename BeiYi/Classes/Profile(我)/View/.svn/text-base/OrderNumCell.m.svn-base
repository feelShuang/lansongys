//
//  OrderNumCell.m
//  BeiYi
//
//  Created by Joe on 15/7/23.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "OrderNumCell.h"
#import "Common.h"

@implementation OrderNumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 取消选中（点击不变灰）
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.lblOrderNum.textColor = ZZColor(51, 51, 51, 1);
        self.lblOrderNum.font = [UIFont systemFontOfSize:12.5];
        self.lblOrderNum.textAlignment = NSTextAlignmentRight;
        
        self.lblPrice.font = [UIFont systemFontOfSize:12.5];
        self.lblPrice.textColor = ZZButtonClickedColor;
        self.lblPrice.textAlignment = NSTextAlignmentRight;
        
        self.lblPriceDetail.font = [UIFont systemFontOfSize:17];
        self.lblPriceDetail.textColor = ZZButtonClickedColor;
        self.lblPriceDetail.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableVeiw {
    static NSString *ID = @"OrderNumCell";
    OrderNumCell *cell = [tableVeiw dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[OrderNumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (UILabel *)lblOrderNum {
    if (_lblOrderNum == nil) {
        self.lblOrderNum = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblOrderNum];
    }
    return _lblOrderNum;
}

- (UILabel *)lblPrice {
    if (_lblPrice == nil) {
        self.lblPrice = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblPrice];
    }
    return _lblPrice;
}

- (UILabel *)lblPriceDetail {
    if (_lblPriceDetail == nil) {
        self.lblPriceDetail = [[UILabel alloc] init];
        [self.contentView addSubview:self.lblPriceDetail];
    }
    return _lblPriceDetail;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = self.contentView.frame.size.width;
    
        self.lblOrderNum.frame = CGRectMake(w -215, 0, 200, 30);
    
        // 宽度自适应
        CGSize SizeNew = [self.lblPriceDetail.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size;
    
        self.lblPriceDetail.frame = CGRectMake(w -15 - SizeNew.width, 34, SizeNew.width, SizeNew.height);
    
        CGFloat lblPriceX = self.lblPriceDetail.frame.origin.x - 80;
        self.lblPrice.frame = CGRectMake(lblPriceX, 30, 80, 30);

}

@end
