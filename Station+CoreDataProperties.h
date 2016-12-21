//
//  Station+CoreDataProperties.h
//  HDTicket
//
//  Created by 周志荣 on 2016/12/19.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "Station+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Station (CoreDataProperties)

+ (NSFetchRequest<Station *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *firstLetter;
@property (nullable, nonatomic, copy) NSString *combineLetter;

- (NSString *) combineLetterOfName:(NSString *) chinese;

- (NSString*) firstLetterOfName:(NSString*) fname ;

- (NSString *)pinyin:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
