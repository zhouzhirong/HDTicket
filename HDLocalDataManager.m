//
//  HDLocalManager.m
//  HDTicket
//
//  Created by 周志荣 on 2016/12/18.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "HDLocalDataManager.h"
@interface HDLocalDataManager()

@property(nonatomic, strong) NSManagedObjectModel * managedObjectModel;
@property(nonatomic, strong) NSPersistentStoreCoordinator * persistentStoreCoordinator;
@property(nonatomic, strong) NSManagedObjectContext * managedObjectContext;
@property(nonatomic, strong) NSManagedObjectContext * rootObjectContext;

@end
@implementation HDLocalDataManager

- (instancetype)init
{
    if (self = [super init]) {
        NSError* error = nil;
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSURL* docURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        if (docURL) {
            
            NSURL* downloadsURL = [docURL URLByAppendingPathComponent:@"station"] ;
            BOOL isDir;
            if (![fileManager fileExistsAtPath:downloadsURL.path isDirectory:&isDir]) {
                [fileManager createDirectoryAtURL:downloadsURL withIntermediateDirectories:YES attributes:nil error:&error];
            }
            _userDataPath = downloadsURL.path;
        }
    }
    return self;
}

//主线程的Ctx   负责UI交互
-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.parentContext = [self rootObjectContext];
    
    return _managedObjectContext;
}


- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *docUrl = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
    NSURL* userDataHome = [docUrl URLByAppendingPathComponent:@"station"];
    if ([fileManager fileExistsAtPath:userDataHome.path]) {
        if (![fileManager createDirectoryAtURL:userDataHome withIntermediateDirectories:YES attributes:nil error:&error]) {
            return nil;
        }
    }
    NSURL *storeURL = [userDataHome URLByAppendingPathComponent:@"station.sqlite"];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
    //handle DB upgrade
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption, nil];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        abort();
    }
    return _persistentStoreCoordinator;
}

-(NSManagedObjectContext *)rootObjectContext
{
    if (_rootObjectContext) {
        return _rootObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        _rootObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_rootObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _rootObjectContext;
}


-(NSManagedObjectContext *)memoryObjectContext
{
    NSManagedObjectContext *memoryContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    [memoryContext setPersistentStoreCoordinator:[self momeoryPersistentStoreCoordinator]];
    return memoryContext;
}

-(NSPersistentStoreCoordinator *)momeoryPersistentStoreCoordinator
{
    NSPersistentStoreCoordinator *memoryPSC = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
    [memoryPSC addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    return memoryPSC;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
#if 0
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"station" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
#else
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
#endif
    return _managedObjectModel;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *moc = self.rootObjectContext;
    if (moc != nil) {
        NSError *error = nil;
        if ([moc hasChanges] && ![moc save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

/**
 
 */
- (NSNumber*) getCacheSize {
    NSString* downloadPath = self.userDataPath;
    return [NSNumber numberWithUnsignedLongLong:[self getFolderSize:downloadPath]];
}

- (uint64_t) getFolderSize:(NSString*) path {
    uint64_t size = 0;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if(path == nil) {
        return size;
    }
    NSArray* subItems = [fileManager subpathsOfDirectoryAtPath:path error:nil];
    for (NSString* item in subItems) {
        NSString* filePath = [NSString stringWithFormat:@"%@/%@", path, item];
        NSDictionary* attr = [fileManager attributesOfItemAtPath:filePath error:nil];
        if ([[attr objectForKey:NSFileType] isEqualToString:NSFileTypeRegular]) {
            size += [[attr objectForKey:NSFileSize] unsignedLongLongValue];
        }
    }
    return size;
}

/**
 获取剩余的内存存储空间
 */
-(uint64_t) getFreeDiskspace {
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    return totalFreeSpace;
}

@end






