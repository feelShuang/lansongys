//
//  LSDoctorDetail.h
//  BeiYi
//
//  Created by LiuShuang on 16/1/28.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
	audit_user_id = <null>,
	audit_memo = <null>,
	audit_time = <null>,
	created_type = <null>,
	audit_status = <null>,
	comment = {
	comment_feels = [
 ],
	comment_list = [
 ],
 */
@interface LSDoctorDetail : NSObject

// 医生id
@property (nonatomic, copy) NSString *doctor_id;
// 医生姓名
@property (nonatomic, copy) NSString *name;
// 科室
@property (nonatomic, copy) NSString *department_name;
// 电话
@property (nonatomic, copy) NSString *telephone;
// 性别
@property (nonatomic, copy) NSString *sex;
// 头像
@property (nonatomic, copy) NSString *avator;
// 医院名称
@property (nonatomic, copy) NSString *hospital_name;
// 介绍
@property (nonatomic, copy) NSString *memo;
// 擅长
@property (nonatomic, copy) NSString *good_at;
// 手机
@property (nonatomic, copy) NSString *mobile;
// 级别
@property (nonatomic, copy) NSString *level;
// 基础价格
@property (nonatomic, copy) NSString *base_price;
// 推荐时间
@property (nonatomic, copy) NSString *recommend_time;
// 科室id
@property (nonatomic, copy) NSString *department_id;
// 推荐标志
@property (nonatomic, copy) NSString *recommend_flag;
// 医院id
@property (nonatomic, copy) NSString *hospital_id;
// 服务
@property (nonatomic, strong) NSArray *services;
// 评分
@property (nonatomic, copy) NSString *avg_score;
// 就诊人数
@property (nonatomic, copy) NSString *visit_count;
// 评论数量
@property (nonatomic, copy) NSString *comment_count;

@end
