//
//  LSLocalFile.m
//  BeiYi
//
//  Created by 刘爽 on 16/1/22.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "LSLocalFile.h"

@implementation LSLocalFile

#pragma mark - 获取本地文件并解析
+ (NSArray *)loadJSONDataWithResource:(NSString *)Resource type:(NSString *)type {
    
    // 获取文件路径
    NSString *Path = [[NSBundle mainBundle] pathForResource:Resource ofType:type];
    // 创建data对象
    NSData *data = [NSData dataWithContentsOfFile:Path];
    // 解析文件
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    
    return array;
}

@end
