//
//  HDTicketInfoTableViewController.m
//  HDTicket
//
//  Created by 周志荣 on 2016/12/22.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "HDTicketInfoTableViewController.h"
#import "MBProgressHUD.h"
#import "HDTrainInfoCell.h"
#import "HDTrainInfoModel.h"
#import "HDBottomBanner.h"
#import "MJRefresh.h"

@interface HDTicketInfoTableViewController ()

@property (nonatomic , strong)UIView *footer;
@property (nonatomic , strong)HDBottomBanner *bottomBanner;

@end
@implementation HDTicketInfoTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
        HUD.darkBlur = YES;
        HUD.labelText = @"获取车次列表";
        //显示对话框
        [self.view addSubview:HUD];
        [HUD show:YES];
        _filteredSource = [[NSMutableArray alloc]init];
        _dataSource = [[NSMutableArray alloc]init];
        [self.tableView registerNib:[UINib nibWithNibName:@"HDTrainInfoCell" bundle:nil] forCellReuseIdentifier:@"HDTrainInfoCell"];
    }
    return self;
}

-(UILabel *)errorLabel
{
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, WIDTH, 30)];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.text = @"抱歉！没有查询到相关车次";
    }
    return _errorLabel;
}


-(void)viewDidAppear:(BOOL)animated
{
    [_bottomBanner setFrame:CGRectMake(0, HEIGHT-42, WIDTH, 42)];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_filteredSource removeAllObjects];
    [_bottomBanner setFrame:CGRectMake(0, HEIGHT, WIDTH, 42)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithImage:[IMAGE(@"share") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareToWechat)];
     self.navigationItem.rightBarButtonItem = share;
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(HDrefresh)];
}

//
-(void)HDrefresh
{
    NSLog(@"");
}
//微信分享
-(void)shareToWechat
{
    
}

-(UIView *)footer
{
    if (!_footer) {
        _footer = [[UIView alloc]initWithFrame:CGRectMake(0, 100, WIDTH, 40)];
        _footer.backgroundColor = [UIColor clearColor];
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, WIDTH-80, 34)];
        tipLabel.text = @"没票不用怕,抢票成功率高达80%";
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.textColor = RGB(25, 25, 25);
        tipLabel.font = [UIFont systemFontOfSize:15];
        UIButton *shootBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shootBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [shootBtn setTintColor:[UIColor whiteColor]];
        [shootBtn setTitle:@"抢票" forState:UIControlStateNormal];
        shootBtn.backgroundColor = RGB(10, 105, 255);
        [shootBtn setFrame:CGRectMake(WIDTH-65, 3, 45, 30)];
        [shootBtn.layer setCornerRadius:8];
        [shootBtn.layer setMasksToBounds:YES];
        [_footer addSubview:shootBtn];
        [_footer addSubview:tipLabel];
    }
    return _footer;
}

-(HDBottomBanner *)bottomBanner
{
    if (!_bottomBanner)
    {
        _bottomBanner = [[NSBundle mainBundle]loadNibNamed:@"HDBottomBanner" owner:self options:nil].firstObject;
        [_bottomBanner setFrame:CGRectMake(0, HEIGHT-42, WIDTH, 42)];
        _bottomBanner.userInteractionEnabled = NO;
        [[UIApplication sharedApplication].keyWindow addSubview:_bottomBanner];
    }
    return _bottomBanner;
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.filteredSource.count>0) {
        return _filteredSource.count;
    }
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HDTrainInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDTrainInfoCell"];
    HDTrainInfoModel *model = _filteredSource.count>0 ? _filteredSource[indexPath.row] : self.dataSource[indexPath.row];
    cell.trainInfoModel = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



float lastContentOffset;

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastContentOffset = scrollView.contentOffset.y;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (lastContentOffset > scrollView.contentOffset.y) {
        self.bottomBanner.dateString = self.dateStringToprocess;
        [UIView animateWithDuration:0.25 animations:^{

            [_bottomBanner setFrame:CGRectMake(0, HEIGHT-42, WIDTH, 42)];
        }];
        
    }else{
        self.bottomBanner.dateString = self.dateStringToprocess;
        [UIView animateWithDuration:0.25 animations:^{

            [_bottomBanner setFrame:CGRectMake(0, HEIGHT, WIDTH, 42)];
        }];
    }
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (lastContentOffset > scrollView.contentOffset.y) {
        self.bottomBanner.dateString = self.dateStringToprocess;
        [UIView animateWithDuration:0.25 animations:^{
            
            [_bottomBanner setFrame:CGRectMake(0, HEIGHT-42, WIDTH, 42)];
        }];
        
    }else{
        self.bottomBanner.dateString = self.dateStringToprocess;
        [UIView animateWithDuration:0.25 animations:^{
            
            [_bottomBanner setFrame:CGRectMake(0, HEIGHT, WIDTH, 42)];
        }];
    }
    if (!self.tableView.tableFooterView) {
        self.tableView.tableFooterView = self.footer;
    }
}



@end
