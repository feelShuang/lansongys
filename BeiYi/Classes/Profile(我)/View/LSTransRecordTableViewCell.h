//
//  LSTransRecordTableViewCell.h
//  BeiYi
//
//  Created by LiuShuang on 16/2/17.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSRecord;

@interface LSTransRecordTableViewCell : UITableViewCell

/**
 *  交易记录模型
 */
@property (nonatomic, strong) LSRecord *record;

@end
