//
//  DeclareAbnormalAlertView.h
//  iDeliver
//
//  Created by 蔡强 on 2017/4/3.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

//========== 申报异常弹窗 ==========//

#import <UIKit/UIKit.h>

/**
 弹窗上的按钮

 - AlertButtonLeft: 左边的按钮
 - AlertButtonRight: 右边的按钮
 */
typedef NS_ENUM(NSUInteger, AbnormalButton) {
    AlertButtonLeft = 0,
    AlertButtonRight
};


#pragma mark - 协议

@class DeclareAbnormalAlertView;

@protocol DeclareAbnormalAlertViewDelegate <NSObject>

- (void)declareAbnormalAlertView:(DeclareAbnormalAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

#pragma mark - interface

/** 申报异常弹窗 */
@interface DeclareAbnormalAlertView : UIView

/** 这个弹窗对应的orderID */
@property (nonatomic,copy) NSString *orderID;
/** 用户填写异常情况的textView */
@property (nonatomic,strong) UITextView *textView;
/** 按钮title */
@property (nonatomic,copy)   NSString *buttonTitle;

@property (nonatomic,weak) id<DeclareAbnormalAlertViewDelegate> delegate;
/**
 申报异常弹窗的构造方法

 @param imageIcon 弹窗标题
 @param deviceName 弹窗message
 @param delegate 确定代理方
 @param buttonTitle 左边按钮的title
 @return 一个申报异常的弹窗
 */
- (instancetype)initWithImageIcon:(NSString *)imageIcon deviceName:(NSString *)deviceName delegate:(id)delegate buttonTitle:(NSString *)buttonTitle;
/** show出这个弹窗 */
- (void)show;

@end
