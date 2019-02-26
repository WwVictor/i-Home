//
//  LoadingView.h
//  i-Home
//
//  Created by Divella on 2019/2/20.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoadingViewDelegate <NSObject>
- (void)loadCompleted;
@end

@interface LoadingView : UIView
@property (nonatomic, weak) id <LoadingViewDelegate> delegate;
@end
