//
//  LSPatientDoctor.h
//  BeiYi
//
//  Created by LiuShuang on 16/4/7.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSPatientDoctor : NSObject

/** 头像 */
@property (nonatomic, strong) NSURL *avator;

/** 医生评分 */
@property (nonatomic, copy) NSString *avg_score;

/** 医院名称 */
@property (nonatomic, copy) NSString *hospital_name;

/** 医生id */
@property (nonatomic, copy) NSString *doctor_id;

/** 医生等级 */
@property (nonatomic, copy) NSString *level;

/** 医生擅长*/
@property (nonatomic, copy) NSString *good_at;

/** 科室id */
@property (nonatomic, copy) NSString *department_id;

/** 就诊人数 */
@property (nonatomic, copy) NSString *visit_count;

/** 科室名称 */
@property (nonatomic, copy) NSString *dept_name;

/** 医院id */
@property (nonatomic, copy) NSString *hospital_id;

/** 医生姓名 */
@property (nonatomic, copy) NSString *name;

@end
