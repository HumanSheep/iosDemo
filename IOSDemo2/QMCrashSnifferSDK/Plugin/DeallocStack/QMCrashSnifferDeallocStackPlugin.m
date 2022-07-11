//
//  QMCrashSnifferDeallocStackPlugin.m
//  QQMusic
//
//  Created by xpyue on 2021/12/28.
//

#include <execinfo.h>
#import <UIKit/UIKit.h>
#import "QMCrashSnifferDeallocStackPlugin.h"
#import "QMCrashSnifferHookDeallocCapabilities.h"
#import "QMCrashSnifferUtility.h"

static const char *kSpecialObject_cstring; // 需要特殊监控的对象，特殊监控的对象会上报堆栈
static uint8_t kMaxStackDepth; // 记录堆栈的最大深度

// 因为有C的回调，需要拿到self
static QMCrashSnifferDeallocStackPlugin *kCurrentPlugin;

@interface QMCrashSnifferDeallocStackPlugin ()

@property (nonatomic, assign, getter=isRuning) BOOL runing;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<NSMutableData *> *> *objectStackDic; // 存储堆栈信息
@property (nonatomic, strong) dispatch_queue_t storageQueue; // 存储数据用的队列（串行队列
@property (nonatomic, assign) uint32_t curStackCount; // 记录堆栈的数量
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation QMCrashSnifferDeallocStackPlugin

@dynamic pluginConfig;

#pragma mark - Supper
- (QMCrashSnifferPluginType)getPluginType
{
    return QMCrashSnifferPluginType_DeallocStack;
}

- (QMCrashSnifferPluginBasicCapabilities)getDependency
{
    return QMCrashSnifferPluginBasicCapabilitiesType_HookDealloc;
}

- (BOOL)start
{
    if (   [self isRuning] == NO
        && [self qualifyPluginConfig]
        && [QMCrashSnifferUtility qualifyPercent:self.pluginConfig.percent])
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if ([super start])
            {
                self.semaphore = dispatch_semaphore_create(1);
                self.storageQueue = dispatch_queue_create("com.tencent.QQMusic.QMCrashSniffer.StorageQueue", DISPATCH_QUEUE_SERIAL);
                self.objectStackDic = [NSMutableDictionary dictionaryWithCapacity:10];
                self.runing = YES;
                qmcs_addCallBack((uintptr_t)self, crashSnifferHandleDeallocCallBack);
                kCurrentPlugin = self;
                kSpecialObject_cstring = [self.pluginConfig.specialObject
                                          cStringUsingEncoding:NSASCIIStringEncoding];
                kMaxStackDepth = self.pluginConfig.maxStackDepth;
                [NSNotificationCenter.defaultCenter addObserver:self
                                                       selector:@selector(onApplicationDidReceiveMemoryWarningNotification:)
                                                           name:UIApplicationDidReceiveMemoryWarningNotification
                                                         object:nil];
            }
        });
    }
    return [self isRuning];
}

- (void)stop
{
    if ([self isRuning])
    {
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        self.objectStackDic = nil;
        dispatch_semaphore_signal(self.semaphore);
        [super stop];
        qmcs_removeCallBack((uintptr_t)self);
        self.runing = NO;
    }
}

- (BOOL)runingState
{
    return [self isRuning];
}

#pragma mark - Public

- (void)fetchStackSymbolWithAddress:(uintptr_t)objPtr
                         completion:(QMCrashSnifferFetchStackSymbolBlock)completion
{
    if ([self isRuning])
    {
        dispatch_async(self.storageQueue, ^{
            NSString *key = translateKeyOfObjectStackDic(objPtr);
            NSMutableArray<NSArray<NSString *> *> *callStacks = [NSMutableArray arrayWithCapacity:3];
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
            if ([self.objectStackDic valueForKey:key])
            {
                [self.objectStackDic[key] enumerateObjectsUsingBlock:^(NSMutableData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [callStacks addObject:[self symbolsStackInfoWithBytes:obj]];
                }];
            }
            dispatch_semaphore_signal(self.semaphore);
            if (completion)
            {
                completion(objPtr, [callStacks copy]);
            }
        });
    }
}

- (NSArray<NSArray<NSString *> *> *)getStackSymbolWithAddress:(uintptr_t)objPtr
{
    if ([self isRuning] == NO)
    {
        return @[];
    }
    NSString *key = translateKeyOfObjectStackDic(objPtr);
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    NSMutableArray<NSMutableData *> *bytesOfStatcks = self.objectStackDic[key];
    NSMutableArray<NSArray<NSString *> *> *callStacks = [NSMutableArray arrayWithCapacity:bytesOfStatcks.count];
    [bytesOfStatcks enumerateObjectsUsingBlock:^(NSMutableData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [callStacks addObject:[self symbolsStackInfoWithBytes:obj]];
    }];
    dispatch_semaphore_signal(self.semaphore);
    
    return [callStacks copy];
}
#pragma mark - Notification

- (void)onApplicationDidReceiveMemoryWarningNotification:(NSNotification *)notification
{
    if (kCurrentPlugin.pluginConfig.aotoStop)
    {
        dispatch_async(kCurrentPlugin.storageQueue, ^{
            [self stop];
        });
    }
}

#pragma mark - KSCrashMonitor_Zombie Delegate

static void crashSnifferHandleDeallocCallBack(uintptr_t objPtr, const char *className)
{
    if (className == NULL || kSpecialObject_cstring == NULL)
    {
        return;
    }
    if (strcmp(className, kSpecialObject_cstring) == 0)
    {
        void *callAddr[QMCrashSniffer_STACK_DEPTH_SIZE] = {};
        __block NSString *key = translateKeyOfObjectStackDic(objPtr);
        __block uint8_t stackDepth = backtrace(callAddr, kMaxStackDepth);
        __block NSData *callAddrData = [NSData dataWithBytes:callAddr length:stackDepth * sizeof(void*)];
        dispatch_async(kCurrentPlugin.storageQueue, ^{
            if (kCurrentPlugin.curStackCount > kCurrentPlugin.pluginConfig.maxStorageStackNumber)
            {
                // 超过次数，自动释放
                if (kCurrentPlugin.pluginConfig.aotoStop)
                {
                    [kCurrentPlugin stop];
                }
            }
            // 把堆栈深度+堆栈地址的数据转为data
            NSMutableData *bytesOfCallAddr = [NSMutableData dataWithCapacity:sizeof(stackDepth) + stackDepth * sizeof(void*)];
            [bytesOfCallAddr appendBytes:&stackDepth length:sizeof(stackDepth)];
            [bytesOfCallAddr appendData:callAddrData];
            dispatch_semaphore_wait(kCurrentPlugin.semaphore, DISPATCH_TIME_FOREVER);
            if ([kCurrentPlugin.objectStackDic valueForKey:key] == nil)
            {
                kCurrentPlugin.objectStackDic[key] = [NSMutableArray arrayWithCapacity:1];
            }
            [kCurrentPlugin.objectStackDic[key] addObject:bytesOfCallAddr];
            dispatch_semaphore_signal(kCurrentPlugin.semaphore);
            ++ kCurrentPlugin.curStackCount;
        });
        
    }
}

#pragma mark - Private

static NSString *translateKeyOfObjectStackDic(uintptr_t objPtr)
{
    return [NSString stringWithFormat:@"%lu", objPtr];
}


- (NSArray<NSString *> *)symbolsStackInfoWithBytes:(NSMutableData *)bytes
{
    NSArray<NSString *> *result = @[];
    do
    {
        uint8_t stackDepth = 0;
        if (bytes.length <= sizeof(stackDepth))
        {
            break;
        }
        // 读取深度
        [bytes getBytes:&stackDepth length:sizeof(stackDepth)];
        if (bytes.length < stackDepth * sizeof(void *) + sizeof(stackDepth))
        {
            // 越界保护
            break;
        }
        // 读取堆栈地址
        void *callAddr[QMCrashSniffer_STACK_DEPTH_SIZE] = {};
        [bytes getBytes:callAddr range:NSMakeRange(sizeof(stackDepth), stackDepth * sizeof(void*))];
        
        char **symbols = backtrace_symbols(callAddr, stackDepth);
        if (symbols == NULL)
        {
            break;
        }
        NSMutableArray<NSString *> *callStackArr = [NSMutableArray arrayWithCapacity:stackDepth];
        for (int i = 0; i < stackDepth; i++)
        {
            NSString *str = [NSString stringWithFormat:@"%s", symbols[i]];
            [callStackArr addObject:str];
        }
        free(symbols);
        result = [callStackArr copy];
    } while(0);
    return result;
}

// 校验参数
- (BOOL)qualifyPluginConfig
{
    if (   self.pluginConfig.maxStackDepth == 0
        || self.pluginConfig.maxStorageStackNumber == 0
        || NSClassFromString(self.pluginConfig.specialObject) == nil)
    {
        return NO;
    }
    return YES;
}
@end
