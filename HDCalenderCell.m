//
//  SZCalenderCell.m
//  SZCalendarPicker
//
//  Created by 周志荣 on 16/12/13.
//  Copyright © 2016年 Stephen Zhuang. All rights reserved.
//

#import "HDCalenderCell.h"

@implementation HDCalendarCell

/**
 label就是cell的全部
 */
- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:17]];
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}
@end
