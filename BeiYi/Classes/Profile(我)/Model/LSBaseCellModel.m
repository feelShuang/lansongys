//
//  LSBaseCellModel.m
//  BeiYi
//
//  Created by LiuShuang on 16/3/22.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "LSBaseCellModel.h"

@implementation LSBaseCellModel

+ (instancetype)modelWithImage:(UIImage *)image
                   targetClass:(Class)targetClass
                  clickHandler:(void(^)())clickHandler
                         title:(NSString *)title
                      subTitle:(NSString *)subTitle {
    
    LSBaseCellModel *model = [[self alloc] init];
    
    model.image = image;
    model.targetClass = targetClass;
    model.clickHandler = clickHandler;
    model.title = title;
    model.subTitle = subTitle;
    
    return model;
}

@end
