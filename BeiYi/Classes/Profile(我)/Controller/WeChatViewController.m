//
//  WeChatViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/3/15.
//  Copyright © 2016年 Joe. All rights reserved.
//

#define kMaxLength 300

#import "WeChatViewController.h"
#import "Common.h"

@interface WeChatViewController ()<UITextViewDelegate>

/** 反馈的意见textView */
@property (weak, nonatomic) IBOutlet UITextView *suggestionTextVeiw;
/** 字符个数提示 */
@property (weak, nonatomic) IBOutlet UILabel *characterNumTipLabel;

@end

@implementation WeChatViewController

{
    NSInteger _textLength;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置UI
    [self setUI];
}

- (void)setUI {
    
    // 1. setTitle
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.text = @"意见反馈";
    titleLabel.textColor = ZZTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    // 2. 设置代理
    self.suggestionTextVeiw.delegate = self;
    
    // 3. 更改状态栏的文字颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    // 4. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
    
    // 5. 提交按钮
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 40, 30);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [commitBtn setTitleColor:[UIColor colorWithHexString:@"#0099ff"] forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor colorWithHexString:@"#5bbdfe"] forState:UIControlStateHighlighted];
    [commitBtn addTarget:self action:@selector(commitSuggesstion) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:commitBtn];
}

- (void)navBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#warning suggesstion没有实现
#pragma mark - 提交意见
- (void)commitSuggesstion {
    
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    NSString *textStr = textView.text;
    
    // 键盘输入模式
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    
    // 简体中文输入 包括简体拼音，简体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
        
        // 获取高亮部分
        UITextRange *selectRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectRange.start offset:0];
        
        // 没有高亮的字，则对已输入的字进行统计和限制
        if (!position) {
            if (textStr.length > kMaxLength) {
                textView.text = [textView.text substringToIndex:kMaxLength];
            }
            
            _textLength = kMaxLength - textView.text.length * 2;
            ZZLog(@"%ld,%ld",textView.text.length,_textLength);
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    } else {
        
        if (textStr.length > kMaxLength) {
            textView.text = [textStr substringToIndex:kMaxLength];
        }
        _textLength = kMaxLength-textView.text.length;
    }
    self.characterNumTipLabel.text = [NSString stringWithFormat:@"%ld/300字",textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (_textLength >= 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
