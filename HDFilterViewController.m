//
//  HDFilterViewController.m
//  HDTicket
//
//  Created by 周志荣 on 2016/12/28.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "HDFilterViewController.h"
#import "HDTrainInfoModel.h"
@interface HDFilterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UINavigationBar *navigationBar;


@property (nonatomic, strong)NSMutableDictionary *conditionDict;
@property (nonatomic, strong)NSMutableArray *fromArr;
@property (nonatomic, strong)NSMutableArray *toArr;
@property (nonatomic, strong)NSMutableArray *timeArr;
@property (nonatomic, strong)NSMutableArray *typeArr;

@end

@implementation HDFilterViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
        UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@"筛选"];
        item.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
        item.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(refreshOnConditions)];
        [_navigationBar pushNavigationItem:item animated:YES];
        [self.view addSubview:_navigationBar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView reloadData];
}

//关闭
-(void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//确定 并按条件搜索出来的结果显示
-(void)refreshOnConditions
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    __block NSMutableArray *originalDataSource = [[NSMutableArray alloc]initWithArray:self.ticketInfoVC.dataSource];
    [self.ticketInfoVC.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HDTrainInfoModel *model = obj;
        NSArray *fromStations = [self.conditionDict valueForKey:@"from"];
        NSArray *toStations = [self.conditionDict valueForKey:@"to"];
        NSArray *timeTogo = [self.conditionDict valueForKey:@"time"];
        NSArray *trainTypes = [self.conditionDict valueForKey:@"type"];
        BOOL from=NO,to=NO,time=NO,type=NO;
        //乘车站
        if (fromStations)
        {
            for (NSString *str in fromStations)
            {
                if ([model.from_station_name isEqualToString:str])
                {
                    from=YES;
                }
            }
        }
        //下车站
       if (toStations)
       {
           for (NSString *str in toStations)
           {
               if ([model.to_station_name isEqualToString:str])
               {
                   to=YES;
               }
           }
        }
        //发车时间
       if (timeTogo)
       {
           for (NSString* str in timeTogo)
           {
               if ([model.start_time substringToIndex:2].integerValue > [str substringToIndex:2].integerValue && [model.start_time substringToIndex:2].integerValue < [str substringToIndex:2].integerValue+6)
               {
                   time = YES;
               }
           }
        }
        //车次类型
       if (trainTypes)
       {
           for (NSString *str in trainTypes)
           {
               if ([[model.train_no substringToIndex:1] isEqualToString:[str substringToIndex:1]])
               {
                   type = YES;
               }
           }
        }
        if (from||to||time||type) {
            [originalDataSource removeObject:model];
        }
    }];
    self.ticketInfoVC.filteredSource = originalDataSource;
    [self.ticketInfoVC.tableView reloadData];
}

#pragma mark   dataSource
#pragma mark   Table view data source

/**
 出发车站   到达车站   出发时间    车次类型
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return _departureStations.count;
            break;
        case 1:
            return _arrivalStations.count;
            break;
        case 2:
            return 4;   //6个小时一个时间段
            break;
        case 3:
            return 6;   //6种车型
            break;
        default:
            break;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"出发车站";
            break;
        case 1:
            return @"到达车站车站";
            break;
        case 2:
            return @"出发时间";
            break;
        case 3:
            return @"车次类型";
            break;
        default:
            break;
    }
    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FilterCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    if (indexPath.section==0) {
        cell.textLabel.text = _departureStations[indexPath.row];
    }
    else if (indexPath.section==1){
        cell.textLabel.text = _arrivalStations[indexPath.row];
    }
    else if (indexPath.section==2) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"00:00--06:00";
                break;
            case 1:
                cell.textLabel.text = @"06:00--12:00";
                break;
            case 2:
                cell.textLabel.text = @"12:00--18:00";
                break;
            case 3:
                cell.textLabel.text = @"18:00--24:00";
                break;
            default:
                break;
        }
    }
    else if (indexPath.section==3){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"GC高铁/城际";
                break;
            case 1:
                cell.textLabel.text = @"D动车";
                break;
            case 2:
                cell.textLabel.text = @"Z字头";
                break;
            case 3:
                cell.textLabel.text = @"T字头";
                break;
            case 4:
                cell.textLabel.text = @"K字头";
                break;
            case 5:
                cell.textLabel.text = @"其他(L/Y)";
                break;
            default:
                break;
        }
    }
    return cell;
}
//数组里面是要剔除的
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        if (indexPath.section==0) {
            //出发站  from
            [self.fromArr removeObject:cell.textLabel.text];
            
        }else if (indexPath.section==1){
            //目的站   to
            [self.toArr removeObject:cell.textLabel.text];
            
        }else if (indexPath.section==2){
            //出发时间  4个时间段
            [self.timeArr removeObject:cell.textLabel.text];
            
        }else if (indexPath.section==3){
            //车次类型
            [self.typeArr removeObject:cell.textLabel.text];
            
        }
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        if (indexPath.section==0) {
            //出发站  from
            [self.fromArr addObject:cell.textLabel.text];
            
        }else if (indexPath.section==1){
            //目的站   to
            [self.toArr addObject:cell.textLabel.text];
            
        }else if (indexPath.section==2){
            //出发时间  4个时间段
            [self.timeArr addObject:cell.textLabel.text];
            
        }else if (indexPath.section==3){
            //车次类型
            [self.typeArr addObject:cell.textLabel.text];
            
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSMutableArray *)fromArr
{
    if (!_fromArr) {
        _fromArr = [NSMutableArray new];
    }
    return _fromArr;
}
-(NSMutableArray *)toArr
{
    if (!_toArr) {
        _toArr = [NSMutableArray new];
    }
    return _toArr;
}
-(NSMutableArray *)timeArr
{
    if (!_timeArr) {
        _timeArr = [NSMutableArray new];
    }
    return _timeArr;
}
-(NSMutableArray *)typeArr
{
    if (!_typeArr) {
        _typeArr = [NSMutableArray new];
    }
    return _typeArr;
}

-(NSMutableDictionary *)conditionDict
{
    if (!_conditionDict) {
        _conditionDict = [NSMutableDictionary new];
        if(_fromArr)[_conditionDict setObject:_fromArr forKey:@"from"];
        if(_toArr)[_conditionDict setObject:_toArr forKey:@"to"];
        if(_timeArr)[_conditionDict setObject:_timeArr forKey:@"time"];
        if(_typeArr)[_conditionDict setObject:_typeArr forKey:@"type"];
    }
    return _conditionDict;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}



@end
