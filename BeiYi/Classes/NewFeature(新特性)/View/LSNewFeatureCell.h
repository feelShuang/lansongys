//
//  LSNewFeatureCell.h
//  BeiYi
//
//  Created by 刘爽 on 16/3/2.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSNewFeatureCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;


// 判断是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count;
@end
