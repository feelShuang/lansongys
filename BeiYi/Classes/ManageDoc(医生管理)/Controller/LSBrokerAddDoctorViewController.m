//
//  LSBrokerAddDoctorViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/19.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#import "LSBrokerAddDoctorViewController.h"
#import "LSBrokerDoctorDetailViewController.h"
#import "ChildDepartment.h"
#import "Hospital.h"
#import "Department.h"
#import "Common.h"

@interface LSBrokerAddDoctorViewController ()<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

/** content topLayout */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTopLayout;

/** 医生头像 */
@property (weak, nonatomic) IBOutlet UIImageView *doctorHeadImageView;
/** 医生头像字符串 */
@property (nonatomic, copy) NSString *doctorImgStr;
/** 医生姓名 */
@property (weak, nonatomic) IBOutlet UITextField *doctorNameTextField;
/** 医生职称 */
@property (weak, nonatomic) IBOutlet UILabel *doctorLevelLabel;
/** 医院名称 */
@property (weak, nonatomic) IBOutlet UILabel *hospitalNameLabel;
/** 所属科室 */
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;


/** 医生擅长背景 */
@property (weak, nonatomic) IBOutlet UIView *doctorGoodBgView;
/** 医生擅长 */
@property (weak, nonatomic) IBOutlet UITextView *doctorGoodAtTextView;


/** 医生介绍 */
@property (weak, nonatomic) IBOutlet UITextView *doctorIntroduceTextView;


/** 选择器背景 */
@property (nonatomic, strong) UIView *pickerView;
/** 选择器 */
@property (nonatomic, strong) UIPickerView *selectPicker;
/** 判断选择控制器是否出现 */
@property (nonatomic, assign) BOOL isAppear;
/** 判断选择器样式 */
@property (nonatomic, assign) NSInteger pickerType;
/** 医生职称 */
@property (nonatomic, strong) NSArray *doctorLevelsArr;
/** 存放医院名称 */
@property (nonatomic, strong) NSMutableArray *hosNameArr;
/** 存放医院ID */
@property (nonatomic, strong) NSMutableArray *hosIDArr;
/** 存放科室信息 */
@property (nonatomic, strong) NSMutableArray *departmentArr;
/** 存放所有的子科室 */
@property (nonatomic, strong) NSMutableArray *allChildDepartmentArr;
/** 存放某一大科室下边的子科室 */
@property (nonatomic, strong) NSMutableArray *childDepartmentArr;

/** 医院ID */
@property (nonatomic, copy) NSString *hospital_id;
/** 科室ID */
@property (nonatomic, copy) NSString *department_id;

/** 拦截touch的按钮 */
@property (nonatomic, strong) UIButton *touchView;

@end

@implementation LSBrokerAddDoctorViewController

{
    CGFloat _curTextFieldToBottom;   // 输入框当前的高度
    CGFloat _offset;     // 偏移量
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置标题
    self.title = @"新增医生";

    self.pickerType = 0;
    
    // 加载医院数据
    [self loadHospitalData];
    
    // 加载科室列表
    [self loadDepartmentData];
    
    // 注册通知
    [self registerNotification];
    
    self.doctorHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
}

#pragma mark - 注册键盘 弹出/隐藏 通知
- (void)registerNotification {
    
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden)
                                                 name:UIKeyboardDidHideNotification object:nil];
}

// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification {
    UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    touchBtn.frame = [UIScreen mainScreen].bounds;
    [touchBtn addTarget:self action:@selector(keyboardDisAppear) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:touchBtn];
    self.touchView = touchBtn;
    
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    _offset = _curTextFieldToBottom - keyboardHeight;
    if (_offset < 0) {
        self.contentTopLayout.constant = _offset;
    }
    
}

- (void)keyboardDisAppear {
    
    [self.view endEditing:YES];
}

//键盘消失时
-(void)keyboardDidHidden {
    [self.touchView removeFromSuperview];
    if (_offset < 0) {
        self.contentTopLayout.constant = 0;
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if (textView == _doctorGoodAtTextView) {
        _curTextFieldToBottom = SCREEN_HEIGHT - 64 - (self.doctorGoodBgView.y + self.doctorGoodBgView.height);
    } else {
        _curTextFieldToBottom = SCREEN_HEIGHT - 64 - (self.doctorGoodBgView.y + self.doctorGoodBgView.height + 10 + 155);
    }
    return YES;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    _curTextFieldToBottom = SCREEN_HEIGHT - 64 - (self.doctorNameTextField.y + 35);
}

#pragma mark - 加载医院数据
- (void)loadHospitalData {
    
    // 2.准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/resource/hospitals",BASEURL];
    
    __weak typeof(self) weakSelf = self;
    
    [ZZHTTPTool get:urlStr params:nil success:^(id responseObj) {
        ZZLog(@"---%@",responseObj);
        
        // 2.加载医院列表
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in responseObj[@"result"]) {
            Hospital *hospital = [Hospital hospitalWithDict:dict];
            [array addObject:hospital];
        }
        
        NSMutableArray *tempHos = [NSMutableArray array];// 医院名称
        for (Hospital *hos in array) {
            [tempHos addObject:hos.short_name];
        }
        // 刷新tableView
        weakSelf.hosNameArr = tempHos;
        
        NSMutableArray *tempHos_ids = [NSMutableArray array];// 医院id
        [tempHos_ids addObject:@"0"];// 全部医院
        for (Hospital *hos in array) {
            [tempHos_ids addObject:hos.hospital_id];
        }
        // 赋值
        weakSelf.hosIDArr = tempHos_ids;
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请检查您的网络" toView:weakSelf.view];
        ZZLog(@"---%@",error);
        
    }];
}

#pragma mark - 加载科室列表
- (void)loadDepartmentData {
    
    // 准备参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/resource/departments",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"0" forKey:@"hospital_id"];
    
    __weak typeof(self) weakSelf = self;
    
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"---%@",responseObj);
        
        // 1.准备数据，刷新科室列表
        NSMutableArray *arrDeptname= [NSMutableArray array]; // 存储科室名称 的数组
        NSMutableArray *arrChildList = [NSMutableArray array]; // 存储子科室模型数组 的数组
        
        for (NSDictionary *dict in responseObj[@"result"]) {
            Department *depart = [Department departWithDict:dict];
            [arrDeptname addObject:depart.dept_name];
            [arrChildList addObject:depart.childList];
        }
        weakSelf.departmentArr = arrDeptname;
        weakSelf.allChildDepartmentArr = arrChildList;
        
        ZZLog(@"---科室名称---%@",arrDeptname);
        ZZLog(@"---子科室名称---%@",arrChildList);
        ZZLog(@"---子科室名称个数---%lu",(unsigned long)arrChildList.count);
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请检查您的网络" toView:self.view];
        ZZLog(@"---%@",error);
        
    }];
}

- (IBAction)selectMemoBtnAction:(UIButton *)sender {
    
    if (sender.tag == 2000) {
        // 添加医生头像
        [self addDoctorHeaderImage];
    } else if (sender.tag == 2001) {
        
        self.pickerType = sender.tag;
        // 添加医生职称选择器
        [self addSelectPickerController];
        self.doctorLevelLabel.text = @"医师";
    } else if (sender.tag == 2002) {
        
        self.pickerType = sender.tag;
        // 添加医生所属医院选择器
        [self addSelectPickerController];
    } else {
        self.pickerType = sender.tag;
        // 添加医生科室选择器
        [self addSelectPickerController];
    }
}

#pragma mark - 添加医生头像按钮 监听
- (void)addDoctorHeaderImage {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *tickPicture = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 调用相机
        [self addOfCamera];
    }];
    
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //相册
        [self addOfLibrary];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheet addAction:tickPicture];
    [actionSheet addAction:library];
    [actionSheet addAction:cancel];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - 调用相机
- (void)addOfCamera {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - 调用相机
- (void)addOfLibrary {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerViewDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    ZZLog(@"--调用相册/机--%@",info);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 设置本地图片
    UIImage *img = info[@"UIImagePickerControllerOriginalImage"];
    self.doctorHeadImageView.image = img;
    
    // 转换成Data数据
    NSData *imgData = UIImageJPEGRepresentation(info[@"UIImagePickerControllerOriginalImage"], 0.4);
    NSString *imgStr = [imgData base64Encoding];
    self.doctorImgStr = imgStr;
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
    
    if (self.pickerType == 2001) {
        self.doctorLevelLabel.text = @"";
    } else if (self.pickerType == 2002) {
        self.hospitalNameLabel.text = @"";
    } else {
        self.departmentLabel.text = @"";
    }
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
    
    if (self.pickerType == 2001) {
        return 1;
    } else if (self.pickerType == 2002) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (self.pickerType == 2001) {
        return self.doctorLevelsArr.count;
    } else if (self.pickerType == 2002) {
        return _hosNameArr.count;
    } else {
        if (component == 0) {
            return _departmentArr.count;
        } else {
            return _childDepartmentArr.count;
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (self.pickerType == 2001) {
        return self.doctorLevelsArr[row];
    } else if (self.pickerType == 2002) {
        return _hosNameArr[row];
    } else {
        if (component == 0) {
            return _departmentArr[row];
        } else {
            ChildDepartment *childDepart = _childDepartmentArr[row];
            return childDepart.dept_name;
        }
    }
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (self.pickerType == 2001) {
        self.doctorLevelLabel.text = self.doctorLevelsArr[row];
    } else if (self.pickerType == 2002) {
        self.hospitalNameLabel.text = self.hosNameArr[row];
        self.hospital_id = self.hosIDArr[row];
    } else {
        if (component == 0) {
            self.childDepartmentArr = self.allChildDepartmentArr[row];
            [self.selectPicker reloadAllComponents];
        } else {
            ChildDepartment *childDepart = _childDepartmentArr[row];
            self.departmentLabel.text = childDepart.dept_name;
            self.department_id = [NSString stringWithFormat:@"%d",childDepart.childList_id];
        }
    }
}

#pragma mark - 提交按钮 监听
- (IBAction)commitDoctorInfoBtnAction:(UIButton *)sender {
    
    if (!self.doctorImgStr.length) {
        [MBProgressHUD showError:@"请上传医生头像" toView:self.view];
        return;
    }
    if (!self.doctorNameTextField.text.length) {
        [MBProgressHUD showError:@"请填写医生姓名" toView:self.view];
        return;
    }
    if (!self.doctorLevelLabel.text.length) {
        [MBProgressHUD showError:@"请选择医生职称" toView:self.view];
        return;
    }
    if (!self.hospitalNameLabel.text.length) {
        [MBProgressHUD showError:@"请选择医生所属医院" toView:self.view];
        return;
    }
    if (!self.departmentLabel.text.length) {
        [MBProgressHUD showError:@"请选择医生所属科室" toView:self.view];
        return;
    }
    if (!self.doctorGoodAtTextView.text.length) {
        [MBProgressHUD showError:@"请填写医生擅长" toView:self.view];
        return;
    }
    if (!self.doctorIntroduceTextView.text.length) {
        [MBProgressHUD showError:@"请填写医生介绍" toView:self.view];
        return;
    }
    
    // 1. 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/offer/add_doctor",BASEURL];
    
    // 2. 准备请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:myAccount.token forKey:@"token"];
    [params setObject:_doctorNameTextField.text forKey:@"name"];
    [params setObject:_hospital_id forKey:@"hospital_id"];
    [params setObject:_department_id forKey:@"department_id"];
    [params setObject:self.doctorGoodAtTextView.text forKey:@"good_at"];
    [params setObject:self.doctorIntroduceTextView.text forKey:@"memo"];
    NSString *level = @"";
    if ([self.doctorLevelLabel.text isEqualToString:@"主任医师"]) {
        level = @"4";
    } else if ([self.doctorLevelLabel.text isEqualToString:@"副主任医师"]) {
        level = @"3";
    } else if ([self.doctorLevelLabel.text isEqualToString:@"主治医师"]) {
        level = @"2";
    } else {
        level = @"1";
    }
    [params setObject:level forKey:@"level"];
    [params setObject:self.doctorImgStr forKey:@"avator"];
    ZZLog(@"--params = %@",params);
    
    // 3. 发送post请求
    __weak typeof(self) weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"--医生印象--%@",responseObj);
#warning want go to Doctor Detail
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        ZZLog(@"%@",error);
        
    }];
}

- (IBAction)textFieldReturnEditing:(UITextField *)sender {
    
    [sender endEditing:YES];
}

#pragma mark - lazy
- (NSArray *)doctorLevelsArr {
    
    if (_doctorLevelsArr == nil) {
        self.doctorLevelsArr = @[@"医师",@"主治医师",@"副主任医师",@"主任医师"];
    }
    return _doctorLevelsArr;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
