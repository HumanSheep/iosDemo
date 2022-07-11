//
//  main.m
//  IOSDemo2
//
//  Created by xpyue on 2021/3/25.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int inter_var = 3;

extern int extern_var;

extern void extern_hello(void);
void inter_hello(void)
{
    
}

int main(int argc, char * argv[]) {

    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
//

// 0x00025fb8
