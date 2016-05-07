//
//  LSPullDownMenu.m
//  BeiYi
//
//  Created by LiuShuang on 16/3/23.
//  Copyright © 2016年 Joe. All rights reserved.
//
#define SEPARATELINE_COLOR [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]
#define BASE_TAG 2000

#import "LSPullDownMenu.h"

@interface LSPullDownMenu ()

// title数组
@property (nonatomic, strong) NSArray *titleArr;
// btn数组
@property (nonatomic, strong) NSMutableArray *btnArr;

@end

@implementation LSPullDownMenu

{
    NSInteger currentSelect;
    BOOL isShow;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                   TitleArray:(NSArray *)titleArray
                  selectColor:(UIColor *)selectColor
                       btnImg:(UIImage *)btnImg {
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleArr = titleArray;
        
        CGFloat btnWidth = frame.size.width / titleArray.count;
        CGFloat btnHeight = frame.size.height;

        for (int i = 0; i < titleArray.count; i ++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = BASE_TAG + i;
            btn.frame = CGRectMake(btnWidth * i, 0, btnWidth, btnHeight);
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:selectColor forState:UIControlStateSelected];
            [btn setImage:btnImg forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [self.btnArr addObject:btn];
            
            // 重写button布局
            CGSize titleLableMaxSize = CGSizeMake(CGFLOAT_MAX, 20);
            CGSize labelSize = [btn.titleLabel.text boundingRectWithSize:titleLableMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
            
            CGFloat labelWidth = labelSize.width;
            CGFloat imageWidth = btn.imageView.frame.size.width;
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + 5, 0, -labelWidth - 5);
            
            // 添加分割线
            if (i != 0 && i < titleArray.count) {
                UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(btnWidth * i, 10, 1, 20)];
                separatorLine.backgroundColor = SEPARATELINE_COLOR;
                [self addSubview:separatorLine];
                
                // 默认都选中第一行
                currentSelect = 0;
                
                
            }
        }
    }
    return self;
}

#pragma mark - 

#pragma mark - 监听按钮事件
- (void)buttonAction:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        sender.imageView.transform = CGAffineTransformRotate(sender.imageView.transform, M_PI);
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickItemAtIndex:)]) {
//        [self.delegate didClickItemAtIndex:sender.tag];
    }
}
#pragma mark - 设置title
- (void)setTitleWithTitleArr:(NSArray *)titleArr {
    
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnWidth = self.frame.size.width / titleArr.count;
    CGFloat btnHeight = self.frame.size.height;
    
    for (int i = 0; i < titleArr.count; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnWidth * i, 0, btnWidth, btnHeight);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        [self addSubview:btn];
    }
}

#pragma mark - lazy
- (NSMutableArray *)btnArr {
    
    if (_btnArr == nil) {
        self.btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

@end
