//
//  LSTransRecordTableViewCell.m
//  BeiYi
//
//  Created by LiuShuang on 16/2/17.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSTransRecordTableViewCell.h"
#import "LSRecord.h"

@interface LSTransRecordTableViewCell ()

/** 交易类型 */
@property (weak, nonatomic) IBOutlet UILabel *recordTypeLabel;
/** 交易日期 */
@property (weak, nonatomic) IBOutlet UILabel *recordTimeLabel;
/** 余额 */
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
/** 交易价格 */
@property (weak, nonatomic) IBOutlet UILabel *recordPriceLabel;

@end

@implementation LSTransRecordTableViewCell

- (void)setRecord:(LSRecord *)record {
    _record = record;

    if ([record.flow_type isEqualToString:@"1"]) {
        self.recordPriceLabel.text = [NSString stringWithFormat:@"+%@.00",record.price];
    }
    else {
        self.recordPriceLabel.text = [NSString stringWithFormat:@"-%@.00",record.price];
    }

    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
