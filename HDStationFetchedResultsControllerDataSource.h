//
//  HDStationFetchedResultsControllerDataSource.h
//  HDTicket
//
//  Created by 周志荣 on 2016/12/19.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TicketViewController.h"
@interface HDStationFetchedResultsControllerDataSource : NSObject<updateTableViewDelegate>

@property (nonatomic,weak)id<updateTableViewDelegate> delegate;

//实现代码分离
- (id)initWithTableView:(UITableView *)tableView fetchedResultsCpntroller:(NSFetchedResultsController *)fetchedResultsController controller:(UIViewController *)viewController;

@end
