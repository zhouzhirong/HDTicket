//
//  HDBottomBanner.m
//  HDTicket
//
//  Created by 周志荣 on 2016/12/23.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "HDTicketInfoTableViewController.h"
#import "HDTrainInfoModel.h"
#import "HDBottomBanner.h"
#import "MBProgressHUD.h"
#import "HDFilterViewController.h"
@interface HDBottomBanner ()

@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UILabel  *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *shootButton;

@property (nonatomic, strong)HDTicketInfoTableViewController *ticketInfoVC;

@end
@implementation HDBottomBanner
//代码加载的时候会依次调用 initWithFrame  init
//xib加载的时候会依次调用 initWithCoder  awakeFromNib

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

-(HDTicketInfoTableViewController *)ticketInfoVC
{
    if (!_ticketInfoVC) {
        HDAppDelegate *delegate = HD_APP_DELEGATE;
        _ticketInfoVC = (HDTicketInfoTableViewController *)[delegate topViewController];
    }
    return _ticketInfoVC;
}


-(void)setDateString:(NSString *)dateString
{
    _dateString = dateString;
    dispatch_async(dispatch_get_main_queue(), ^{
        _dateLabel.text = [dateString componentsSeparatedByString:@"年"][1];
        //如果是今天的话 返回按钮不能用
        if (isToday(_dateString)) {
            _previousButton.enabled = NO;
        }else{
            _previousButton.enabled = YES;
        }
    });
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}



//筛选控制器
- (IBAction)filter:(UIButton *)sender
{
    NSArray *dataSource = self.ticketInfoVC.dataSource;
    if (!dataSource) {
        return;
    }
    NSMutableArray *stationsToGetOn = [NSMutableArray new];
    NSMutableArray *stationsToGetOff = [NSMutableArray new];
    [dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {}];
    for (HDTrainInfoModel *model in dataSource)
    {
        [stationsToGetOn addObject:model.from_station_name];
        [stationsToGetOff addObject:model.to_station_name];
    }
    NSSet *set = [NSSet setWithArray:stationsToGetOn];
    [stationsToGetOn removeAllObjects];
    stationsToGetOn = [NSMutableArray arrayWithArray:[set allObjects]];
    set= [NSSet setWithArray:stationsToGetOff];
    [stationsToGetOff removeAllObjects];
    stationsToGetOff = [NSMutableArray arrayWithArray:[set allObjects]];
    HDFilterViewController *filterVC = [[HDFilterViewController alloc]init];
    filterVC.departureStations = stationsToGetOn;
    filterVC.arrivalStations = stationsToGetOff;
    filterVC.ticketInfoVC = self.ticketInfoVC;
    filterVC.originalDataSourceFromTicketVC = self.ticketInfoVC.dataSource;
    [self.ticketInfoVC.navigationController presentViewController:filterVC animated:YES completion:^{}];
}

//时间改为前一天 并显示
- (IBAction)previousDay:(UIButton *)sender
{
   self.dateString = previousDay(self.dateString);
    //顺便刷新
    HDAppDelegate *delegate = HD_APP_DELEGATE;
    [self.ticketInfoVC.errorLabel removeFromSuperview];
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.ticketInfoVC.view];
    HUD.darkBlur = YES;
    HUD.labelText = @"获取车次列表";
    //显示对话框
    [_ticketInfoVC.view addSubview:HUD];
    [HUD show:YES];
    [_ticketInfoVC setValue:@NO forKeyPath:@"bottomBanner.userInteractionEnabled"];
    NSURL *url = [NSURL URLWithString:LEFTTicket(APPKEY, _ticketInfoVC.departure, _ticketInfoVC.arrival, transfer(self.dateString))];
    [delegate.defaultNetHandle activateWithURL:url headers:nil params:nil method:Get success:^(NSURLSessionDataTask *task, NSDictionary *dic) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"jsonString--%@", jsonString);
        if ([dic[@"reason"] isEqualToString:@"查询成功"]) {
            NSArray *arr = dic[@"result"];
            //先清除原来的旧数据
            [_ticketInfoVC.dataSource removeAllObjects];
            
            for (NSDictionary *dict in arr) {
                //比对一下时间30分钟后发车的才显示出来
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
                    [_ticketInfoVC.dataSource addObject:model];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_ticketInfoVC.tableView reloadData];
                [_ticketInfoVC setValue:@YES forKeyPath:@"bottomBanner.userInteractionEnabled"];
                [MBProgressHUD hideHUDForView:_ticketInfoVC.view animated:YES];
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [_ticketInfoVC.view addSubview:_ticketInfoVC.errorLabel];
                [_ticketInfoVC setValue:@YES forKeyPath:@"bottomBanner.userInteractionEnabled"];
                [MBProgressHUD hideHUDForView:_ticketInfoVC.view animated:YES];
            });
        }
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_ticketInfoVC setValue:@YES forKeyPath:@"bottomBanner.userInteractionEnabled"];
            [MBProgressHUD hideHUDForView:_ticketInfoVC.view animated:YES];
        });
        
    }];
}


- (IBAction)nextDay:(UIButton *)sender
{
   self.dateString = nextDay(self.dateString);
    //顺便刷新
    HDAppDelegate *delegate = HD_APP_DELEGATE;
    HDTicketInfoTableViewController *ticketInfoVC = (HDTicketInfoTableViewController *)[delegate topViewController];
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:ticketInfoVC.view];
    [ticketInfoVC.errorLabel removeFromSuperview];
    HUD.darkBlur = YES;
    HUD.labelText = @"获取车次列表";
    //显示对话框
    [ticketInfoVC.view addSubview:HUD];
    [HUD show:YES];
    [ticketInfoVC setValue:@NO forKeyPath:@"bottomBanner.userInteractionEnabled"];
    NSURL *url = [NSURL URLWithString:LEFTTicket(APPKEY, ticketInfoVC.departure, ticketInfoVC.arrival, transfer(self.dateString))];
    CONNECTING;
    [delegate.defaultNetHandle activateWithURL:url headers:nil params:nil method:Get success:^(NSURLSessionDataTask *task, NSDictionary *dic) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"jsonString--%@", jsonString);
        if ([dic[@"reason"] isEqualToString:@"查询成功"]) {
            NSArray *arr = dic[@"result"];
            //先清除原来的旧数据
            [ticketInfoVC.dataSource removeAllObjects];
            
            for (NSDictionary *dict in arr) {
                //比对一下时间30分钟后发车的才显示出来
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
                DISCONNECTED;
                [ticketInfoVC setValue:@YES forKeyPath:@"bottomBanner.userInteractionEnabled"];
                [MBProgressHUD hideHUDForView:ticketInfoVC.view animated:YES];
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                DISCONNECTED;
                [ticketInfoVC setValue:@YES forKeyPath:@"bottomBanner.userInteractionEnabled"];
                [ticketInfoVC.view addSubview:ticketInfoVC.errorLabel];
                [MBProgressHUD hideHUDForView:ticketInfoVC.view animated:YES];
            });
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        DISCONNECTED;
        NSLog(@"%@",error);
        [ticketInfoVC setValue:@YES forKeyPath:@"bottomBanner.userInteractionEnabled"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [ticketInfoVC.view addSubview:ticketInfoVC.errorLabel];
            [MBProgressHUD hideHUDForView:_ticketInfoVC.view animated:YES];
        });
    }];
}


- (IBAction)shoot:(UIButton *)sender
{
//    抢票
    
}



@end




















