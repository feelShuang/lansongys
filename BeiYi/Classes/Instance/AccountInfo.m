//
//  AccountInfo.m
//  BeiYi
//
//  Created by 刘爽 on 16/2/25.
//  Copyright © 2016年 Joe. All rights reserved.
//

#define HeadIconPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"headIcon.png"]

#import "AccountInfo.h"
#import "Common.h"
#import "Avatar.h"

@implementation AccountInfo

#pragma mark - 读取账号信息
+ (void)getAccount {
    if (myAccount) {
        // 1.准备参数
        NSString *urlStr = [NSString stringWithFormat:@"%@/uc/my",BASEURL] ;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        ZZLog(@"%@",myAccount.token);
        [params setObject:myAccount.token forKey:@"token"];
        
        [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseDict) {
            ZZLog(@"%@",responseDict);
            if ([responseDict[@"code"] isEqual:@"0000"]) {
                
                // 把头像地址保存到单例
                [Avatar sharedInstance].avator = responseDict[@"result"][@"avator"];
                
                
            }else {
                
                // 0.删除本地头像图片，防止多账号冲突
                [[NSFileManager defaultManager] removeItemAtPath:HeadIconPath error:nil];
                
                // 1.移除账号存储信息
                [ZZAccountTool deleteAccount];
                
                // 2.显示遮盖
                [MBProgressHUD showSuccess:@"请重新登陆！"];
                
            }
            
        } failure:^(NSError *error) {
            ZZLog(@"%@",error);
        }];
    }
}

@end
