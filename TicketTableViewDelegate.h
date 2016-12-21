//
//  TicketTableViewDelegate.h
//  HDTicket
//
//  Created by 周志荣 on 16/12/12.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TicketViewController;

@interface TicketTableViewDelegate : NSObject<UITableViewDelegate,UITableViewDataSource>


-(TicketTableViewDelegate *)initWithTableView:(UITableView *)tableView dataSource:(nullable NSArray *)source viewController:(TicketViewController *)viewController;


@end
