//
//  WKWebViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/2/26.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import "Common.h"
#import "IMYWebView.h"

@interface WKWebViewController ()

@property (nonatomic, strong) IMYWebView *wkWebView;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.wkWebView = [[IMYWebView alloc] initWithFrame:self.view.bounds];
    self.wkWebView.backgroundColor = ZZBackgroundColor;
    
    self.view = self.wkWebView;
    
    NSURL *baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        if (self.num == 2) {
            // 常见问题
            [self.wkWebView loadHTMLString:[self loadHtmlFileWithFileName:@"ask"] baseURL:baseUrl];
        }
        else {
            // 服务协议
            [self.wkWebView loadHTMLString:[self loadHtmlFileWithFileName:@"agreement"] baseURL:baseUrl];
        }
    }

    
    // 设置界面
    [self setUI];
    
    // 更改状态栏的文字颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (NSString *)loadHtmlFileWithFileName:(NSString *)fileName {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    return html;
}

- (void)setUI {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.text = _titleStr;
    titleLabel.textColor = ZZTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    // 3. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
}

- (void)navBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
