//
//  SZCalendarPicker.h
//  SZCalendarPicker
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicketViewController.h"


@interface HDCalendarPicker : UIView<UICollectionViewDelegate , UICollectionViewDataSource>

@property (nonatomic , strong) NSDate *date;
@property (nonatomic , strong) NSDate *today;
@property (nonatomic , weak) id<updateTableViewDelegate> delegate;


+ (instancetype)showOnView:(UIView *)view;


@end
