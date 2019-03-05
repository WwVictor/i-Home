//
//  HomeRoomListCell.h
//  i-Home
//
//  Created by Frank on 2019/3/4.
//  Copyright © 2019 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFileHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeRoomListCell : UITableViewCell
@property (nonatomic, strong)UIButton *selectButton;
@property (nonatomic, strong)UILabel *roomNameLabel;
@property (nonatomic, strong)void (^selectBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
