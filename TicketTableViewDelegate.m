//
//  TicketTableViewDelegate.m
//  HDTicket
//
//  Created by 周志荣 on 16/12/12.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "TicketTableViewDelegate.h"
#import "CalenderViewController.h"
#import "CustomCell.h"
#import "NetworkHandle.h"
#import "StationTableViewController.h"
#import "HDAppDelegate.h"
#import "TicketViewController.h"

@interface TicketTableViewDelegate()

@property (nonatomic,strong)NetworkHandle *netHandle;
@property (nonatomic,strong) NSArray * source;
@property (nonatomic,strong)TicketViewController *viewController;
@end
@implementation TicketTableViewDelegate


-(TicketTableViewDelegate *)initWithTableView:(UITableView *)tableView dataSource:(nullable NSArray *)source viewController:(TicketViewController *)viewController
{
    if (self = [super init]) {
        tableView.delegate = self;
        tableView.dataSource = self;
        self.viewController = viewController;
        // 这个方法和 [tableView dequeueReusableCellWithIdentifier:@"ticketCell"]; 这个方法冲突
//        [tableView registerClass:[CustomCell class] forCellReuseIdentifier:@"ticketCell"];
        self.source = source;
    }
    return self;
}

#pragma mark   tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ticketCell"];
    if (!cell) {
        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ticketCell"];
    }
    if (indexPath.section==0) {
        
        cell.model = self.source[indexPath.row];
    }
    NSInteger count = [tableView numberOfRowsInSection:0];
    if (indexPath.section == 1) {
        cell.model = self.source[count];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==2) {
            //选择日期
            CalenderViewController *calenderVC = [[CalenderViewController alloc]init];
            //通过nextResponder 获取到nav
            UIViewController *ticketVC = (UIViewController *)tableView.superview.nextResponder;
            UINavigationController *nav = ticketVC.navigationController;
            ticketVC.title = @"返回"; //目的是改变返回按钮的title
            calenderVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:calenderVC animated:YES];
            
        }else{
            //选择地点
            HDAppDelegate *delegate = HD_APP_DELEGATE;
            UIViewController *topVC = [delegate topViewController];
            UINavigationController *nav = topVC.navigationController;
            topVC.title = @"返回"; //目的是改变返回按钮的title
            StationTableViewController *stationVC = [[StationTableViewController alloc]init];
            stationVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:stationVC animated:YES];
            stationVC.searchSuccessBlock = ^(NSString *title,NSInteger stationType){
                Model *model = self.viewController.dataSource[stationType];
                model.detalTitle = title;
                [self.viewController.dataSource replaceObjectAtIndex:stationType withObject:model];
                [self.viewController.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:stationType inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            };
            //回调的时候要用
            if (indexPath.row==0) {
                stationVC.stationType = TypeDeparture;
            }else{
                stationVC.stationType = TypeArrival;
            }
        }
        
    }else if (indexPath.section==1){
        //查询操作 并保存最近查询的出发地和目的地
        //获取出发和到达地点
//        NSString *departure = ((Model *)self.source[0]).detalTitle;
//        NSString *arrival = ((Model *)self.source[1]).detalTitle;
        //生成查询URL
//        NSURL *url = [NSURL URLWithString:CHECK(departure,arrival,APPKEY)];
//        [self.netHandle activateWithURL:url headers:nil params:nil method:Get success:^(NSURLSessionDataTask *task, NSDictionary *dic) {
//            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            
//            NSLog(@"jsonString--%@", jsonString);
//            
//        } failure:^(NSURLSessionTask *task, NSError *error) {
//            
//            NSLog(@"%@",error);
//        }];   
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//先不考虑后台查询
-(NetworkHandle *)netHandle
{
    HDAppDelegate *delegate = HD_APP_DELEGATE;
    return delegate.defaultNetHandle;
}

@end















































