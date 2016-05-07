
//
//  OperationTableViewCell.m
//  BeiYi
//
//  Created by 刘爽 on 16/1/20.
//  Copyright © 2016年 Joe. All rights reserved.
//

#define OperationBtn1X self.frame.size.width - 150
#define OperationBtnY 10
#define OperationBtnW self.frame.size.width / 6 - 5
#define OperationBtnH 20

#import "OperationTableViewCell.h"
#import "OrderInfo.h"
#import "Common.h"

@implementation OperationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.operationBtn1 = [OperationBtn addActionBtnWithFrame:CGRectMake(OperationBtn1X, OperationBtnY, OperationBtnW, OperationBtnH) NormalImage:@"OKBtn_Clicked" SelectedImage:@"OKBtn" Title:@"本院" Target:self Action:@selector(OperationBtnAction:)];
        _operationBtn1.tag = 200;
        [self addSubview:_operationBtn1];
        
        self.operationBtn2 = [OperationBtn addActionBtnWithFrame:CGRectMake(OperationBtn1X + OperationBtnW * 2, OperationBtnY, OperationBtnW, OperationBtnH) NormalImage:@"OKBtn" SelectedImage:@"OKBtn_Clicked" Title:@"外院" Target:self Action:@selector(OperationBtnAction:)];
        _operationBtn2.tag = 201;
        [self addSubview:_operationBtn2];
    }
    return self;
    
}

// 通过tableView创建一个Cell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *AppointmentID = @"OperationCellIdentify";
    OperationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AppointmentID];
    if (cell == nil) {
        cell = [[OperationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AppointmentID];
    }
    return cell;
    
}

- (void)OperationBtnAction:(OperationBtn *)sender {
    [sender setImage:[UIImage imageNamed:@"OKBtn_Clicked"] forState:UIControlStateNormal];
    
    if (sender.tag == 200) {
        ZZLog(@"%ld",(long)sender.tag);
        [OrderInfo shareInstance].visit_type = @"2"; // 2.本院
        [self.operationBtn2 setImage:[UIImage imageNamed:@"OKBtn"] forState:UIControlStateNormal];
        
        
    }
    else {
        ZZLog(@"%ld",(long)sender.tag);
        [OrderInfo shareInstance].visit_type = @"1"; // 1.外院
        [self.operationBtn1 setImage:[UIImage imageNamed:@"OKBtn"] forState:UIControlStateNormal];
    }

    
}

- (OperationBtn *)operationBtn1 {
    
    if (_operationBtn1 == nil) {
        self.operationBtn1 = [[OperationBtn alloc] init];
    }
    return _operationBtn1;
    
}

- (OperationBtn *)operationBtn2 {
    
    if (_operationBtn2 == nil) {
        self.operationBtn2 = [[OperationBtn alloc] init];
    }
    return _operationBtn2;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.operationBtn1.frame = CGRectMake(OperationBtn1X, OperationBtnY, OperationBtnW, OperationBtnH);
    self.operationBtn2.frame = CGRectMake(OperationBtn1X + OperationBtnW, OperationBtnY, OperationBtnW, OperationBtnH);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
