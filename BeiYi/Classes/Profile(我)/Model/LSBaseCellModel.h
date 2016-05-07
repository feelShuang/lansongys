//
//  LSBaseCellModel.h
//  BeiYi
//
//  Created by LiuShuang on 16/3/22.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LSBaseCellModel : NSObject
/** 图标 */
@property (nonatomic, strong) UIImage *image;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 副标题 */
@property (nonatomic, copy) NSString *subTitle;
/** 点击后跳转到那个控制器 */
@property (nonatomic, assign) Class targetClass;
/** 点击后的操作（优先级高于TargetClass) */
@property (nonatomic, copy)   void (^clickHandler)();

/**
 *  快读创建BaseCellModel
 *  @param iamge        图标
 *  @param title        标题文字
 *  @param subTitle     子标题文字/详情
 *  @param targetClass  点击后跳转的类
 *  @param clickhandler 点击后的处理记过(优先级高于targetClass)
 *
 *  @return 实例化后的对象
 */
+ (instancetype)modelWithImage:(UIImage *)image
                   targetClass:(Class)targetClass
                   clickHandler:(void(^)())clickHandler
                         title:(NSString *)title
                      subTitle:(NSString *)subTitle;

@end
