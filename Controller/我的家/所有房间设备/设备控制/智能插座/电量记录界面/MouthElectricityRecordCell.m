//
//  MouthElectricityRecordCell.m
//  iThing
//
//  Created by Frank on 2018/11/6.
//  Copyright © 2018 Frank. All rights reserved.
//

#import "MouthElectricityRecordCell.h"
#import "XJYChart.h"
#import "Masonry.h"
@interface MouthElectricityRecordCell ()<XJYChartDelegate>

@end

@implementation MouthElectricityRecordCell

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
//                                                  dataDescribe:@"2011"];
//        [itemArray addObject:item1];
//        XBarItem* item2 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                         color:[UIColor whiteColor]
//                                                  dataDescribe:@"2012"];
//        [itemArray addObject:item2];
//        XBarItem* item3 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                         color:[UIColor whiteColor]
//                                                  dataDescribe:@"2013"];
//        [itemArray addObject:item3];
//        XBarItem* item4 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                         color:[UIColor whiteColor]
//                                                  dataDescribe:@"2014"];
//        [itemArray addObject:item4];
//        XBarItem* item5 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                         color:[UIColor whiteColor]
//                                                  dataDescribe:@"2015"];
//        [itemArray addObject:item5];
//
//        XBarItem* item6 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                         color:[UIColor whiteColor]
//                                                  dataDescribe:@"2017"];
//        [itemArray addObject:item6];
//        XBarItem* item7 = [[XBarItem alloc] initWithDataNumber:@(375)
//                                                         color:waveColor
//                                                  dataDescribe:@"2018"];
//        [itemArray addObject:item7];
//        XBarItem* item8 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                         color:[UIColor whiteColor]
//                                                  dataDescribe:@"2019"];
//        [itemArray addObject:item8];
//        XBarItem* item9 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                         color:[UIColor whiteColor]
//                                                  dataDescribe:@"2020"];
//        [itemArray addObject:item9];
//        XBarItem* item10 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                          color:[UIColor whiteColor]
//                                                   dataDescribe:@"2021"];
//        [itemArray addObject:item10];
//        //
//        XBarItem* item11 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                          color:[UIColor whiteColor]
//                                                   dataDescribe:@"2022"];
//        [itemArray addObject:item11];
//        XBarItem* item12 = [[XBarItem alloc] initWithDataNumber:@(0)
//                                                          color:[UIColor whiteColor]
//                                                   dataDescribe:@"2023"];
//
//        [itemArray addObject:item12];
//
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
//        UILabel* dataLabel1 = [[UILabel alloc] init];
//        dataLabel1.text = @"(D)";
//        dataLabel1.backgroundColor = [UIColor whiteColor];
//        dataLabel1.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:12];
//        dataLabel1.textColor = [UIColor black50PercentColor];
//        [self.contentView addSubview:dataLabel1];
//        [dataLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self.barChart).offset(-15);
//            make.right.mas_equalTo(self.contentView).offset(0);
//            make.width.mas_equalTo(20);
//            make.height.mas_equalTo(10);
//        }];
        
        UILabel* dataLabel = [[UILabel alloc] init];
        dataLabel.text = Localized(@"tx_electricity_montyly_notice");
        dataLabel.textAlignment = NSTextAlignmentCenter;
        dataLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:15];
        dataLabel.textColor = [UIColor colorFromHexString:@"666666"];
        dataLabel.adjustsFontSizeToFitWidth = YES;
        dataLabel.numberOfLines = 0;
        [self.contentView addSubview:dataLabel];
        [dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView).offset(0);
            make.left.mas_equalTo(self.contentView).offset(0);
            make.right.mas_equalTo(self.contentView).offset(0);
            make.height.mas_equalTo(30);
        }];
    }
    
}
#pragma mark XBarChartDelegate

- (void)userClickedOnBarAtIndex:(NSInteger)idx {
    NSLog(@"XBarChartDelegate touch Bat At idx %lu", idx);
}
@end
