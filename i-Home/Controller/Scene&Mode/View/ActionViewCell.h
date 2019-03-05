//
//  ActionViewCell.h
//  i-Home
//
//  Created by Divella on 2019/3/5.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *taskName;
@property (nonatomic,strong) UILabel *status;
@property (nonatomic,strong) UILabel *loc_Room;
@property (nonatomic,strong) UILabel *actionName;
@end
