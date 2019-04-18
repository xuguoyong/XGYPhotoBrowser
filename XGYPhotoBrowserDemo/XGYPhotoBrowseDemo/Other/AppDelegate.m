//
//  AppDelegate.m
//  XGYPhotoBrowse
//
//  Created by guoyong xu on 2019/4/12.
//  Copyright © 2019年 guoyong xu. All rights reserved.
//

#import "AppDelegate.h"
#import "XGYTabbarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //创建根视图控制器
    XGYTabbarController *tabbar = [[XGYTabbarController alloc] init];
    self.window.rootViewController = tabbar;

    return YES;
}

@end
