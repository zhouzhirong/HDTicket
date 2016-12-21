//
//  TicketViewController.h
//  HDTicket
//
//  Created by 周志荣 on 16/12/12.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^stationChoseBlock)(NSString *,NSInteger);

@protocol updateTableViewDelegate <NSObject>

@optional
-(void)updateTableViewWithSource:(NSDictionary *)change;


@end

@interface TicketViewController : UIViewController

@property (nonatomic,copy)stationChoseBlock block;
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong)UITableView *tableView;


@end
