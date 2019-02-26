//
//  LoadingView.m
//  i-Home
//
//  Created by Divella on 2019/2/20.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import "LoadingView.h"
#import "UIColor+YTExtension.h"
#import "CommonTools.h"
#import "UIView+SDAutoLayout.h"

@interface LoadingView ()
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end


@implementation LoadingView
- (instancetype)initWithFrame:(CGRect)frame {
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self = [super initWithFrame:rect];
    
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"28a7ff"];
        
        [self placeSubviews];
        [self initstatus];
    }
    return self;
}

- (void)initstatus{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadFinished];
        
    });
}

- (void)placeSubviews{
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [self.backgroundImageView setFrame:self.bounds];
    [self addSubview:self.backgroundImageView];
    
    self.logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [self addSubview:self.logoImageView];
    
    self.logoImageView.sd_layout
    .topSpaceToView(self, 150)
    .centerXEqualToView(self)
    .widthIs(100)
    .heightIs(100);
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:self.indicatorView];
    self.indicatorView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self);
    [self.indicatorView startAnimating];
}

- (void)loadFinished {
    
    [self.indicatorView stopAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(loadCompleted)]) {
            [self.delegate loadCompleted];
        }
        
    });
}

@end
