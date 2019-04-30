//
//  DeclareAbnormalAlertView.m
//  iDeliver
//
//  Created by 蔡强 on 2017/4/3.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

//========== 申报异常弹窗 ==========//

#import "DeclareAbnormalAlertView.h"

#import "UIView+frameAdjust.h"
#import "MyFileHeader.h"
@interface DeclareAbnormalAlertView ()<UITextViewDelegate>

/** 弹窗主内容view */
@property (nonatomic,strong) UIView   *contentView;
/** 弹窗标题 */
@property (nonatomic,copy)   NSString *imageIcon;
/** 弹窗message */
@property (nonatomic,copy)   NSString *deviceName;
/** message label */
@property (nonatomic,strong) UILabel  *messageLabel;

@end

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation DeclareAbnormalAlertView{
    UILabel *label;
}

#pragma mark - 构造方法
/**
 申报异常弹窗的构造方法
 
 @param imageIcon 弹窗标题
 @param deviceName 弹窗message
 @param delegate 确定代理方
 @param buttonTitle 左边按钮的title
 @return 一个申报异常的弹窗
 */
- (instancetype)initWithImageIcon:(NSString *)imageIcon deviceName:(NSString *)deviceName delegate:(id)delegate buttonTitle:(NSString *)buttonTitle{
    if (self = [super init]) {
        self.imageIcon = imageIcon;
        self.deviceName = deviceName;
        self.delegate = delegate;
        self.buttonTitle = buttonTitle;
        // 接收键盘显示隐藏的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        // UI搭建
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI搭建
/** UI搭建 */
- (void)setUpUI{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    }];
        //------- 弹窗主内容 -------//
        self.contentView = [[UIView alloc]init];
        self.contentView.frame = CGRectMake(40, (SCREEN_HEIGHT - 215) / 2, (SCREEN_WIDTH - 80), 215);
        self.contentView.center = self.center;
        [self addSubview:self.contentView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 6;
        
        // 标题
        UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.contentView.width-60)/2.0, 20, 60, 60)];
        [self.contentView addSubview:iconImageView];
        iconImageView.image = [UIImage imageNamed:self.imageIcon];
    
        
        // 填写异常情况描述的textView
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(22, iconImageView.maxY + 30, self.contentView.width - 44, 43)];
        [self.contentView addSubview:self.textView];
    self.textView.layer.cornerRadius = 5;
        self.textView.layer.borderWidth = 1.0;
        self.textView.layer.borderColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    if (@available(iOS 8.2, *)) {
        self.textView.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    } else {
        // Fallback on earlier versions
        self.textView.font = [UIFont systemFontOfSize:18];
    }
        [self.textView becomeFirstResponder];
        self.textView.delegate = self;
         self.textView.text = self.deviceName;
        // textView里面的占位label
        self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 7.5, self.textView.frame.size.width - 8, 21.5)];
//        self.messageLabel.text = self.deviceName;
        self.messageLabel.numberOfLines = 0;
        if (@available(iOS 8.2, *)) {
            self.messageLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        } else {
            // Fallback on earlier versions
            self.messageLabel.font = [UIFont systemFontOfSize:18];
        }
        self.messageLabel.textColor = [UIColor colorWithHexString:@"484848"];
        [self.messageLabel sizeToFit];
        [self.textView addSubview:self.messageLabel];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.textView.maxY + 20, self.contentView.width, 1)];
        topView.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
        [self.contentView addSubview:topView];
        
        // 取消按钮
        UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(0, topView.maxY, self.contentView.width, self.contentView.height-topView.maxY)];
        [self.contentView addSubview:nextButton];
        [nextButton setTitle:self.buttonTitle forState:UIControlStateNormal];
        [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (@available(iOS 8.2, *)) {
        nextButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    } else {
        // Fallback on earlier versions
        nextButton.titleLabel.font = [UIFont systemFontOfSize:18];
    }
        nextButton.layer.cornerRadius = 6;
        [nextButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 弹出此弹窗
/** 弹出此弹窗 */
- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
}

#pragma mark - 移除此弹窗
/** 移除此弹窗 */
- (void)dismiss{
    [self removeFromSuperview];
}

#pragma mark - 申报异常按钮点击
/** 申报异常按钮点击 */
- (void)abnormalButtonClicked{
    if ([self.delegate respondsToSelector:@selector(declareAbnormalAlertView:clickedButtonAtIndex:)]) {
        [self.delegate declareAbnormalAlertView:self clickedButtonAtIndex:AlertButtonRight];
    }
    [self dismiss];
}

#pragma mark - 取消按钮点击
/** 取消按钮点击 */
- (void)cancelButtonClicked{
    if ([self.delegate respondsToSelector:@selector(declareAbnormalAlertView:clickedButtonAtIndex:)]) {
        [self.delegate declareAbnormalAlertView:self clickedButtonAtIndex:AlertButtonLeft];
    }
    [self dismiss];
}

#pragma mark - UITextView代理方法
- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.messageLabel.hidden = NO;
    }else{
        self.messageLabel.hidden = YES;
    }
}

/**
 *  键盘将要显示
 *
 *  @param notification 通知
 */
-(void)keyboardWillShow:(NSNotification *)notification
{
    // 获取到了键盘frame
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = frame.size.height;
    
    self.contentView.maxY = SCREEN_HEIGHT - keyboardHeight - 10;
}
/**
 *  键盘将要隐藏
 *
 *  @param notification 通知
 */
-(void)keyboardWillHidden:(NSNotification *)notification
{
    // 弹窗回到屏幕正中
    self.contentView.centerY = SCREEN_HEIGHT / 2;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
}

@end
