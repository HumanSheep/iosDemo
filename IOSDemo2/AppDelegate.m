//
//  AppDelegate.m
//  IOSDemo2
//
//  Created by xpyue on 2021/3/25.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "QMCrashSnifferSDKWrapper.h"
#import "HitTestViewController.h"
#import "ViewController.h"
#import "WebVC.h"

@interface AppDelegate ()
{
    
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    ViewController *vc = [[ViewController alloc] init];
//    HitTestViewController *vc = [[HitTestViewController alloc] init];
    WebVC *vc = [[WebVC alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:vc];

    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_window setRootViewController:_navigationController];
    [_window setBackgroundColor:[UIColor whiteColor]];
    [_window makeKeyAndVisible];
//    [QMCrashSnifferSDKWrapper.shared setup];
    return YES;
}



@end

int extern_var = 11;

void extern_hello(void)
{
    printf("ddd");
}
