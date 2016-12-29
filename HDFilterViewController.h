//
//  HDFilterViewController.h
//  HDTicket
//
//  Created by 周志荣 on 2016/12/28.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDTicketInfoTableViewController.h"
@interface HDFilterViewController : UIViewController

@property (nonatomic, strong)NSArray *originalDataSourceFromTicketVC;

@property (nonatomic,strong)NSArray *departureStations;

@property (nonatomic,strong)NSArray *arrivalStations;

@property (nonatomic, strong)HDTicketInfoTableViewController *ticketInfoVC;

@end
