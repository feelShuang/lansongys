//
//  LSServicePrice.h
//  BeiYi
//
//  Created by LiuShuang on 16/2/16.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSServicePrice : NSObject

// 是否开放
@property (nonatomic, copy) NSString *open_flag;
// 服务类型
@property (nonatomic, copy) NSString *service_type;
// 服务价格
@property (nonatomic, copy) NSString *price;
// 附加服务类型
@property (nonatomic, copy) NSString *attach_type;
// 附加服务价格
@property (nonatomic, copy) NSString *attach_price;

@end
