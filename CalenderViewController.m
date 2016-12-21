//
//  DatePickerViewController.m
//  HDTicket
//
//  Created by 周志荣 on 16/12/13.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "CalenderViewController.h"
#import "HDCalendarPicker.h"
@interface CalenderViewController ()



@end
@implementation CalenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UIsetup];
}

-(void)UIsetup
{
    self.title = @"请选择日期";
    HDCalendarPicker *calendarPicker = [HDCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, 100, self.view.frame.size.width, 352);
    
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

@end
