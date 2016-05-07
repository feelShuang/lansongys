//
//  ZZAccount.m
//  BeiYi
//
//  Created by Joe on 15/5/20.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ZZAccount.h"
#import "Common.h"

@implementation Session

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.realName = [aDecoder decodeObjectForKey:@"realName"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.realName forKey:@"realName"];
}

@end


@implementation Notice

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}

/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        
        self.publish_order_read_count = [aDecoder decodeObjectForKey:@"publish_order_read_count"];
        self.offer_order_read_count = [aDecoder decodeObjectForKey:@"offer_order_read_count"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.publish_order_read_count forKey:@"publish_order_read_count"];
    [aCoder encodeObject:self.offer_order_read_count forKey:@"offer_order_read_count"];
}

@end


@implementation ZZAccount

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {

        self.session = [aDecoder decodeObjectForKey:@"session"];
        self.notice_tag = [aDecoder decodeObjectForKey:@"notice_tag"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.session forKey:@"session"];
    [aCoder encodeObject:self.notice_tag forKey:@"notice_tag"];
}

@end
