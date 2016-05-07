//
//  Service.h
//  BeiYi
//
//  Created by 刘爽 on 16/1/28.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Service : NSObject

// 服务类型
@property (nonatomic, copy) NSString *service_type;
// 是够开放
@property (nonatomic, copy) NSString *open_flag;

@end
