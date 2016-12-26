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
    
    [self UIsetup];
}

-(void)UIsetup
{
    self.title = @"请选择日期";
    HDCalendarPicker *calendarPicker = [HDCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];          //当天
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, 100, self.view.frame.size.width, 350);
}
@end
