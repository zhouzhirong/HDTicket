//
//  HDTicketInfoTableViewController.h
//  HDTicket
//
//  Created by 周志荣 on 2016/12/22.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDTicketInfoTableViewController : UITableViewController

@property (nonatomic , strong)NSMutableArray *dataSource;//数据源  典型MVC

@property (nonatomic,copy)NSString *dateStringForBannerLabel; //

@property (nonatomic , strong)UILabel *errorLabel;

@end
