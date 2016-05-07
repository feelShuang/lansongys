//
//  ResourcesController.m
//  BeiYi
//
//  Created by Joe on 15/4/27.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ResourcesController.h"
#import "Common.h"
#import "Hospital.h"
#import "ZZTagList.h"
#import "ZZHttpTool.h"


@interface ResourcesController ()
/** 存放 网络接收来的 医院列表 的数组 */
@property (nonatomic, strong) NSMutableArray *tags;

/** 存放选择好的标签的 NSIndexSet */
@property (nonatomic, strong) NSIndexSet *set;

@end

@implementation ResourcesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZZBackgroundColor;
    self.title = @"医院资源选择";

    // 1.设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self btnWithFrame:CGRectMake(SCREEN_WIDTH - 40 -10, 25, 50, 40)]];
    
    // 2.创建医院标签
    // 2.1判断是否缓存
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [doc stringByAppendingPathComponent:@"hospital.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:filePath];
    NSMutableArray *hosArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
    if (exist) {
        // 2.1.1 如果有缓存，判断缓存时间
        NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate];// 文件修改时间
        NSDate *now = [NSDate date];// 当前时间
        NSTimeInterval min = ([now timeIntervalSince1970] - [fileModDate timeIntervalSince1970])/60; //缓存时间（分钟）
        ZZLog(@"~~~~~~~%f",min);
        if (min < 10.0) { // 如果缓存时间不超过10分钟 则直接创建标签
            ZZLog(@"加载缓存---%f",min);
            self.tags = hosArray;
            [self getTagsWithArray:self.tags];
        }else { // 如果缓存时间超过10分钟 则重新进行网络加载
            ZZLog(@"请求网络加载---%f",min);
            [self loadHttpRequest];
        }
    }else {
         // 2.2 如果无缓存 则先进行网络加载，再创建标签
        ZZLog(@"请求网络加载---");
        [self loadHttpRequest];
    }
}

#pragma mark - 创建导航栏右侧按钮
- (UIButton *)btnWithFrame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:@"确认" forState:UIControlStateNormal];
    [button setTitleColor:ZZBaseColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

#pragma mark - 监听 导航栏右侧按钮 点击事件
- (void)confirmBtnClicked {
    // 1.将选定的标签全部取出，存放到数组中
    __block NSMutableArray *tagsArray = [NSMutableArray array]; // 用来存放选定的数组(医院列表)
    
    [_set enumerateIndexesInRange:NSMakeRange(0, _tags.count) options:NSEnumerationReverse usingBlock:^(NSUInteger idx, BOOL *stop) {
        [tagsArray addObject:[_tags objectAtIndex:idx]];
    }];
    
    // 存放选中医院的id 的数组
    NSMutableArray *hosIDs = [NSMutableArray array];
    for (Hospital *hos in tagsArray) {
        [hosIDs addObject:hos.hospital_id];
    }
    
    if (hosIDs.count == 0) {
        [MBProgressHUD showError:@"请选择"];
        
    } else {
        // 2.跳转界面返回数据
        if ([self.delegate respondsToSelector:@selector(getTagsArray:)]) {
            [self.delegate getTagsArray:hosIDs];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }

}

#pragma mark - 加载网络请求
- (void)loadHttpRequest {
    [MBProgressHUD showMessage:@"请稍后..."];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/resource/hospitals",BASEURL];
    [ZZHTTPTool get:urlStr params:nil success:^(NSDictionary *responseObj) {
        ZZLog(@"----%@",responseObj);
        
        [MBProgressHUD hideHUD];
        
        // 2.将选中的标签存放到一个数组中
        NSMutableArray *array = [NSMutableArray array]; // 存放医院名称的数组
        NSMutableArray *arrHospitals = [NSMutableArray array]; // 存放医院ID的数组

        for (NSDictionary *dict in responseObj[@"result"]) {
            Hospital *hospital = [Hospital hospitalWithDict:dict];
            [array addObject:hospital.short_name];
            [arrHospitals addObject:hospital];
        }

        self.tags = arrHospitals;
        
        // 3.创建医院标签 选择项
        [self getTagsWithArray:array];
        
        // 4.缓存
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath = [doc stringByAppendingPathComponent:@"hospital.plist"];
        [self.tags writeToFile:filePath atomically:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"发生错误，请重试"];
        ZZLog(@"----%@",error);
    }];
}

#pragma mark - 创建医院 标签
- (void)getTagsWithArray:(NSMutableArray *)array {
    ZZTagList *tagList = [[ZZTagList alloc] initWithTags:array];
    tagList.frame = CGRectMake(20, 80, SCREEN_WIDTH-40, SCREEN_HEIGHT -64);
    tagList.multiLine = YES;
    tagList.multiSelect = YES;
    tagList.allowNoSelection = YES;
    tagList.vertSpacing = 10;
    tagList.horiSpacing = 10;
    tagList.textColor = [UIColor darkGrayColor];
    tagList.tagBackgroundColor = [UIColor lightGrayColor];
    tagList.selectedTextColor = [UIColor whiteColor];
    tagList.selectedTagBackgroundColor = ZZBaseColor;
//    tagList.tagCornerRadius = 3;
    tagList.tagEdge = UIEdgeInsetsMake(8, 8, 8, 8);
    [tagList addTarget:self action:@selector(selectedTagsChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:tagList];
}

#pragma mark - 点击选中标签
- (void)selectedTagsChanged: (ZZTagList *)tagList{
    [tagList.selectedIndexSet enumerateIndexesInRange:NSMakeRange(0, self.tags.count) options:NSEnumerationReverse usingBlock:^(NSUInteger idx, BOOL *stop) {

        self.set = tagList.selectedIndexSet;
    }];
}

@end
