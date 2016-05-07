//
//  LSCommitPayInfoViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/8.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSCommitPayInfoViewController.h"
#import "Common.h"

@interface LSCommitPayInfoViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

/** 支付宝账号 */
@property (weak, nonatomic) IBOutlet UITextField *zhiFuBaoTextField;

/** 密保问题 */
@property (weak, nonatomic) IBOutlet UITextField *encryptedProblemTextField;

/** 输入答案 */
@property (weak, nonatomic) IBOutlet UITextField *answerTextField;

@property (nonatomic, strong) UIView *pickerView;

@property (nonatomic, strong) UIPickerView *selectPicker;

@property (nonatomic, strong) NSArray *encrypedProblemArr;

@property (nonatomic, assign) BOOL isAppear;

@end

@implementation LSCommitPayInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 1.更改状态栏的文字颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    // 2.设置UI
    [self setUI];
}

#pragma mark - 设置导航栏右侧按钮
- (void)setUI {
    // 1.设置基本信息
    self.view .backgroundColor = ZZBackgroundColor;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    titleLabel.text = @"提交支付信息";
    titleLabel.textColor = ZZTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    // 2.设置导航栏右侧按钮
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRegister.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 50, 30);
    [btnRegister setTitle:@"完成" forState:UIControlStateNormal];
    btnRegister.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnRegister setTitleColor:[UIColor colorWithHexString:@"#0099ff"] forState:UIControlStateNormal];
    [btnRegister setTitleColor:[UIColor colorWithHexString:@"#5bbdfe"] forState:UIControlStateHighlighted];
    [btnRegister addTarget:self action:@selector(finishCommit) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRegister];
    
    // 3. 重写返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iocn_top_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navBackAction)];
}

- (void)navBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 完成提交
- (void)finishCommit {
    
}

#pragma mark - 选择密保问题 监听
- (IBAction)selectEncryptedProblem:(UIButton *)sender {
    
    [self addSelectPickerController];
}

#pragma mark - 添加选择控制器
- (void)addSelectPickerController {
    
    // 1.添加背景视图
    
    // datePicker控制器高度和Y值
    CGFloat height = 250;
    CGFloat datePickerY = SCREEN_HEIGHT - height;
    
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height)];
    pickerView.backgroundColor = [UIColor whiteColor];
    
    if (!_isAppear) { // 判断datePicker是否出现
        [self.view addSubview:pickerView];
        self.pickerView = pickerView;
        
        [UIView animateWithDuration:0.45f animations:^{
            self.pickerView.frame = CGRectMake(0, datePickerY, SCREEN_WIDTH, height);
        } completion:^(BOOL finished) {
            _isAppear = YES;
        }];
    }
    
    // 2.添加toolBar
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ZZBtnHeight)];
    bar.barTintColor = [UIColor whiteColor];
    
    // 2.1 取消按钮
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemAction   )];
    [item0 setTitleTextAttributes:@{NSForegroundColorAttributeName :
                                        ZZBaseColor} forState:UIControlStateNormal];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];// 控制距离的item
    
    // 2.2 确定按钮
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(markSureAction)];
    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName :
                                        ZZBaseColor} forState:UIControlStateNormal];
    bar.items = @[item0,item1,item2];
    [pickerView addSubview:bar];
    
    CGRect frame = CGRectMake(0, ZZBtnHeight, SCREEN_WIDTH, height - 40);
    
    // 添加选择器
    UIPickerView *selectPicker = [[UIPickerView alloc]initWithFrame:frame];
    selectPicker.backgroundColor = [UIColor whiteColor];
    // 设置pickerView的代理
    selectPicker.delegate = self;
    selectPicker.dataSource = self;
    [pickerView addSubview:selectPicker];
    self.selectPicker = selectPicker;
}

#pragma mark 点击toolBar的取消按钮
- (void)cancelItemAction {
    
    self.encryptedProblemTextField.text = @"";
    
    // 移除时间选择控制器
    [self markSureAction];
}

- (void)markSureAction {
    // 移除时间选择控制器
    [UIView animateWithDuration:0.45f animations:^{
        
        self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.pickerView.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            _isAppear = NO;
            [self.pickerView removeFromSuperview];
        }
    }];
}

#pragma mark - UIPickerViewDataSoure
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return _encrypedProblemArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return _encrypedProblemArr[row];
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.encryptedProblemTextField.text = _encrypedProblemArr[row];
}


#pragma mark - 拦截view的触摸动作
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - lazy
- (NSArray *)encrypedProblemArr {
    
    if (_encrypedProblemArr == nil) {
        self.encrypedProblemArr = @[@"你父亲的名字",@"你母亲的名字",@"你的出生地",@"你就读的小学",@"你最爱的水果"];
    }
    return _encrypedProblemArr;
}

@end
