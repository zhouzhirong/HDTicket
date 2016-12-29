//
//  HDTicketInfoTableViewController.h
//  HDTicket
//
//  Created by 周志荣 on 2016/12/22.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDTicketInfoTableViewController : UITableViewController

@property (nonatomic,copy)NSString *departure;

@property (nonatomic,copy)NSString *arrival;

@property (nonatomic, strong)NSMutableArray *filteredSource;
@property (nonatomic , strong)NSMutableArray *dataSource;

@property (nonatomic,copy)NSString *dateStringToprocess; //

@property (nonatomic , strong)UILabel *errorLabel;


@end
