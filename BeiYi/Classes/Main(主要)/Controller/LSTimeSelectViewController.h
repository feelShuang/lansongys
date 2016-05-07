//
//  LSTimeSelectViewController.h
//  BeiYi
//
//  Created by LiuShuang on 16/3/25.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSTimeSelectViewController;

@protocol LSTimeSelectDelegate <NSObject>

- (void)timeSelect:(LSTimeSelectViewController *)timeSelect selectTimeWithTimeArray:(NSArray *)timeArray;

@end

@interface LSTimeSelectViewController : UIViewController

@property (nonatomic, assign) id<LSTimeSelectDelegate> delegate;

@end
