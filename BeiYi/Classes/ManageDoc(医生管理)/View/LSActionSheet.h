//
//  LSActionSheet.h
//  BeiYi
//
//  Created by LiuShuang on 16/3/24.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSActionSheet;

@protocol LSActionSheetDelegate <NSObject>

- (void)LSActionSheet:(LSActionSheet *)LSActionSheet didClickButtonAtIndex:(NSInteger)index;

@end

@interface LSActionSheet : UIView

@property (nonatomic, assign) id<LSActionSheetDelegate> delegate;

- (instancetype)initWithDelegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle itemsButtonTitle:(NSArray *)itemsButtonTitle;
+ (instancetype)showActionSheetWithDelegate:(id)delegate cancleButtonTitle:(NSString *)cancleButtonTitle itemsButtonTitle:(NSArray *)itemsButtonTitle;

- (void)show;

@end
