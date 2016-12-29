//
//  HDHeaderFile.h
//  HDTicket
//
//  Created by 周志荣 on 2016/12/26.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDHeaderFile : NSObject

+(instancetype)sharedHeaderFile;

BOOL isTommorow(NSString *dateString);

BOOL isToday(NSString *dateString);

NSString * transfer(NSString *original);

//"2016-12-30" 一定要是有包含年份的
NSString * previousDay(NSString *dateString);

NSString * nextDay(NSString *dateString);

BOOL check(NSString *dateString,NSString *timeString);

























@end
