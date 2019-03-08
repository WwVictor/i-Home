//
//  InstantaneousPowerCell.h
//  iThing
//
//  Created by Frank on 2018/11/6.
//  Copyright © 2018 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFileHeader.h"

static NSString* kInstantaneousPowerCell = @"kInstantaneousPowerCell";
NS_ASSUME_NONNULL_BEGIN

@interface InstantaneousPowerCell : UITableViewCell
@property (strong, nonatomic) UILabel *dataLabel;
@property (strong, nonatomic) UILabel *electricityLabel;
- (void)configWithTitleName:(NSString *)titleName withDetailName:(NSString *)detailName;
@end

NS_ASSUME_NONNULL_END
