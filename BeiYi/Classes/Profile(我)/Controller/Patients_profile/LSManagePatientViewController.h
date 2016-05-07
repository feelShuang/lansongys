//
//  LSManagePatientViewController.h
//  BeiYi
//
//  Created by LiuShuang on 15/5/21.
//  Copyright (c) 2015年 LiuShuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSManagePatientDelegate <NSObject>
@optional
/**
 *  传值【就诊人姓名】
 */
- (void)passPatientName:(NSString *)name;


@end

/**
 *  管理就诊人 控制器
 */
@interface LSManagePatientViewController : UITableViewController

@property (nonatomic, weak) id<LSManagePatientDelegate> delegate;

@end
