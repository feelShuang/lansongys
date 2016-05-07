//
//  ZZUITool.m
//  tableView
//
//  Created by Joe on 15/5/31.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ZZUITool.h"

@implementation ZZUITool

+ (UILabel *)labelWithframe:(CGRect)frame Text:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize superView:(UIView *)superView {
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.frame = frame;
    lbl.font = [UIFont systemFontOfSize:fontSize];
    lbl.text = text;
    lbl.textColor = textColor;
    if (superView) {
        [superView addSubview:lbl];
    }
    return lbl;
}

+ (UIButton *)buttonWithframe:(CGRect)frame title:(NSString *)title titleColor :(UIColor *)titleColor backgroundColor:(UIColor *)backColor target:(id)target action:(SEL)action superView:(UIView *)superView {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:backColor];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (superView) {
        [superView addSubview:btn];
    }
    return btn;
}

+ (UITextView *)textViewWithframe:(CGRect)frame Text:(NSString *)text backgroundColor:(UIColor *)backColor superView:(UIView *)superView {
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    textView.text = text;
    textView.backgroundColor = backColor;
    if (superView) {
        [superView addSubview:textView];
    }
    return textView;
}

+ (UITextField *)textFieldWithframe:(CGRect )frame text:(NSString *)text fontSize:(CGFloat)fontSize placeholder:(NSString *)placeholder backgroundColor:(UIColor *)backColor superView:(UIView *)superView {
    
    UITextField *txField = [[UITextField alloc] initWithFrame:frame];
    txField.placeholder = placeholder;
    txField.text = text;
    txField.font = [UIFont systemFontOfSize:fontSize];
    txField.backgroundColor = backColor;
    [superView addSubview:txField];
    return txField;
}
+ (UIImageView *)imageViewWithframe:(CGRect )frame imageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName superView:(UIView *)superView {
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.image = [UIImage imageNamed:imageName];
    imgView.highlightedImage = [UIImage imageNamed:highlightImageName];
    
    if (superView) {
        [superView addSubview:imgView];
    }
    return imgView;
}

+ (UIView *)viewWithframe:(CGRect )frame backGroundColor:(UIColor *)backColor superView:(UIView *)superView {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = backColor;
    if (superView) {
        [superView addSubview:view];
    }
    return view;
}

+ (UIView *)lineVerticalWithPosition:(CGPoint)position height:(CGFloat)height backGroundColor:(UIColor *)backColor superView:(UIView *)superView {
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){position,{1,height}}];
    view.backgroundColor = backColor;
    if (superView) {
        [superView addSubview:view];
    }
    return view;
}

+ (UIView *)linehorizontalWithPosition:(CGPoint)position width:(CGFloat)width backGroundColor:(UIColor *)backColor superView:(UIView *)superView {
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){position,{width,1}}];
    view.backgroundColor = backColor;
    if (superView) {
        [superView addSubview:view];
    }
    return view;
}

@end
