//
//  StationTableViewController.m
//  HDTicket
//
//  Created by 周志荣 on 16/12/13.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "StationTableViewController.h"
#import "HDStationFetchedResultsControllerDataSource.h"
//#import <sys/time.h>
//
//struct timeval gStartTime;
//
//void Start(void)
//{
//    gettimeofday(&gStartTime, NULL);
//}
//
//void End(void)
//{
//    struct timeval endtv;
//    gettimeofday(&endtv, NULL);
//    
//    double start = gStartTime.tv_sec * 1000000 + gStartTime.tv_usec;
//    double end = endtv.tv_sec * 1000000 + endtv.tv_usec;
//    
//    NSLog(@"Operation took %f seconds to complete", (end - start) / 1000000.0);
//}



@interface StationTableViewController ()

@property (nonatomic,strong)HDAppDelegate *delegate;
//@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic,strong) NSFetchedResultsController *fetchResultsController;
//@property (nonatomic,strong) NSFetchedResultsController *searchFetchResultsController;
@property (nonatomic,strong) HDStationFetchedResultsControllerDataSource *stationFetchedResultsControllerDataSource;




@end
@implementation StationTableViewController

/**
 初始化的时候就  从数据库里面加载数据 
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = HD_APP_DELEGATE;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Station" inManagedObjectContext:[_delegate.localManager managedObjectContext]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name != nil"];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
        NSSortDescriptor *firstSort = [NSSortDescriptor sortDescriptorWithKey:@"firstLetter" ascending:YES];
        NSSortDescriptor *combineSort = [NSSortDescriptor sortDescriptorWithKey:@"combineLetter" ascending:YES];
        [fetchRequest setSortDescriptors:@[firstSort,combineSort]];
        [fetchRequest setFetchBatchSize:10];
        _fetchResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[_delegate.localManager managedObjectContext] sectionNameKeyPath:@"firstLetter" cacheName:@"stationsList"];
        NSError *error = nil;
        
        if (![self.fetchResultsController performFetch:&error]) {
            abort();
        }
    }
    return self;
}

-(HDStationFetchedResultsControllerDataSource *)stationFetchedResultsControllerDataSource
{
    if (!_stationFetchedResultsControllerDataSource) {
        _stationFetchedResultsControllerDataSource = [[HDStationFetchedResultsControllerDataSource alloc]initWithTableView:self.tableView fetchedResultsCpntroller:self.fetchResultsController controller:self];
        
    }
    return _stationFetchedResultsControllerDataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self UI];
    [self.tableView reloadData];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}


-(void)UI
{
    //修改搜索框旁边的cancel颜色和title-----------这个可以实现
//    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]] ] setTintColor:RGB(51, 125, 255)];
//    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]] ] setTitle:@"取消"];
    
    self.title = @"选择车站";
    self.clearsSelectionOnViewWillAppear = NO;
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    [_searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
    self.tableView.tableHeaderView = _searchController.searchBar;
    _searchController.searchBar.placeholder = @"站名或者首字母,例如:北京,bj";
    
    _searchController.delegate = self.stationFetchedResultsControllerDataSource;
    _searchController.searchResultsUpdater = self.stationFetchedResultsControllerDataSource;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"更新车站" style:UIBarButtonItemStylePlain target:self action:@selector(updateStations)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//更新车站 重新发送请求 请求车站列表  其他的出第一次更新外从数据库中取出来
-(void)updateStations
{
   NSLog(@"更新车站列表");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
