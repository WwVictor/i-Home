//
//  YearElectricityCell.m
//  iThing
//
//  Created by Frank on 2018/11/6.
//  Copyright © 2018 Frank. All rights reserved.
//

#import "YearElectricityCell.h"
#import "XJYChart.h"
#import "Masonry.h"
@interface YearElectricityCell ()<XJYChartDelegate>

@end
@implementation YearElectricityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString*)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 28)];
//        titleLabel.text = @"功率";
//        titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:21];
//        titleLabel.textColor = [UIColor colorWithHexString:@"43A3FF" alpha:1.0];
//        [self.contentView addSubview:titleLabel];
//
//
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 58, 60, 12)];
//        label.text = @"(W.h)";
//        label.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:12];
//        label.textColor = [UIColor black50PercentColor];
//        [self.contentView addSubview:label];
//
//
//        NSMutableArray* itemArray = [[NSMutableArray alloc] init];
//
//        UIColor* waveColor = [UIColor colorWithHexString:@"43A3FF" alpha:1.0];
//
//        XBarItem* item1 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                         color:[UIColor whiteColor]
//                                                  dataDescribe:@"Jan"];
//        [itemArray addObject:item1];
//        XBarItem* item2 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                         color:[UIColor whiteColor]
//                                                  dataDescribe:@"Feb"];
//        [itemArray addObject:item2];
//        XBarItem* item3 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                         color:[UIColor whiteColor]
//                                                  dataDescribe:@"Mar"];
//        [itemArray addObject:item3];
//        XBarItem* item4 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                         color:[UIColor whiteColor]
//                                                  dataDescribe:@"Apr"];
//        [itemArray addObject:item4];
//        XBarItem* item5 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                         color:[UIColor whiteColor]
//                                                  dataDescribe:@"May"];
//        [itemArray addObject:item5];
//
//        XBarItem* item6 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                         color:[UIColor whiteColor]
//                                                  dataDescribe:@"Jun"];
//        [itemArray addObject:item6];
//        XBarItem* item7 = [[XBarItem alloc] initWithDataNumber:@(400.04)
//                                                         color:waveColor
//                                                  dataDescribe:@"Jul"];
//        [itemArray addObject:item7];
//        XBarItem* item8 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                         color:[UIColor whiteColor]
//                                                  dataDescribe:@"Aug"];
//        [itemArray addObject:item8];
//        XBarItem* item9 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                         color:[UIColor whiteColor]
//                                                  dataDescribe:@"Sep"];
//        [itemArray addObject:item9];
//        XBarItem* item10 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                          color:[UIColor whiteColor]
//                                                   dataDescribe:@"Oct"];
//        [itemArray addObject:item10];
//        //
//        XBarItem* item11 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                          color:[UIColor whiteColor]
//                                                   dataDescribe:@"Nov"];
//        [itemArray addObject:item11];
//        XBarItem* item12 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                          color:[UIColor whiteColor]
//                                                   dataDescribe:@"Dec"];
//
//        [itemArray addObject:item12];
        
//        XBarChartConfiguration *configuration = [XBarChartConfiguration new];
//        configuration.isScrollable = NO;
//        configuration.x_width = 40;
//        XBarChart* barChart =
//        [[XBarChart alloc] initWithFrame:CGRectMake(15, 70, KScreenWidth-15, 230)
//                           dataItemArray:itemArray
//                               topNumber:@(427)
//                            bottomNumber:@(0)
//                      chartConfiguration:configuration];
//        barChart.barChartDelegate = self;
//        [self.contentView addSubview:barChart];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        UILabel* dataLabel = [[UILabel alloc] init];
//        dataLabel.text = @"注: 你可以查看过去2个月的日用电量";
//        dataLabel.textAlignment = NSTextAlignmentCenter;
//        dataLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:15];
//        dataLabel.textColor = [UIColor colorFromHexString:@"666666"];
//        [self.contentView addSubview:dataLabel];
//        [dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self.contentView).offset(-10);
//            make.centerX.mas_equalTo(self.contentView);
//            make.height.mas_equalTo(20);
//        }];
    }
    return self;
}
-(void)configWithData:(NSMutableArray *)dataArray andWithTime:(NSMutableArray *)timeArray
{
    if (dataArray.count != 0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 28)];
        titleLabel.text = Localized(@"tx_electricity_power");
        titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:21];
        titleLabel.textColor = [UIColor colorWithHexString:@"43A3FF" alpha:1.0];
        [self.contentView addSubview:titleLabel];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 58, 60, 12)];
        label.text = @"(W.h)";
        label.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:12];
        label.textColor = [UIColor black50PercentColor];
        [self.contentView addSubview:label];
//        NSArray *mouthArr = @[@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec"];
        
        NSNumber *topNum = [NSNumber numberWithInt:0];
        NSMutableArray* itemArray = [[NSMutableArray alloc] init];
        UIColor* waveColor = [UIColor colorWithHexString:@"43A3FF" alpha:1.0];
        for (int i = 0; i < dataArray.count; i++) {
            
            int oldNum = [dataArray[i] intValue];
            NSNumber *dataNum = [NSNumber numberWithDouble:oldNum/3600.0];
            
            if ([dataNum doubleValue] > [topNum doubleValue]) {
                topNum = dataNum;
            }
            
            XBarItem* item1 = [[XBarItem alloc] initWithDataNumber:dataNum
                                                             color:waveColor
                                                      dataDescribe:timeArray[i]];
            [itemArray addObject:item1];
        }
        self.configuration = [XBarChartConfiguration new];
        self.configuration.isScrollable = NO;
        self.configuration.x_width = 40;
        self.barChart =
        [[XBarChart alloc] initWithFrame:CGRectMake(15, 70, KScreenWidth-15, 230)
                           dataItemArray:itemArray
                               topNumber:topNum
                            bottomNumber:@(0)
                      chartConfiguration:self.configuration];
        self.barChart.barChartDelegate = self;
        [self.contentView addSubview:self.barChart];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        UILabel* dataLabel = [[UILabel alloc] init];
//        dataLabel.text = @"(M)";
//        dataLabel.backgroundColor = [UIColor whiteColor];
//        dataLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:12];
//        dataLabel.textColor = [UIColor black50PercentColor];
//        [self.contentView addSubview:dataLabel];
//        [dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self.barChart).offset(-15);
//            make.right.mas_equalTo(self.contentView).offset(0);
//            make.width.mas_equalTo(20);
//            make.height.mas_equalTo(10);
//        }];
    }
    
   
}
#pragma mark XBarChartDelegate

- (void)userClickedOnBarAtIndex:(NSInteger)idx {
    NSLog(@"XBarChartDelegate touch Bat At idx %lu", idx);
}
@end
