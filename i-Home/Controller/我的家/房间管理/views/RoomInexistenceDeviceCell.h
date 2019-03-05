//
//  RoomInexistenceDeviceCell.h
//  i-Home
//
//  Created by Frank on 2019/3/1.
//  Copyright © 2019 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFileHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface RoomInexistenceDeviceCell : UITableViewCell
@property (nonatomic, strong)UIButton *addButton;
@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel *deviceNameLabel;
@property (nonatomic, strong)UILabel *roomNameLabel;
@property (nonatomic, strong)void (^addDeviceBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
