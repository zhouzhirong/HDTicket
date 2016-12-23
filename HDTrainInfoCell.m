//
//  HDTrainInfoCell.m
//  HDTicket
//
//  Created by 周志荣 on 2016/12/22.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "HDTrainInfoCell.h"

@interface HDTrainInfoCell()


@property (weak, nonatomic) IBOutlet UILabel *train_no;         // 车次
@property (weak, nonatomic) IBOutlet UILabel *stationsInfo;     // 出发站和始发站信息
@property (weak, nonatomic) IBOutlet UILabel *departAndArrival; // 发车时间和到达时间
@property (weak, nonatomic) IBOutlet UILabel *runtime;          // 历时
@property (weak, nonatomic) IBOutlet UILabel *ze_num;           // 二等座
@property (weak, nonatomic) IBOutlet UILabel *zy_num;           // 一等座
@property (weak, nonatomic) IBOutlet UILabel *wz_num;           // 无座或者商务座(高铁)
@property (weak, nonatomic) IBOutlet UILabel *yz_num;           // 硬座

@property (nonatomic, copy) NSString *startStationType;
@property (nonatomic, copy) NSString *arriveStationType;


@end
@implementation HDTrainInfoCell

/*
 
 @property(nonatomic,copy)NSString *start_station_name;  //出发站
 @property(nonatomic,copy)NSString *end_station_name;    //到达站
 @property(nonatomic,copy)NSString *start_time;          //出发时间
 @property(nonatomic,copy)NSString *arrive_time;         //到达时间
 @property(nonatomic,copy)NSString *lishi;               //运行时间
 @property(nonatomic,copy)NSString *train_no;            //列车号
 
 @property(nonatomic,copy)NSString *to_station_name;     //对比end_station_name看是经过还是终点站
 @property(nonatomic,copy)NSString *from_station_name;   //对比start_station_name看是经过还是始发站
 @property(nonatomic,copy)NSString *zy_num;              //一等座剩余
 @property(nonatomic,copy)NSString *wz_num;              //无座剩余
 @property(nonatomic,copy)NSString *ze_num;              //二等座剩余
 
 */

-(void)setTrainInfoModel:(HDTrainInfoModel *)trainInfoModel
{
    _trainInfoModel = trainInfoModel;
    
    _train_no.text = trainInfoModel.train_no;
   
    _startStationType = [trainInfoModel.from_station_name isEqualToString:trainInfoModel.start_station_name] ? @"" : @"过·";
    _arriveStationType = [trainInfoModel.to_station_name isEqualToString:trainInfoModel.end_station_name] ? @"" : @"过·";
    
    _stationsInfo.text = [NSString stringWithFormat:@"%@%@ - %@%@",_startStationType,trainInfoModel.from_station_name,_arriveStationType,trainInfoModel.to_station_name];
    
    _departAndArrival.text = [NSString stringWithFormat:@"%@~%@",trainInfoModel.start_time,trainInfoModel.arrive_time];
    _departAndArrival.textColor = [UIColor lightGrayColor];
    _runtime.text = [NSString stringWithFormat:@"历时%@",trainInfoModel.lishi];
    _runtime.textColor = [UIColor lightGrayColor];
    if ([trainInfoModel.ze_num isEqualToString:@"无"]) {
        _ze_num.text = @"二等座 0";
        _ze_num.textColor = RGB(175, 175, 175);
    }
    else{
        _ze_num.text = [NSString stringWithFormat:@"二等座 %@",trainInfoModel.ze_num];
        _ze_num.textColor = RGB(0, 145, 238);
    }
    
    if ([trainInfoModel.zy_num isEqualToString:@"无"]) {
        _zy_num.text = @"二等座 0";
        _zy_num.textColor = RGB(175, 175, 175);
    }else{
        _zy_num.text = [NSString stringWithFormat:@"一等座 %@",trainInfoModel.zy_num];
        _zy_num.textColor = RGB(0, 145, 238);
    }
    
    if ([trainInfoModel.wz_num isEqualToString:@"无"]) {
        _wz_num.text = @"二等座 0";
        _wz_num.textColor = RGB(175, 175, 175);
    }else{
        _wz_num.text = [NSString stringWithFormat:@"无座 %@",trainInfoModel.wz_num];
        _wz_num.textColor = RGB(0, 145, 238);
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end













































