//
//  Model.h
//  HDTicket
//
//  Created by 周志荣 on 16/12/12.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    CellTypeRegular = 1,   //正常cell
    CellTypeSingle = 2,    //只有一个标签 如查询
    CellTypeTriple = 3     //有三个标签 机票 抢票  汽车票 or  机票订单  汽车票订单 其他订单 共两种情况
}CustomCellType;

@interface Model : NSObject

@property (nonatomic, copy) NSString * imageName;    //图片名-固定
@property (nonatomic, copy) NSString * title;        //出发地 目的地  出发日期-----三个固定
@property (nonatomic, copy) NSString * detalTitle;   // 选择的地点 时间----可变
@property (nonatomic, copy) NSString * sigle;        //   查询----单个cell标签
@property (nonatomic,strong) NSArray * tripleTitles; //  三(多)个标签
@property (nonatomic,assign) CustomCellType cellType; //cell类型

@end
