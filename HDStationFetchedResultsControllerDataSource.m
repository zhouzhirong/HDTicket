//
//  HDStationFetchedResultsControllerDataSource.m
//  HDTicket
//
//  Created by 周志荣 on 2016/12/19.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "HDStationFetchedResultsControllerDataSource.h"
#import "Station+CoreDataProperties.h"
#import "TicketViewController.h"
#import "StationTableViewController.h"

@interface HDStationFetchedResultsControllerDataSource()<NSFetchedResultsControllerDelegate,UISearchResultsUpdating,UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,strong)StationTableViewController *viewController;


//@property(nonatomic,strong)NSFetchedResultsController *searchFetchedResultsController;

@property(nonatomic,strong)UITableView *searchTableView;
@property(nonatomic,strong)NSMutableArray *stationList;
@property(nonatomic,strong)NSMutableArray *searchList;
@property(nonatomic,assign)BOOL isSearch;


@end
@implementation HDStationFetchedResultsControllerDataSource


/**
 创建一个对象 处理tableView 和 fetchedResultsController的各种交互

 @param tableView      self.tableView
 @param fetchedResultsController fetchedResultsController 
 @param viewController      代理对象self的主人 如果viewController的UI需要作出相应的改变就可以用到(暂时不会用到)
 @return            返回一个代替本类处理各种回调的代理对象
 */
-(id)initWithTableView:(UITableView *)tableView fetchedResultsCpntroller:(NSFetchedResultsController *)fetchedResultsController controller:(StationTableViewController *)viewController
{
    if (self = [super init]) {
        
        self.tableView = tableView;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.fetchedResultsController = fetchedResultsController;
        self.fetchedResultsController.delegate = self;
        self.viewController = viewController;
        _searchList = [NSMutableArray new];
    }
    return self;
}




#pragma mark UITableViewDataSource
//sections
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //正在搜索的话
    if (_isSearch && _searchList.count>0) {
        return 1;
    }
    
    if (self.fetchedResultsController && [self.fetchedResultsController sections].count>0) {
        return self.fetchedResultsController.sections.count;
    }
    return 0;
}
//rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //正在搜索的话
    if (_isSearch && _searchList.count>0) {
        return self.searchList.count;
    }
    if (self.fetchedResultsController && self.fetchedResultsController.sections.count>0) {
        return [self.fetchedResultsController.sections[section] numberOfObjects];
    }
    return 0;
}

//section tilte
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //正在搜索的话
    if (_isSearch && _searchList.count>0) {
        return nil;
    }
    return self.fetchedResultsController.sections[section].indexTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stationCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"stationCell"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //搜索时
    if (_isSearch  &&  _searchList.count>0) {
        Station *station = self.searchList[indexPath.row];
        cell.textLabel.text = station.name;
    }else{
     [self configCell:cell atIndexPath:indexPath resultController:self.fetchedResultsController];
    }
    return cell;
}

//配置cell
-(void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath resultController:(NSFetchedResultsController *)resultController
{
    Station *station = [resultController objectAtIndexPath:indexPath];
    cell.textLabel.text = station.name;
}


#pragma mark tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *placeString = cell.textLabel.text;
    
    if (self.viewController.searchSuccessBlock) {
        self.viewController.searchSuccessBlock(placeString,self.viewController.stationType);
    }
    self.viewController.searchController.active = NO;
    [self.viewController.navigationController popViewControllerAnimated:YES];
}


-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_isSearch) {
        return @[@""];
    }
    return [self.fetchedResultsController sectionIndexTitles];;
}



#pragma mark UISearchControllerDelegate

// These methods are called when automatic presentation or dismissal occurs. They will not be called if you present or dismiss the search controller yourself.
- (void)willPresentSearchController:(UISearchController *)searchController
{

}
- (void)didPresentSearchController:(UISearchController *)searchController
{
    _isSearch = YES;
}
- (void)willDismissSearchController:(UISearchController *)searchController
{
    
}
- (void)didDismissSearchController:(UISearchController *)searchController
{
    _isSearch = NO;
    [self dispose];
}

#pragma mark  UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.searchList removeAllObjects];
    //匹配
    NSString *searchText = searchController.searchBar.text;
    if (searchText==nil||[searchText isEqualToString:@""]) {
        [self dispose];
        searchController.dimsBackgroundDuringPresentation = YES;
    }else{
        [self searchTableView];
        searchText = [searchText uppercaseString];
        NSArray *fullDatas = [self stationList];
        for (Station *station in fullDatas)
        {
            if ([station.name containsString:searchText] || [station.combineLetter containsString:searchText])
            {
                [_searchList addObject:station];
            }
        }
    }
    if (_searchList==nil || _searchList.count==0) {
        [self dispose];
    }else{
        [searchController.view addSubview:_searchTableView];
        [self.searchTableView reloadData];
    }
}

//全部车站数据
-(NSMutableArray *)stationList
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.fetchedResultsController fetchedObjects]];
    return arr;
}

-(UITableView *)searchTableView
{
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT) style:UITableViewStylePlain];
        _searchTableView.dataSource = self;
        _searchTableView.delegate = self;
    }
    return _searchTableView;
}

-(void)dispose
{
    _searchTableView.delegate = nil;
    _searchTableView.dataSource = nil;
    [_searchTableView removeFromSuperview];
    _searchTableView = nil;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.searchTableView ]) {
        [((UISearchController *)[self.viewController valueForKey:@"searchController"]).searchBar resignFirstResponder];
    }
}


@end
