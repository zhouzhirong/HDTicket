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
#import "HDTicketInfoTableViewController.h"
#import "MBProgressHUD.h"
#import "HDTrainInfoModel.h"


@interface TicketTableViewDelegate()


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
        
    }
    else if (indexPath.section==1){
        //查询操作 并保存（还未实现）最近查询的出发地和目的地
        NSString *departure = ((Model *)self.source[0]).detalTitle;
        NSString *arrival = ((Model *)self.source[1]).detalTitle;
        NSString *date = self.dateString;
        HDTicketInfoTableViewController *ticketInfoVC = [[HDTicketInfoTableViewController alloc]init];
        ticketInfoVC.departure = departure;
        ticketInfoVC.arrival = arrival;
        ticketInfoVC.dateStringToprocess = transfer(self.dateString);

        [ticketInfoVC setHidesBottomBarWhenPushed:YES];
        self.viewController.title = @"返回";
        ticketInfoVC.title = [NSString stringWithFormat:@"%@ - %@",departure,arrival];
        [self.viewController.navigationController pushViewController:ticketInfoVC animated:YES];
         NSURL *url = [NSURL URLWithString:LEFTTicket(APPKEY,departure,arrival,date)];
        CONNECTING;
        HDAppDelegate *delegate = HD_APP_DELEGATE;
        [delegate.defaultNetHandle activateWithURL:url headers:nil params:nil method:Get success:^(NSURLSessionDataTask *task, NSDictionary *dic) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"jsonString--%@", jsonString);
            if ([dic[@"reason"] isEqualToString:@"查询成功"]) {
               NSArray *arr = dic[@"result"];
                for (NSDictionary *dict in arr) {
//                    比对一下时间30分钟后发车的才显示出来
                    if (check(self.dateString, dict[@"start_time"])) {
                        HDTrainInfoModel *model = [HDTrainInfoModel new];
                        model.start_time = dict[@"start_time"];
                        model.start_station_name = dict[@"start_station_name"];
                        model.end_station_name = dict[@"end_station_name"];
                        model.from_station_name = dict[@"from_station_name"];
                        model.to_station_name = dict[@"to_station_name"];
                        model.train_no = dict[@"train_no"];
                        model.zy_num = dict[@"zy_num"];
                        model.wz_num = dict[@"wz_num"];
                        model.swz_num = dict[@"swz_num"];
                        model.ze_num = dict[@"ze_num"];
                        model.lishi = dict[@"lishi"];
                        model.yz_num = dict[@"yz_num"];
                        model.yw_num = dict[@"yw_num"];
                        model.rw_num = dict[@"rw_num"];
                        model.arrive_time = dict[@"arrive_time"];
                        [ticketInfoVC.dataSource addObject:model];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ticketInfoVC.tableView reloadData];
                    //加载成功才可点击
                    [ticketInfoVC setValue:@YES forKeyPath:@"bottomBanner.userInteractionEnabled"];
                    [MBProgressHUD hideHUDForView:ticketInfoVC.view animated:YES];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ticketInfoVC setValue:@YES forKeyPath:@"bottomBanner.userInteractionEnabled"];
                    [ticketInfoVC.view addSubview:ticketInfoVC.errorLabel];
                    [MBProgressHUD hideHUDForView:ticketInfoVC.view animated:YES];
                });
            }
            DISCONNECTED;
        } failure:^(NSURLSessionTask *task, NSError *error) {
            NSLog(@"%@",error);
            [ticketInfoVC setValue:@YES forKeyPath:@"bottomBanner.userInteractionEnabled"];
            dispatch_async(dispatch_get_main_queue(), ^{
               [MBProgressHUD hideHUDForView:ticketInfoVC.view animated:YES];
                [ticketInfoVC.view addSubview:ticketInfoVC.errorLabel];
            });
        }];
        DISCONNECTED;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

@end
