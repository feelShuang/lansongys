//
//  LSCheckLoginView.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/5.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "LSCheckLoginView.h"
#import "LoginController.h"

@implementation LSCheckLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        LSCheckLoginView *checkLoginView = [[NSBundle mainBundle] loadNibNamed:@"LSCheckLoginView" owner:self options:nil][0];
        checkLoginView.frame = self.frame;
        self = checkLoginView;
    }
    return self;
}


@end
