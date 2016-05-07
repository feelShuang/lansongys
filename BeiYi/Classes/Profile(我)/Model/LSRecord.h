//
//  LSRecord.h
//  BeiYi
//
//  Created by LiuShuang on 16/2/17.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSRecord : NSObject

// 交易编号
@property (nonatomic, copy) NSString *trader_code;
// 星期
@property (nonatomic, copy) NSString *date1;
// 价格
@property (nonatomic, copy) NSString *price;
// 创建时间
@property (nonatomic, copy) NSString *created_at;
// 交易类型 1-收入，2-支出
@property (nonatomic, copy) NSString *flow_type;
// 交易信息
@property (nonatomic, copy) NSString *flow_memo;
// 交易时间
@property (nonatomic, copy) NSString *date2;

@end
