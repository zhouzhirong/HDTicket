//
//  HDTrainInfoCell.m
//  HDTicket
//
//  Created by 周志荣 on 2016/12/22.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "HDTrainInfoCell.h"

typedef NS_ENUM(NSInteger,TRAINTYPE) {
    D_TYPE,
    G_TYPE,
    OTHER_TYPE
};
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
 @property(nonatomic,copy)NSString *start_station_name;  //出发站类型
 @property(nonatomic,copy)NSString *end_station_name;    //到达站类型
 @property(nonatomic,copy)NSString *start_time;          //出发时间
 @property(nonatomic,copy)NSString *arrive_time;         //到达时间
 @property(nonatomic,copy)NSString *lishi;               //运行时间
 @property(nonatomic,copy)NSString *train_no;            //列车号
 @property(nonatomic,copy)NSString *to_station_name;     //对比end_station_name看是经过还是终点站
 @property(nonatomic,copy)NSString *from_station_name;   //对比start_station_name看是经过还是始发站
 @property(nonatomic,copy)NSString *zy_num;          //一等座剩余
 @property(nonatomic,copy)NSString *ze_num;          //二等座剩余
 @property(nonatomic,copy)NSString *wz_num;          //无座剩余
 @property(nonatomic,copy)NSString *swz_num;          //商务座剩余
 @property(nonatomic,copy)NSString *yz_num;           //硬座
 @property(nonatomic,copy)NSString *yw_num;           //硬卧剩余
 @property(nonatomic,copy)NSString *rw_num;           //软卧

 */
//  高铁:商务座 一等座 二等座
//  动车:一等座 二等座 无座
//  其他的包括   硬座 硬卧 软卧 无座
-(void)setTrainInfoModel:(HDTrainInfoModel *)trainInfoModel
{
    TRAINTYPE type;
    
    _trainInfoModel = trainInfoModel;
    
    _train_no.text = trainInfoModel.train_no;
    if ([trainInfoModel.train_no hasPrefix:@"D"]) {
        type = D_TYPE;
    }else if ([trainInfoModel.train_no hasPrefix:@"G"]){
        type = G_TYPE;
    }else{
        type = OTHER_TYPE;
    }
    _startStationType = [trainInfoModel.from_station_name isEqualToString:trainInfoModel.start_station_name] ? @"" : @"过·";
    _arriveStationType = [trainInfoModel.to_station_name isEqualToString:trainInfoModel.end_station_name] ? @"" : @"过·";
    
    _stationsInfo.text = [NSString stringWithFormat:@"%@%@ - %@%@",_startStationType,trainInfoModel.from_station_name,_arriveStationType,trainInfoModel.to_station_name];
    _stationsInfo.textColor = RGB(40, 40, 40);
    _departAndArrival.text = [NSString stringWithFormat:@"%@~%@",trainInfoModel.start_time,trainInfoModel.arrive_time];
    _departAndArrival.textColor = [UIColor lightGrayColor];
    _runtime.text = [NSString stringWithFormat:@"历时%@",trainInfoModel.lishi];
    _runtime.textColor = [UIColor lightGrayColor];
    
    switch (type) {
        case D_TYPE:
        case G_TYPE:
            if ([trainInfoModel.ze_num isEqualToString:@"无"]) {
                _ze_num.text = @"二等座 0";
                _ze_num.textColor = RGB(175, 175, 175);
            }
            else{
                _ze_num.text = [NSString stringWithFormat:@"二等座 %@",trainInfoModel.ze_num];
                _ze_num.textColor = RGB(0, 145, 238);
            }
            
            if ([trainInfoModel.zy_num isEqualToString:@"无"]) {
                _zy_num.text = @"一等座 0";
                _zy_num.textColor = RGB(175, 175, 175);
            }else{
                _zy_num.text = [NSString stringWithFormat:@"一等座 %@",trainInfoModel.zy_num];
                _zy_num.textColor = RGB(0, 145, 238);
            }
            if (type==D_TYPE)
            {
                if ([trainInfoModel.wz_num isEqualToString:@"无"]) {
                    _wz_num.text = @"无座 0";
                    _wz_num.textColor = RGB(175, 175, 175);
                }else{
                    _wz_num.text = [NSString stringWithFormat:@"无座 %@",trainInfoModel.wz_num];
                    _wz_num.textColor = RGB(0, 145, 238);
                }
            }
            else
            {
                if ([trainInfoModel.swz_num isEqualToString:@"无"]) {
                    _wz_num.text = @"商务座 0";
                    _wz_num.textColor = RGB(175, 175, 175);
                }else{
                    _wz_num.text = [NSString stringWithFormat:@"商务座 %@",trainInfoModel.swz_num];
                    _wz_num.textColor = RGB(0, 145, 238);
                }
            }
            break;

        default:
            //非高铁动车类火车 按无座 硬座 硬卧 软卧排序
            if ([trainInfoModel.wz_num isEqualToString:@"无"]) {
                _ze_num.text = @"无座 0";
                _ze_num.textColor = RGB(175, 175, 175);
            }
            else{
                _ze_num.text = [NSString stringWithFormat:@"无座 %@",trainInfoModel.wz_num];
                _ze_num.textColor = RGB(0, 145, 238);
            }
            
            if ([trainInfoModel.yz_num isEqualToString:@"无"]) {
                _zy_num.text = @"硬座 0";
                _zy_num.textColor = RGB(175, 175, 175);
            }else{
                _zy_num.text = [NSString stringWithFormat:@"硬座 %@",trainInfoModel.yz_num];
                _zy_num.textColor = RGB(0, 145, 238);
            }
            
            if ([trainInfoModel.yw_num isEqualToString:@"无"]) {
                _wz_num.text = @"硬卧 0";
                _wz_num.textColor = RGB(175, 175, 175);
            }else{
                _wz_num.text = [NSString stringWithFormat:@"硬卧 %@",trainInfoModel.yw_num];
                _wz_num.textColor = RGB(0, 145, 238);
            }
            
            if ([trainInfoModel.rw_num isEqualToString:@"无"]) {
                _yz_num.text = @"软卧 0";
                _yz_num.textColor = RGB(175, 175, 175);
            }else{
                _yz_num.text = [NSString stringWithFormat:@"软卧 %@",trainInfoModel.rw_num];
                _yz_num.textColor = RGB(0, 145, 238);
            }
            
            break;
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













































