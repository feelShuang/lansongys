//
//  ZZTextView.m
//  BeiYi
//
//  Created by Joe on 15/6/28.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ZZTextView.h"

@interface ZZTextView ()
/**
 *  UILabel 提醒文字
 */
@property (nonatomic, strong) UILabel *lblPlaceholder;

@end

@implementation ZZTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 1.添加提示文字
        self.lblPlaceholder = [[UILabel alloc] init];
        self.lblPlaceholder.text = self.placeholder;
        self.lblPlaceholder.hidden = YES;
        self.lblPlaceholder.numberOfLines = 0;
        self.lblPlaceholder.font = self.font;
//        self.lblPlaceholder.backgroundColor = [UIColor yellowColor];
        self.lblPlaceholder.textColor = [UIColor lightGrayColor];
        [self insertSubview:self.lblPlaceholder atIndex:0];
        
        // 2.监听textView文字改变的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    
    self.lblPlaceholder.text = self.placeholder;
    
    if (self.placeholder.length) {// 需要显示
        self.lblPlaceholder.hidden = NO;
        
        // 计算frame
        CGFloat placeholderX = 5;
        CGFloat placeholderY = 7;
        CGFloat maxW = self.frame.size.width - 2 * placeholderX;
        CGFloat maxH = self.frame.size.height - 2 * placeholderY;
        CGSize placeholderSize = [placeholder boundingRectWithSize:CGSizeMake(maxW, maxH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.lblPlaceholder.font} context:nil].size;
        self.lblPlaceholder.frame = CGRectMake(placeholderX, placeholderY, placeholderSize.width, placeholderSize.height);
        
    }else {
        self.lblPlaceholder.hidden = YES;
    }
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    self.lblPlaceholder.font = font;
    self.placeholder = self.placeholder;
}
- (void)textChange {
    self.lblPlaceholder.hidden = self.text.length;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
