#import <Foundation/Foundation.h>

@interface Md5Coder : NSObject
/**
 *  32位小写
 */
+ (NSString *)md5:(NSString *)str;
/**
 *  32位大写
 */
+ (NSString *)md5Encode:(NSString *)str;

@end
