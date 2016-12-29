//
//  HDHeaderFile.m
//  HDTicket
//
//  Created by 周志荣 on 2016/12/26.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "HDHeaderFile.h"

@implementation HDHeaderFile

+(instancetype)sharedHeaderFile
{
    static HDHeaderFile *instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HDHeaderFile alloc]init];
    });
    return instance;
}
//"2017-01-01" 与 2017年1月1号  形式互转
NSString * transfer(NSString *original)
{
    NSString *processed = nil;
    if ([original containsString:@"-"]) {
        NSArray *arr = [original componentsSeparatedByString:@"-"];
        NSString *month = nil;
        NSString *day = nil;
        if ([arr[1] hasPrefix:@"0"]) {
            month = [arr[1] substringFromIndex:1];
        }
        else{
            month = arr[1];
        }
        if ([arr[2] hasPrefix:@"0"]) {
            day = [arr[2] substringFromIndex:1];
        }else{
            day = arr[2];
        }
        processed = [arr[0] stringByAppendingString:[NSString stringWithFormat:@"年%@月",month]];
        processed = [processed stringByAppendingString:[NSString stringWithFormat:@"%@日",day]];
    }else if ([original containsString:@"年"]){
        
        processed = [original stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
        processed = [processed stringByReplacingOccurrencesOfString:@"日" withString:@""];
        NSArray *arr = [processed componentsSeparatedByString:@"月"];
        NSString *yearAndMonth = nil;
        NSString *day = nil;
        if (((NSString *)arr[0]).length == 6) {
            yearAndMonth = [((NSString *)arr[0]) stringByReplacingOccurrencesOfString:@"-" withString:@"-0"];
        }else{
            yearAndMonth = (NSString *)arr[0];
        }
        if (((NSString *)arr[1]).length == 1) {
            day = [@"0" stringByAppendingString:((NSString *)arr[1])];
        }else{
            day = (NSString *)arr[1];
        }
        processed = [yearAndMonth stringByAppendingString:[NSString stringWithFormat:@"-%@",day]];
    }
    return processed;
}

#pragma mark  //判断 2016年12月30日  这样的格式 是不是 今天 明天

BOOL isToday(NSString *dateString)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSDate *tranDate = [formatter dateFromString:transfer(dateString)];
    NSDate *today = [NSDate date];
    NSDateComponents *tranComp = [[NSCalendar currentCalendar]components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:tranDate];
    NSDateComponents *todayComp = [[NSCalendar currentCalendar]components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:today];
    
    return tranComp.year==todayComp.year && tranComp.month==todayComp.month && tranComp.day == todayComp.day;
}



BOOL isTommorow(NSString *dateString)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *tranDate = [formatter dateFromString:transfer(dateString)];
    NSDate *today = [NSDate date];
    NSDateComponents *component = [[NSDateComponents alloc]init];
    component.day = +1;
    NSDate *tommorow = [[NSCalendar currentCalendar]dateByAddingComponents:component toDate:today options:0];
    
    NSDateComponents *tranComp = [[NSCalendar currentCalendar]components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:tranDate];
    NSDateComponents *tommorowComp = [[NSCalendar currentCalendar]components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:tommorow];
    return tranComp.year==tommorowComp.year && tranComp.month==tommorowComp.month && tranComp.day == tommorowComp.day;
}

//"2016-12-30"
NSString * previousDay(NSString *dateString)
{
    if ([dateString containsString:@"年"]) {
        dateString = transfer(dateString);
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:dateString];
    NSDateComponents *component = [[NSDateComponents alloc]init];
    component.day = -1;
    NSDate *previousDay = [[NSCalendar currentCalendar]dateByAddingComponents:component toDate:date options:0];
    NSDateComponents *previousComp = [[NSCalendar currentCalendar]components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:previousDay];
    return [NSString stringWithFormat:@"%ld年%ld月%ld日",previousComp.year,previousComp.month,previousComp.day];
}

NSString * nextDay(NSString *dateString)
{
    if ([dateString containsString:@"年"]) {
        dateString = transfer(dateString);
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:dateString];
    NSDateComponents *component = [[NSDateComponents alloc]init];
    component.day = +1;
    NSDate *nextDay = [[NSCalendar currentCalendar]dateByAddingComponents:component toDate:date options:0];
    NSDateComponents *tommorowComp = [[NSCalendar currentCalendar]components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:nextDay];
    return [NSString stringWithFormat:@"%ld年%ld月%ld日",tommorowComp.year,tommorowComp.month,tommorowComp.day];
}

BOOL check(NSString *dateString,NSString *timeString)
{
    if ([dateString containsString:@"年"]) {
        dateString = transfer(dateString);
    }
    //得到火车的出发时间字符串
    NSString *compare = [[dateString stringByAppendingString:[NSString stringWithFormat:@" %@",timeString]] stringByAppendingString:@":00"];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 要确定的时间
    NSDate *date = [format dateFromString:compare];
    // 此时此刻
    NSDate *now = [NSDate date];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger delta = [timeZone secondsFromGMT];
    NSInteger secondCount = [date timeIntervalSince1970] - [now timeIntervalSince1970];
    return secondCount > 1800+delta ? YES : NO;
}

@end
