//
//  QMCrashSnifferSDKTest.m
//  QQMusicTests
//
//  Created by xpyue on 2021/12/28.
//

#import <XCTest/XCTest.h>
#import "QMCrashSnifferSDK.h"
#import "QMCrashSnifferZombiePlugin.h"
#import "QMCrashSnifferDeallocStackPlugin.h"
#import "QMCrashSnifferHookDeallocCapabilities.h"

static QMCrashSnifferZombiePlugin *kZombiePlugin;
static QMCrashSnifferDeallocStackPlugin *kDeallocStackPlugin;

@interface QMCrashSnifferSDKTest : XCTestCase

@end

@implementation QMCrashSnifferSDKTest

- (void)setUp
{
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    QMCrashSnifferZombiePluginConfig *zombieConfig = [[QMCrashSnifferZombiePluginConfig alloc] init];
    zombieConfig.percent = 1.0;
    QMCrashSnifferZombiePlugin *zombiePlugin = [[QMCrashSnifferZombiePlugin alloc] init];
    zombiePlugin.pluginConfig = zombieConfig;
    [QMCrashSnifferSDK.sharedInstance addPlugin:zombiePlugin];
    
    QMCrashSnifferDeallocStackPluginConfig *deallocStackConfig = [[QMCrashSnifferDeallocStackPluginConfig alloc] init];
    deallocStackConfig.percent = 1.0;
    deallocStackConfig.specialObject = NSStringFromClass(QMCrashSnifferBasePluginConfig.class);
    QMCrashSnifferDeallocStackPlugin *deallocStackPlugin = [[QMCrashSnifferDeallocStackPlugin alloc] init];
    deallocStackPlugin.pluginConfig = deallocStackConfig;
    [QMCrashSnifferSDK.sharedInstance addPlugin:deallocStackPlugin];
    
    [QMCrashSnifferSDK.sharedInstance startPlugins];
    kZombiePlugin = zombiePlugin;
    kDeallocStackPlugin = deallocStackPlugin;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample
{
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


- (void)testGetObjectNameWith
{
    // 释放一些对象
    NSMutableArray<NSNumber *> *releasedPtrArr = [@[] mutableCopy];
    @autoreleasepool {
        QMCrashSnifferBasePluginConfig *config1 = [[QMCrashSnifferBasePluginConfig alloc] init];
        uintptr_t ptr = (uintptr_t)config1;
        [releasedPtrArr addObject:@(ptr)];
        QMCrashSnifferBasePluginConfig *config2 = [[QMCrashSnifferBasePluginConfig alloc] init];
        ptr = (uintptr_t)config2;
        [releasedPtrArr addObject:@(ptr)];
        QMCrashSnifferBasePluginConfig *config3 = [[QMCrashSnifferBasePluginConfig alloc] init];
        ptr = (uintptr_t)config3;
        [releasedPtrArr addObject:@(ptr)];
    }
    // 获取信息
    [releasedPtrArr enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        uintptr_t ptr = obj.longLongValue;
        NSArray * arr = [kZombiePlugin getObjectNameWith:ptr];
        XCTAssert([[arr componentsJoinedByString:@","] containsString:NSStringFromClass(QMCrashSnifferBasePluginConfig.class)]);
    }];
}

- (void)testMemoryWarning
{
    // 测试内存告警
    XCTestExpectation* expectation = [self expectationWithDescription:@"delay"];
    
    dispatch_queue_t queue = dispatch_queue_create("group.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_block_t block = dispatch_block_create(0, ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [NSThread sleepForTimeInterval:1.0];
        [expectation fulfill];
    });
    dispatch_async(queue, block);
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError * _Nullable error) {
        XCTAssert([QMCrashSnifferSDK.sharedInstance
                   isRuningWithPluginType:QMCrashSnifferPluginType_DeallocStack] == 0);
    }];
    
}


- (void)testFetchStackSymbolWith
{
    // 测试主动拿堆栈
    
    intptr_t ptr = 0;
    {
        QMCrashSnifferBasePluginConfig *objk = [[QMCrashSnifferBasePluginConfig alloc] init];
        ptr = (intptr_t)objk;
    }
    [NSThread sleepForTimeInterval:1];
    NSArray<NSArray<NSString *> *> *arr = [kDeallocStackPlugin getStackSymbolWithAddress:ptr];
    XCTAssert(arr.count != 0);
}


@end
