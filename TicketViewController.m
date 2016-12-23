//
//  TicketViewController.m
//  HDTicket
//
//  Created by 周志荣 on 16/12/12.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "TicketViewController.h"
#import "TicketTableViewDelegate.h"
#import "Model.h"
#import "Station+CoreDataProperties.h"
@interface TicketViewController ()<updateTableViewDelegate>

@property (nonatomic,strong)UINavigationController *nav;
@property (nonatomic,strong)UISegmentedControl *segmentedControl;
//@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)TicketTableViewDelegate * ticketDelegate;
//@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong)NetworkHandle *netHandle;


@end
@implementation TicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
}

/**
 描绘界面
 */
-(void)customUI{

    [self generateDatasource];
    _nav = self.navigationController;
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"普通票",@"学生票",nil];
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.tintColor = RGB(51, 125, 255);
    [_segmentedControl addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:_segmentedControl];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[IMAGE(@"switch") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(destinationSwitch)];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, HEIGHT-20) style:UITableViewStyleGrouped];
    
    _ticketDelegate = [[TicketTableViewDelegate alloc]initWithTableView:_tableView dataSource:_dataSource viewController:self];
    _ticketDelegate.dateString = [self today];
    
    [self.view addSubview:_tableView];
    [_tableView reloadData];
}

-(NSString *)today
{
    NSDate *today = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    return [dateFormatter stringFromDate:today];
}
/**
 生成数据源
 */
-(void)generateDatasource
{
    _dataSource = [NSMutableArray array];
    NSArray *imageNames = @[@"departure",@"arrival",@"date"];
    NSArray *titles = @[@"出发地",@"目的地",@"出发日期"];
    NSArray *initialDetails = @[@"福州",@"厦门",[self currentDay]];
    for (int index=0; index<3; index++) {
        Model *model = [Model new];
        model.imageName = imageNames[index];
        model.title = titles[index];
        model.cellType = CellTypeRegular;
        model.detalTitle = initialDetails[index];
        [_dataSource addObject:model];
    }
    Model *model = [Model new];
    model.cellType = CellTypeSingle;
    model.title = @"查询";
    [_dataSource addObject:model];
}


/**
 获取时间--日期
 */
-(NSString *)currentDay
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"MM月dd日"];
    
    return  [NSString stringWithFormat:@"%@ 今天",[formatter stringFromDate:date]];
}


//学生票和普通票查询
/**
 改变source以后 _tableViewDelegate  的source也随之改变
 */
-(void)segmentChange:(UISegmentedControl *)segmentControl
{
    //普通票查询
    if (segmentControl.selectedSegmentIndex==0) {
        [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Model *model = obj;
            if (model.cellType == CellTypeSingle) {
                model.title = @"查询";
                [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }else{
    //学生票查询  //改变source
        [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Model *model = obj;
            if (model.cellType == CellTypeSingle) {
                model.title = @"查询学生票";
                [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
}

/**
 出发地 目的地 进行交换
 */
-(void)destinationSwitch
{
    Model *model0 = self.dataSource[0];
    Model *model1 = self.dataSource[1];
    NSString *temp = model0.detalTitle;
    model0.detalTitle = model1.detalTitle;
    model1.detalTitle = temp;
    [self.dataSource replaceObjectAtIndex:0 withObject:model0];
    [self.dataSource replaceObjectAtIndex:1 withObject:model1];
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark updateTableView

-(void)updateTableViewWithSource:(NSDictionary *)change
{
    NSInteger index = [change[@"index"] integerValue];
    Model *model = self.dataSource[index];
    model.detalTitle = [change[@"detail"] componentsSeparatedByString:@"年"][1];
    [self.dataSource replaceObjectAtIndex:index withObject:model];
    NSString *original = change[@"detail"];
    NSArray *arr = [original componentsSeparatedByString:@"月"];
    NSString *yearAndMonth = [arr[0] stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    yearAndMonth = yearAndMonth.length==7?yearAndMonth:[yearAndMonth stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:[NSString stringWithFormat:@"%@0",[yearAndMonth substringToIndex:5]]];
    NSString *day = [arr[1] substringToIndex:((NSString *)arr[1]).length-1];
    day = day.length==1?[NSString stringWithFormat:@"0%@",day]:day;
    
    _ticketDelegate.dateString = [NSMutableString stringWithFormat:@"%@-%@",yearAndMonth,day];
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end




