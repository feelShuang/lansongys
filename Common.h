
//
//  Common.h
//  BeiYi
//
//  Created by Joe on 15/4/16.
//  Copyright (c) 2015年 Joe. All rights reserved.
//
#import "MBProgressHUD+MJ.h"
#import "ZZAccount.h"
#import "ZZAccountTool.h"
#import "ZZHTTPTool.h"
#import "ZZUITool.h"
#import "LSLocalFile.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import <AFNetworking.h>
#import "UIView+frame.h"
#import "UIColor+Hex.h"




//#define BASEURL @"http://192.168.1.107:8080/medical_interf"
#define BASEURL @"http://www.lansongys.com/medical_interf_v3"


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

/** 判断是否登陆 [ZZAccountTool account] */
#define myAccount [ZZAccountTool account].session

/** 支付宝相关信息 */

// 商户PID
#define AlipayPartner @""
// 商户收款账号
#define AlipaySeller @""
// 商户私钥
#define AlipayRSA_PrivateKey @""
// 商户公钥
#define AlipayRSA_Public @""
/** 极光推送 */
#define JPushAppkey @"53f6689261b94333775fe561"
#define JPushTag @"push_service_hospital_"
/** 控件间距 */
#define ZZMarins ([UIScreen mainScreen].bounds.size.width/20)

#define ZZBtnHeight 44
/** 基准色 */
#define ZZBaseColor ROLESTYLE?ZZColor(255, 138, 0, 1):ZZColor(39, 202, 255, 1)

/** 背景色 */
#define ZZBackgroundColor ZZColor(240, 242, 245, 1)

/** 标题颜色 #333333 */
#define ZZTitleColor ZZColor(51, 51, 51, 1)

/** 描述文字颜色 #999999 */
#define ZZDetailStrColor ZZColor(153, 153, 153, 1)

/** 赞 颜色 */
#define ZZPriseColor ZZColor(255, 138, 0, 1)

/** 边框颜色 */
#define ZZBorderColor ZZColor(204, 204, 204, 1)

/** 选中的字体颜色 */
#define ZZButtonTintColor ROLESTYLE?ZZColor(255, 138, 0, 1):ZZColor(39, 202, 255, 1)

/** 分割线 */
#define ZZSeparateLineColor ZZColor(230, 230, 230, 1)

/** 按钮颜色 */
#define ZZButtonColor ZZColor(0, 153, 255, 1)

/** 按钮点击时的颜色 */
#define ZZButtonClickedColor ZZColor(246, 81, 39, 1)

/** 自定义RGB颜色 */
#define ZZColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/1.0]

/** 随机颜色 */
#define ZZRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

/** 自定义Log */
#ifdef DEBUG
#define ZZLog(...) NSLog(__VA_ARGS__)
#else
#define ZZLog(...)
#endif

// apple store更新地址
#define APP_URL @"http://itunes.apple.com/lookup?id=1099066780"

/** 占位图片 */
#define DEFAULT_LOADING_IMAGE [UIImage imageNamed:@"default_loading_image.png"]

#define ROLESTYLE [[NSUserDefaults standardUserDefaults] boolForKey:@"RoleStyle"]

// 时间选取器
#define OneDay 24*60




