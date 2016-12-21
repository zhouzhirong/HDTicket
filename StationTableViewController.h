//
//  StationTableViewController.h
//  HDTicket
//
//  Created by 周志荣 on 16/12/13.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

typedef  NS_ENUM(NSInteger,StationType){
    TypeDeparture,
    TypeArrival
};

@interface StationTableViewController : UITableViewController

@property (nonatomic,assign)StationType stationType;
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic,copy) void(^searchSuccessBlock)(NSString *,NSInteger);
@end
