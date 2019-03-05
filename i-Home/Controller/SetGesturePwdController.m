//
//  SetGesturePwdController.m
//  i-Home
//
//  Created by Divella on 2019/2/20.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import "SetGesturePwdController.h"
#import "TQGestureLockView.h"
#import "TQGestureLockPreview.h"
#import "TQGesturesPasswordManager.h"
#import "TQGestureLockHintLabel.h"
#import "TQGestureLockToast.h"
#import "CommonTools.h"
#import "CheckGesturePwdController.h"
#import "MyFileHeader.h"
@interface SetGesturePwdController ()<TQGestureLockViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;
@property (nonatomic, strong) TQGestureLockView *lockView;
@property (nonatomic, strong) TQGestureLockPreview *preview;
@property (nonatomic, strong) TQGestureLockHintLabel *hintLabel;
@property (nonatomic, strong) TQGesturesPasswordManager *passwordManager;

@end

@implementation SetGesturePwdController

- (UIBarButtonItem *)rightButtonItem
{
    if (!_rightButtonItem) {
        _rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked)];
    }
    return _rightButtonItem;
}

- (void)setNavRightButtonItem {
    if (!self.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem = self.rightButtonItem;
    }
}

- (void)rightBarItemClicked {
    _hintLabel.textColor = [UIColor grayColor];
    _hintLabel.text = @"绘制解锁图案";
    [_preview redraw];
    self.passwordManager.firstPassword = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self commonInitialization];
    
    [self subviewsInitialization];
}

- (void)commonInitialization
{
    self.passwordManager = [TQGesturesPasswordManager manager];
}

- (void)subviewsInitialization
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGFloat spacing = TQSizeFitW(40);
    CGFloat diameter = (screenSize.width - spacing * 4) / 3;
    CGFloat bottom1 = TQSizeFitH(55);
    CGFloat width1 = screenSize.width;
    CGFloat top1 = screenSize.height - width1 - bottom1;
    CGRect rect1 = CGRectMake(0, top1, width1, width1);
    
    CGFloat width2 = screenSize.width, height2 = 30;
    CGFloat top2 = top1 + spacing - height2 - 15;
    CGRect rect2 = CGRectMake(0, top2, width2, height2);
    
    CGFloat width3 = 55;
    CGFloat left3 = screenSize.width / 2 - width3 / 2;
    CGFloat top3 = top2 - width3 - 5;
    CGRect rect3 = CGRectMake(left3, top3, width3, width3);
    
    TQGestureLockDrawManager *drawManager = [TQGestureLockDrawManager defaultManager];
    drawManager.circleDiameter = diameter;
    drawManager.edgeSpacingInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    drawManager.bridgingLineWidth = 0.5;
    drawManager.hollowCircleBorderWidth = 0.5;
    
    _lockView = [[TQGestureLockView alloc] initWithFrame:rect1 drawManager:drawManager];
    _lockView.delegate = self;
    [self.view addSubview:_lockView];
    
    _hintLabel = [[TQGestureLockHintLabel alloc] initWithFrame:rect2];
    [_hintLabel setNormalText:@"绘制解锁图案"];
    [self.view addSubview:_hintLabel];
    
    _preview = [[TQGestureLockPreview alloc] initWithFrame:CGRectIntegral(rect3)];
    [self.view addSubview:_preview];
    [_preview redraw];
}

#pragma mark - TQGestureLockViewDelegate

- (void)gestureLockView:(TQGestureLockView *)gestureLockView lessErrorSecurityCodeSting:(NSString *)securityCodeSting
{
    [gestureLockView setNeedsDisplayGestureLockErrorState:YES];
    
    if (self.passwordManager.hasFirstPassword) {
        [_hintLabel setWarningText:@"与上一次绘制不一致，请重新绘制" shakeAnimated:YES];
        [self setNavRightButtonItem];
    } else {
        [_hintLabel setWarningText:@"至少连接4个点，请重新输入"
                     shakeAnimated:YES];
    }
}

- (void)gestureLockView:(TQGestureLockView *)gestureLockView finalRightSecurityCodeSting:(NSString *)securityCodeSting
{
    if (self.passwordManager.hasFirstPassword == NO) {
        
        [gestureLockView setNeedsDisplayGestureLockErrorState:NO];
        
        self.passwordManager.firstPassword = securityCodeSting;
        
        [_preview redrawWithVerifySecurityCodeString:securityCodeSting];
        
        [_hintLabel setNormalText:@"再次绘制解锁图案"];
        
    } else {
        
        if ([self.passwordManager.firstPassword isEqualToString:securityCodeSting]) {
            UserMessageModel *userModel = [[UserMessageModel alloc] init];
            userModel.userID = [[DeviceTypeManager shareManager] get8Userid];
            userModel.ltid = [LongTooth getId];
            userModel.userName = @"longtooth";
            KSaveUserMessage(userModel);
            [[DBManager shareManager] insertUserTableWithFile:userModel];
            [gestureLockView setNeedsDisplayGestureLockErrorState:NO];
            
            [_hintLabel clearText];
            
            [self.passwordManager saveEventuallyPassword:securityCodeSting];
            [[NSUserDefaults standardUserDefaults] setObject:securityCodeSting forKey:PASSWORDCODE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.view tq_showHUD:@"设置成功"];
            
            gestureLockView.userInteractionEnabled = NO;
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                
//                KSaveUserMessage(userModel);
//                CheckGesturePwdController *checkPwdVC = [[CheckGesturePwdController alloc] init];
//                 [self presentViewController:checkPwdVC animated:YES completion:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
        } else {
            [gestureLockView setNeedsDisplayGestureLockErrorState:YES];
            
            [_hintLabel setWarningText:@"与上一次绘制不一致，请重新绘制" shakeAnimated:YES];
            
            [self setNavRightButtonItem];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
