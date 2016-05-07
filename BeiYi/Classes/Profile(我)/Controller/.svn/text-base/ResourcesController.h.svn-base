//
//  ResourcesController.h
//  BeiYi
//
//  Created by Joe on 15/4/27.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

// 代理传值(传包含医院id的数组返回)
@protocol TagsDelegate <NSObject>

@optional
- (void)getTagsArray:(NSMutableArray *)array;

@end

/** 医院资源选择 */
@interface ResourcesController : UIViewController

@property (nonatomic, weak) id<TagsDelegate> delegate;

@end
