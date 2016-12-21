//
//  HDLocalManager.h
//  HDTicket
//
//  Created by 周志荣 on 2016/12/18.
//  Copyright © 2016年 周志荣. All rights reserved.
//
/*
 采用三层设计 bgContext-----mainContext-----rootContext
 */
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface HDLocalDataManager : NSObject


@property (nonatomic,readonly,copy)NSString *userDataPath;

- (NSManagedObjectContext*) managedObjectContext;    //主线程MOC
- (NSManagedObjectContext*) rootObjectContext;       //后台线程MOC
//- (NSManagedObjectModel *)  managedObjectModel;       //model都是同一个model
- (NSManagedObjectContext*) memoryObjectContext;     //同样在主线程操作 只进行内存存储
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;   //只有一个PSC

@end
