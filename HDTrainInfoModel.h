//
//  HDTrainInfoModel.h
//  HDTicket
//
//  Created by 周志荣 on 2016/12/22.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDTrainInfoModel : NSObject

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



@end
