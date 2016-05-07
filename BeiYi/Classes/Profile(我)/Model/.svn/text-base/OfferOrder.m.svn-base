//
//  OfferOrder.m
//  BeiYi
//
//  Created by Joe on 15/5/27.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "OfferOrder.h"

@implementation OfferOrder

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.offer_id = dict[@"id"];
        self.order_type = dict[@"order_type"];
        self.hospital_name = dict[@"hospital_name"];
        self.memo = dict[@"memo"];
        self.created_at = dict[@"created_at"];
        self.start_time = dict[@"start_time"];
        self.order_status_str = dict[@"order_status_str"];
        self.price = dict[@"price"];
        self.end_time = dict[@"end_time"];
        self.order_code = dict[@"order_code"];
        self.order_status = dict[@"order_status"];
        self.doctor_name = dict[@"doctor_name"];
        self.department_name = dict[@"department_name"];
    }
    return self;
}

+ (instancetype)offerOrderWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
