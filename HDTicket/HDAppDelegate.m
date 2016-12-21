//
//  AppDelegate.m
//  HDTicket
//
//  Created by 周志荣 on 16/12/9.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "HDAppDelegate.h"
#import "HDRootViewController.h"
#import "TicketViewController.h"
#import "OrderViewController.h"
#import "PersonalViewController.h"
#import "Station+CoreDataProperties.h"






@interface HDAppDelegate ()

@property (nonatomic,strong) HDRootViewController * root;

@end
@implementation HDAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSSetUncaughtExceptionHandler(&caughtException);
    [self setupViewControllers];
    
    self.window.rootViewController = _root;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"isListExist"]) {
        [self stationList];
    }
    // Override point for customization after application launch.
    [defaults setBool:YES forKey:@"isListExist"];
    
    return YES;
}

#pragma mark 获取站点数据并存储
-(void)stationList
{
    [self.defaultNetHandle activateWithURL:[NSURL URLWithString:STATIONS] headers:nil params:nil method:Get success:^(NSURLSessionDataTask *task, NSDictionary *dic) {
        // 运用coreData存储站点数据
        NSArray *array = dic[@"result"];
        NSManagedObjectContext *tempCtx = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        tempCtx.parentContext.parentContext = self.localManager.managedObjectContext;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Station *station = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:self.localManager.managedObjectContext];
            station.name = ((NSDictionary *)obj)[@"sta_name"];
            station.firstLetter = [station firstLetterOfName:station.name];
            station.combineLetter = [station combineLetterOfName:station.name];
        }];
        
        [tempCtx performBlock:^{
//
            if ([tempCtx hasChanges]) {
                if (![tempCtx save:nil]) {
                    
                }
            }
           [self.localManager.managedObjectContext performBlock:^{
//
               if ([self.localManager.managedObjectContext hasChanges]) {
                   if (![self.localManager.managedObjectContext save:nil]) {
                       
                   }
               }
               [self.localManager.rootObjectContext performBlock:^{

                   if (![self.localManager.rootObjectContext save:nil]) {
                       
                   }
               }];
           }];
        }];
    
//        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", jsonString);
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"请求站点数据失败!");
        
    }];
}

-(HDLocalDataManager *)localManager
{
    if (!_localManager) {
        _localManager = [[HDLocalDataManager alloc]init];
    }
    return _localManager;
}

-(NetworkHandle *)defaultNetHandle
{
    if (!_defaultNetHandle) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _defaultNetHandle = [[NetworkHandle alloc]initWithConfiguration:config];
    }
    return _defaultNetHandle;
}

-(NetworkHandle *)ephemeralNetHandle
{
    if (!_ephemeralNetHandle) {
        _ephemeralNetHandle = [[NetworkHandle alloc]initWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    }
    return _ephemeralNetHandle;
}



void caughtException(NSException *exception)
{
    NSArray *callStack = [exception callStackSymbols];
    NSString *name = exception.name;
    NSString *reason = exception.reason;
    NSString *fullContent = [NSString stringWithFormat:@"name:%@,reason:%@,callStack:%@",name,reason,callStack];
    NSLog(@"%@", fullContent);
}
-(void)setupViewControllers
{
    // 火车票
    TicketViewController *ticketVC = [[TicketViewController alloc]init];
    UINavigationController *ticketNav = [[UINavigationController alloc]initWithRootViewController:ticketVC];
    
    //订单
    OrderViewController *orderVC = [[OrderViewController alloc]init];
    UINavigationController *orderNav = [[UINavigationController alloc]initWithRootViewController:orderVC];
    
    //个人中心
    PersonalViewController *personalVC = [[PersonalViewController alloc]init];
    UINavigationController *personalNav = [[UINavigationController alloc]initWithRootViewController:personalVC];
    
    _root = [[HDRootViewController alloc]init];
    _root.viewControllers = @[ticketNav,orderNav,personalNav];
    
    [self customizeTabBarForController:_root];
}

- (void)customizeTabBarForController:(UITabBarController *)tabBarController
{
    NSArray *titles = @[@"ticket",@"order",@"personal"];
    NSArray *contentTitles = @[@"火车票",@"订单",@"个人中心"];
    for (int index = 0; index < tabBarController.tabBar.items.count; index++) {
        UITabBarItem *item = tabBarController.tabBar.items[index];
        //让图片显示原始模式 
        [item setImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",titles[index]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setSelectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",titles[index]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setTitle:contentTitles[index]];
    }
}

- (UIViewController*) topViewController {
    UIViewController * topViewCtrl = self.window.rootViewController;
    while (topViewCtrl.presentedViewController)
    {
        topViewCtrl = topViewCtrl.presentedViewController;
    }
    while ([topViewCtrl isKindOfClass:[UINavigationController class]] || [topViewCtrl isKindOfClass:[UITabBarController class]])
    {
        while ([topViewCtrl isKindOfClass:[UINavigationController class]])
        {
            UINavigationController* nav = (UINavigationController*) topViewCtrl;
            topViewCtrl = nav.topViewController;
        }
        while ([topViewCtrl isKindOfClass:[UITabBarController class]])
        {
            UITabBarController* tab = (UITabBarController*) topViewCtrl;
            topViewCtrl = [tab selectedViewController];
        }
    }
    return topViewCtrl;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
