//
//  LSEvaluate.h
//  BeiYi
//
//  Created by LiuShuang on 16/5/5.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSEvaluate : NSObject
/**
 *  用户评论模型
 */

/** 用户ID */
@property (nonatomic, copy) NSString *user_id;
/** 评论内容 */
@property (nonatomic, copy) NSString *content;
/** 分数 */
@property (nonatomic, copy) NSString *score;
/** 手机号码 */
@property (nonatomic, copy) NSString *mobile;
/** 评论时间 */
@property (nonatomic, copy) NSString *show_time;
/** 成员ID */
@property (nonatomic, copy) NSString *member_id;

@end
