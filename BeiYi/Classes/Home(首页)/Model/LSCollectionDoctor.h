//
//  LSCollectionDoctor.h
//  BeiYi
//
//  Created by LiuShuang on 16/2/24.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSCollectionDoctor : NSObject
/**
 *  收藏的医生模型
 */

/** 医生头像 */
@property (nonatomic, strong) NSURL *avator;

/** 医生级别名称 */
@property (nonatomic, copy) NSString *level_str;

/** 医生所属医院 */
@property (nonatomic, copy) NSString *hospital_name;

/** 医生ID */
@property (nonatomic, copy) NSString *doc_id;

/** 医生级别 */
@property (nonatomic, copy) NSString *level;

/** 医生擅长 */
@property (nonatomic, copy) NSString *good_at;

/** 医生所属科室 */
@property (nonatomic, copy) NSString *department_name;

/** 医院ID */
@property (nonatomic, copy) NSString *hospital_id;

/** 医生姓名 */
@property (nonatomic, copy) NSString *name;

@end
