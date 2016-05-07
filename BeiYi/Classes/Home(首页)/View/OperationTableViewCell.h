//
//  OperationTableViewCell.h
//  BeiYi
//
//  Created by 刘爽 on 16/1/20.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OperationBtn.h"

@interface OperationTableViewCell : UITableViewCell

@property (nonatomic, strong) OperationBtn *operationBtn1;
@property (nonatomic, strong) OperationBtn *operationBtn2;


// 通过tableView创建一个Cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
