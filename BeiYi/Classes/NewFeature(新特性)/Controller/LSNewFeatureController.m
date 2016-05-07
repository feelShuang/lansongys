//
//  LSNewFeatureController.h
//  BeiYi
//
//  Created by 刘爽 on 16/3/2.
//  Copyright © 2016年 Joe. All rights reserved.
//

#define page_Num 3

#import "LSNewFeatureController.h"
#import "LSNewFeatureCell.h"
#import "Common.h"

@interface LSNewFeatureController ()

@property (nonatomic, weak) UIPageControl *control;

@end

@implementation LSNewFeatureController
static NSString *ID = @"cell";
- (instancetype)init {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // 设置cell的尺寸
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    
    // 清空行距
    layout.minimumLineSpacing = 0;
    
    // 设置滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return [super initWithCollectionViewLayout:layout];
}
// self.collectionView != self.view
// 注意： self.collectionView 是 self.view的子控件

// 使用UICollectionViewController
// 1.初始化的时候设置布局参数
// 2.必须collectionView要注册cell
// 3.自定义cell
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 注册cell,默认就会创建这个类型的cell
    [self.collectionView registerClass:[LSNewFeatureCell class] forCellWithReuseIdentifier:ID];

    // 分页
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    

    // 添加pageController
    [self setUpPageControl];
    
    // 更改状态栏的文字颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 页面将要消失的时候设置状态条文字颜色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

// 添加pageController
- (void)setUpPageControl {
    // 添加pageController,只需要设置位置，不需要管理尺寸
    UIPageControl *control = [[UIPageControl alloc] init];
    
    control.numberOfPages = page_Num;
    control.pageIndicatorTintColor = [UIColor colorWithHexString:@"#cccccc"];
    control.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#27caff"];
    
    // 设置center
    control.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT - 30);
    _control = control;
    [self.view addSubview:control];
}

#pragma mark - UIScrollView代理
// 只要一滚动就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获取当前的偏移量，计算当前第几页
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    
    // 设置页数
    _control.currentPage = page;
}
#pragma mark - UICollectionView代理和数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return page_Num;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LSNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];

    
    // 拼接图片名称 3.5 320 480
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    NSString *imageName = [NSString stringWithFormat:@"guidance_%ld",indexPath.row + 1];
    
//    if (screenH > 480) { // 5 , 6 , 6 plus
//        imageName = [NSString stringWithFormat:@"new_feature_%ld-568h",indexPath.row + 1];
//    }
    cell.image = [UIImage imageNamed:imageName];
    
    [cell setIndexPath:indexPath count:page_Num];

    
    return cell;
    
}



@end
