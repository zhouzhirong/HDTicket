//
//  Station+CoreDataProperties.m
//  HDTicket
//
//  Created by 周志荣 on 2016/12/19.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "Station+CoreDataProperties.h"

@implementation Station (CoreDataProperties)

+ (NSFetchRequest<Station *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Station"];
}

@dynamic name;
@dynamic firstLetter;
@dynamic combineLetter;

- (NSString*) firstLetterOfName:(NSString*) fname {
    CFRange range = CFRangeMake(0, 1);
    NSMutableString* mutableString = [fname mutableCopy];
    BOOL bSuccess = CFStringTransform((__bridge CFMutableStringRef)mutableString, &range, kCFStringTransformToLatin, NO);
    if (bSuccess) {
        bSuccess = CFStringTransform((__bridge CFMutableStringRef)mutableString, &range, kCFStringTransformStripCombiningMarks, NO);
        
    }
    NSString* firstLetter = nil;
    if (bSuccess && range.length > 0) {
        NSRange nsRange = NSMakeRange(range.location, 1);
        firstLetter = [[mutableString substringWithRange:nsRange] uppercaseString];
    }
    if (firstLetter && ([firstLetter compare:@"A"] < 0 || [firstLetter compare:@"Z"] > 0)) {
        firstLetter = nil;
    }
    return firstLetter ? firstLetter : @"#";
}

-(NSString *)combineLetterOfName:(NSString *)chinese
{
    NSParameterAssert(chinese);
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [chinese mutableCopy];
    
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);

    __block NSString *f = @"";
    NSArray *arr = [pinyin componentsSeparatedByString:@" "];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *first = [[obj substringToIndex:1]capitalizedString];
        f = [f stringByAppendingString:first];
    }];
    return f;
}

@end
