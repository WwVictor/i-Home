//
//  AddRoomViewController.m
//  i-Home
//
//  Created by Frank on 2019/3/1.
//  Copyright © 2019 Victor. All rights reserved.
//

#import "AddRoomViewController.h"
#import "MyFileHeader.h"
@interface AddRoomViewController ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *roomTitle;
@property (nonatomic, strong) UILabel *recommendLabel;
@property (nonatomic, strong) UITextField *roomNameTextField;
@end

@implementation AddRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"添加房间";
    [self setUI];
}
-(void)setUI
{
    [self creatNav];
    [self createContentView];
}
- (void)creatNav
{
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UIButton *finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
}

- (void)cancelBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)finishBtnClick
{
    
}
- (void)createContentView
{
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    self.bgView = [[UIView alloc] init];
    [self.view addSubview:self.bgView];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.sd_layout
    .topSpaceToView(self.view, 20)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(70);
    
    self.roomTitle = [UILabel new];
    self.roomTitle.textColor = [UIColor colorWithHexString:@"333333"];
    CGFloat title_width = 0;
    if (@available(iOS 8.2, *)) {
        [self.roomTitle setFont:[UIFont systemFontOfSize:21.0 weight:UIFontWeightMedium]];
        title_width = [self widthLabelWithModel:@"房间名称" font:[UIFont systemFontOfSize:21.0 weight:UIFontWeightMedium] view:self.bgView];
    } else {
        [self.roomTitle setFont:[UIFont systemFontOfSize:21.0]];
        title_width = [self widthLabelWithModel:@"房间名称" font:[UIFont systemFontOfSize:21.0] view:self.bgView];
    }
    self.roomTitle.text = @"房间名称";
    [self.bgView addSubview:self.roomTitle];
    self.roomTitle.sd_layout
    .centerYEqualToView(self.bgView)
    .leftSpaceToView(self.bgView, 15)
    .widthIs(title_width)
    .heightIs(50);
    // 房间名称输入框
    self.roomNameTextField = [[UITextField alloc] init];
    [self.roomNameTextField becomeFirstResponder];
    self.roomNameTextField.font = [UIFont systemFontOfSize:18];
    self.roomNameTextField.borderStyle = UITextBorderStyleNone;
    [self.bgView addSubview:self.roomNameTextField];
    self.roomNameTextField.sd_layout
    .centerYEqualToView(self.bgView)
    .leftSpaceToView(self.roomTitle, 30)
    .rightSpaceToView(self.bgView, 15)
    .heightIs(50);
    //推荐
    self.recommendLabel = [UILabel new];
    self.recommendLabel.textColor = [UIColor colorWithHexString:@"333333"];
    if (@available(iOS 8.2, *)) {
        [self.recommendLabel setFont:[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium]];
    } else {
        [self.recommendLabel setFont:[UIFont systemFontOfSize:18.0]];
    }
    self.recommendLabel.text = @"推荐";
    [self.view addSubview:self.recommendLabel];
    self.recommendLabel.sd_layout
    .topSpaceToView(self.bgView, 20)
    .leftSpaceToView(self.view, 15)
    .widthIs(120)
    .heightIs(20);
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"客厅",@"主卧",@"次卧",@"餐厅",@"厨房",@"书房",@"玄关",@"阳台",@"儿童房",@"衣帽间", nil];
//    CGFloat btn_width = (KScreenWidth-15-15*3-15*4)/4;
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15+([self getSizeWithText:arr[i]]+15)*(i%4), 150+(30+15)*(i/4), [self getSizeWithText:arr[i]], 30)];
        [self.view addSubview:btn];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.tag = 20190301+i;
        [btn addTarget:self action:@selector(roomListAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
    }
}
- (void)roomListAction:(UIButton *)btn
{
    self.roomNameTextField.text = btn.titleLabel.text;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark-字体宽度自适应
- (CGFloat)widthLabelWithModel:(NSString *)titleString font:(UIFont *)font view:(UIView *)myView
{
    CGSize size = CGSizeMake(myView.bounds.size.width, MAXFLOAT);
    CGRect rect = [titleString boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
    return rect.size.width;
}
-(CGFloat)getSizeWithText:(NSString*)text
{
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) options: NSStringDrawingUsesLineFragmentOrigin   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:style} context:nil].size;
    return size.width+40;
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
