//
//  SceneCollectionCell.m
//  i-Home
//
//  Created by Divella on 2019/3/4.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import "SceneCollectionCell.h"
#import "UIView+SDAutoLayout.h"

@implementation SceneCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView{
    
    self.imageV = [[UIImageView alloc] init];
    self.imageV.backgroundColor = [UIColor redColor];
    self.imageV.layer.cornerRadius = 10;
    [self addSubview:self.imageV];
    
    self.imageV.sd_layout
    .topSpaceToView(self, 0)
    .leftSpaceToView(self, 0)
    .widthIs(80)
    .heightIs(40);
    
}


@end
