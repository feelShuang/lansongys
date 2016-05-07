//
//  ZZAccountTool.m
//  BeiYi
//
//  Created by Joe on 15/5/20.
//  Copyright (c) 2015年 Joe. All rights reserved.
//
#define ZZFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

#import "ZZAccountTool.h"
#import "ZZAccount.h"
#import "Common.h"

@implementation ZZAccountTool

+ (void)save:(ZZAccount *)account {
    // 归档
    [NSKeyedArchiver archiveRootObject:account toFile:ZZFilePath];
}

+ (ZZAccount *)account {
    // 读取帐号
    ZZAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:ZZFilePath];
    return account;
}

+ (void)deleteAccount {
    // 1.判断文件是否存在
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:ZZFilePath];
    
    // 2.如果存在，删除文件
    if (isExist) { // 文件存在
        ZZLog(@"--文件存在--");
        BOOL isDele = [[NSFileManager defaultManager] removeItemAtPath:ZZFilePath error:nil];
        if (isDele) { // 删除文件成功
            ZZLog(@"--删除文件成功--");
        }else { // 删除文件失败
            ZZLog(@"--删除文件失败--");
        }
    }else { // 文件不存在
        ZZLog(@"--文件不存在--");
    }
}
@end
