//
//  AppDelegate.h
//  HDTicket
//
//  Created by 周志荣 on 16/12/9.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDLocalDataManager.h"
#import "NetworkHandle.h"
@interface HDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HDLocalDataManager *localManager;
@property (nonatomic,strong) NetworkHandle *defaultNetHandle;
@property (nonatomic,strong) NetworkHandle *ephemeralNetHandle;
//@property (nonatomic,strong) NetworkHandle *backgroundNetHandle;

- (UIViewController *) topViewController;//获取当前显示的那个controller

@end

