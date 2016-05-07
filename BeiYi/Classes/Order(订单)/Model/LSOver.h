//
//  LSOver.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/18.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSOver : NSObject

/**
 *  凭证信息模型
 */
/*
over_over = {
images = <null>,
confirm_time = <null>,
over_status = 1,
id = 1,
memo = 请在就医时出示此凭证,
refuse_reason = <null>,
over_time = 2016-04-18 13:17:21,
visit_start = 2016-06-03 00:00:00
},
*/
@property (nonatomic, strong) NSString *images;
/** 提交时间 */
@property (nonatomic, copy) NSString *confirm_time;
/** over_status */
@property (nonatomic, copy) NSString *over_status;
/** id */
@property (nonatomic, copy) NSString *over_id;
/** 拒绝原因 */
@property (nonatomic, copy) NSString *refuse_reason;
/** overTime */
@property (nonatomic, copy) NSString *over_time;
/** 就诊开始时间 */
@property (nonatomic, copy) NSString *visit_start;

@end
