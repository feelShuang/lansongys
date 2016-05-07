//
//  LSRecommendDoctor.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/6.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSRecommendDoctor : NSObject

/** 头像 */
@property (nonatomic, strong) NSURL *avator;

/** 医生等级字符串 */
@property (nonatomic, copy) NSString *level_str;

/** 医生评分 */
@property (nonatomic, copy) NSString *avg_score;

/** 医生id */
@property (nonatomic, copy) NSString *doctor_id;

/** 医生等级 */
@property (nonatomic, copy) NSString *level;

/** 就诊人数量 */
@property (nonatomic, copy) NSString *visit_count;

/** 科室名称 */
@property (nonatomic, copy) NSString *dept_name;

/** 医院简称 */
@property (nonatomic, copy) NSString *short_name;

/** 医生姓名 */
@property (nonatomic, copy) NSString *name;

@end
