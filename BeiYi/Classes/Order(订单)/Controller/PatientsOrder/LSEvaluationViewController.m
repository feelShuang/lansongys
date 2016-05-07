//
//  LSEvaluationViewController.m
//  BeiYi
//
//  Created by LiuShuang on 16/4/18.
//  Copyright © 2016年 LiuShuang. All rights reserved.
//

#define kMaxLength 150

#import "LSEvaluationViewController.h"
#import "LSPatientOrderDetail.h"

#import "LSImpression.h"
#import <UIImageView+WebCache.h>
#import "IMJIETagView.h"
#import "Common.h"

@interface LSEvaluationViewController ()<IMJIETagViewDelegate,UITextViewDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTopLayout;

/** 医生头像 */
@property (weak, nonatomic) IBOutlet UIImageView *doctorHeadImageView;
/** 医生姓名 */
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
/** 医生级别 */
@property (weak, nonatomic) IBOutlet UILabel *doctorLevelLabel;
/** 医生所属医院 */
@property (weak, nonatomic) IBOutlet UILabel *doctorHospitalLabel;
/** 就诊人数 */
@property (weak, nonatomic) IBOutlet UILabel *visitNumLabel;
/** 订单类型 */
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
/** 订单价格 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

/** 标签View */
@property (strong, nonatomic) IBOutlet IMJIETagView *tagView;
/** 标签背景高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeightLayout;

@property (nonatomic, strong) NSArray *impressionArr;
@property (nonatomic, strong) NSMutableArray *selectImpressionArr;

@property (weak, nonatomic) IBOutlet UIView *evaluateBgView;
@property (weak, nonatomic) IBOutlet UITextView *evaluateTextView;
@property (weak, nonatomic) IBOutlet UILabel *characterNumTipLabel;

/** 拦截touch的按钮 */
@property (nonatomic, strong) UIButton *touchView;

@end

@implementation LSEvaluationViewController

{
    NSInteger _textLength;
    NSString *_score;
    CGFloat _curTextFieldToBottom;   // 输入框当前的高度
    CGFloat _offset;     // 偏移量
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"服务评价";
    _score = @"0";
    
    self.evaluateTextView.delegate = self;
    
    // 注册通知
    [self registerNotification];
    
    // 请求医生印象数据
    [self loadDoctorImpression];
    
    // 设置评价界面数据
    [self SetEvaluationData];
    
    self.evaluateBgView.layer.cornerRadius = 8.0;
    self.evaluateBgView.layer.borderColor = ZZBorderColor.CGColor;
    self.evaluateBgView.layer.borderWidth = 1.0f;
}

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
    
    [self.evaluateTextView resignFirstResponder];
    
}

//键盘消失时
-(void)keyboardDidHidden {
    
    [self.touchView removeFromSuperview];
    
    self.contentTopLayout.constant = 0;
}

#pragma mark - 设置评价界面数据
- (void)SetEvaluationData {
    
    // 医生头像
    self.doctorHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.doctorHeadImageView.layer.cornerRadius = 22;
    self.doctorHeadImageView.layer.masksToBounds = YES;
    [self.doctorHeadImageView sd_setImageWithURL:_patientOrderDetail.doctor_avator placeholderImage:[UIImage imageNamed:@"personal_tou_xiang"]];
    // 医生姓名
    self.doctorNameLabel.text = _patientOrderDetail.doctor_name;
    // 医生级别
    self.doctorLevelLabel.text = _patientOrderDetail.doctor_level;
    // 医生所属医院
    self.doctorHospitalLabel.text = [NSString stringWithFormat:@"%@  %@",_patientOrderDetail.hospital_name,_patientOrderDetail.department_name];
    // 就诊人数
//    self.visitNumLabel.text = [NSString stringWithFormat:@"%@",_patientOrderDetail.attach.vi]
    // 订单类型
    self.orderTypeLabel.text = _patientOrderDetail.order_type_str;
    // 订单价格
    self.priceLabel.text = _patientOrderDetail.price;
}

#pragma mark - 请求医生印象数据
- (void)loadDoctorImpression {
    
    // 1. 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/comment/doctor_auto_comments",BASEURL];
    
    // 2. 准备请求体
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    
    [paras setObject:myAccount.token forKey:@"token"];

    // 3. 发送post请求
    __weak typeof(self) weakSelf = self;
    [ZZHTTPTool post:urlStr params:paras success:^(NSDictionary *responseObj) {
        ZZLog(@"--医生印象--%@",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            NSArray *impressionArr = [LSImpression mj_objectArrayWithKeyValuesArray:responseObj[@"result"]];
            NSMutableArray *temp = [NSMutableArray array];
            for (int i = 0; i < impressionArr.count; i ++) {
                LSImpression *impression = impressionArr[i];
                NSString *impressionStr = impression.value;
                [temp addObject:impressionStr];
            }
            weakSelf.impressionArr = (NSArray *)temp;
            // 设置标签
            [self setTagView];
        }
    } failure:^(NSError *error) {
        ZZLog(@"%@",error);
        
    }];
}

- (void)setTagView {
    
    IMJIETagFrame *frame = [[IMJIETagFrame alloc] init];
    frame.tagsMinPadding = 4;
    frame.tagsMargin = 10;
    frame.tagsLineSpacing = 10;
    frame.tagsArray = self.impressionArr;

    self.tagViewHeightLayout.constant = frame.tagsHeight;
    self.tagView.clickbool = YES;
    self.tagView.borderSize = 1;
    self.tagView.clickborderSize = 1;
    
    self.tagView.tagsFrame = frame;
    self.tagView.clickBackgroundColor = ZZPriseColor;
    self.tagView.clickTitleColor = ZZPriseColor;
    self.tagView.clickStart = 1;
//    self.tagView.clickString = @"华语";
    //单选
    //tagView.clickStart 为0
    //tagView.clickArray = @[@"误解向",@"我们仍未知道那天所看见的花的名字"];
    //多选 tagView.clickStart 为1
    self.tagView.delegate = self;

}

#pragma mark - 点赞按钮 监听
- (IBAction)priseBtnAction:(UIButton *)sender {
    
    [self setBtnImageWithTag:sender.tag];
    _score = [NSString stringWithFormat:@"%ld",sender.tag - 100];
}

- (void)setBtnImageWithTag:(NSInteger)tag {
    
    for (int i = 101; i <= tag; i ++) {
        UIButton *button = [self.view viewWithTag:i];
        [button setImage:[UIImage imageNamed:@"zan_xuan_zhong"] forState:UIControlStateNormal];
    }
    
    for (int i = (int)tag + 1; i <= 105; i ++) {
        UIButton *button = [self.view viewWithTag:i];
        [button setImage:[UIImage imageNamed:@"zan_mo_ren"] forState:UIControlStateNormal];
    }
}

#pragma mark - 提交按钮 监听
- (IBAction)commitBtnAction:(UIButton *)sender {
    
    if ([_score isEqualToString:@"0"]) {
        [MBProgressHUD showError:@"请给医生打分" toView:self.view];
        return;
    }
    
    // 1. 准备请求接口
    NSString *urlStr = [NSString stringWithFormat:@"%@/uc/order/to_comment",BASEURL];
    
    // 2. 准备请求体
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:myAccount.token forKey:@"token"]; // token
    [params setObject:_patientOrderDetail.order_code forKey:@"order_code"]; // 订单编号
    [params setObject:_score forKey:@"score"]; // 评分数
    if (_selectImpressionArr) {
        [params setObject:_selectImpressionArr forKey:@"auto_content"]; // 系统自定义评价
    }
    if (_evaluateTextView.text.length) {
        [params setObject:_evaluateTextView.text forKey:@"content"]; // 自定义评论
    }
    
    ZZLog(@"%@",params);
    
    // 3. 发送post请求
    __weak typeof(self) weakSelf = self;
    [ZZHTTPTool post:urlStr params:params success:^(NSDictionary *responseObj) {
        ZZLog(@"--提交评价--%@",responseObj);
        
        if ([responseObj[@"code"] isEqualToString:@"0000"]) {
            
            
            [MBProgressHUD showSuccess:@"评价成功" toView:weakSelf.view];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        ZZLog(@"%@",error);
        
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    _curTextFieldToBottom = SCREEN_HEIGHT - 64 - (self.evaluateBgView.y + 140);
    ZZLog(@"%f,%f",self.evaluateBgView.y,_curTextFieldToBottom);
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    
    NSString *textStr = textView.text;
    
    // 键盘输入模式
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    
    // 简体中文输入 包括简体拼音，简体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
        
        // 获取高亮部分
        UITextRange *selectRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectRange.start offset:0];
        
        // 没有高亮的字，则对已输入的字进行统计和限制
        if (!position) {
            if (textStr.length > kMaxLength) {
                textView.text = [textView.text substringToIndex:kMaxLength];
            }
            
            _textLength = kMaxLength - textView.text.length * 2;
            ZZLog(@"%ld,%ld",textView.text.length,_textLength);
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    } else {
        
        if (textStr.length > kMaxLength) {
            textView.text = [textStr substringToIndex:kMaxLength];
        }
        _textLength = kMaxLength-textView.text.length;
    }
    self.characterNumTipLabel.text = [NSString stringWithFormat:@"%ld/150字",textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (_textLength >= 0) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark 选中
- (void)IMJIETagView:(NSArray *)tagArray {
    
    [self.selectImpressionArr removeAllObjects];
    for (int i = 0; i < tagArray.count; i ++) {
        int index = [tagArray[i] intValue];
        [self.selectImpressionArr addObject:_impressionArr[index]];
    }
}

#pragma mark - lazy
- (NSArray *)impressionArr {
    
    if (_impressionArr == nil) {
        self.impressionArr = [NSArray array];
    }
    return _impressionArr;
}

- (NSMutableArray *)selectImpressionArr {
    
    if (_selectImpressionArr == nil) {
        self.selectImpressionArr = [NSMutableArray array];
    }
    return _selectImpressionArr;
}

@end

