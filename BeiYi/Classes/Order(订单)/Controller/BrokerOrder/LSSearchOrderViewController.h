//
//  LSSearchOrderViewController.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/22.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSSearchOrderViewController;

@protocol LSSearchOrderDelegate <NSObject>

- (void)searchOrderController:(LSSearchOrderViewController *)searchOrderVC keyWord:(NSString *)keyword order_status:(NSString *)order_status order_type:(NSString *)order_type startTime:(NSString *)start endTime:(NSString *)end;

@end

@interface LSSearchOrderViewController : UIViewController

@property (nonatomic, assign) id<LSSearchOrderDelegate> delegate;

@end
