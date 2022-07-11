//
//  QMCrashSnifferSDKWrapper.m
//  QQMusic
//
//  Created by xpyue on 2021/12/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "QMCrashSnifferSDKWrapper.h"
#import "QMCrashSnifferSDK.h"
#import "QMCrashSnifferZombiePlugin.h"
#import "QMCrashSnifferDeallocStackPlugin.h"

// 分隔符，方便拆分字符串
static NSString * const kSplitCharacter = @"+";
// 正则匹配到的x0长度
static uint8_t const kRangeMinX0Length = 6;
// 正则匹配到的x0偏移长度，crashLog.length - range.location > 4
static uint8_t const kRangeMinX0Offset = 4;
// crashLog中的异常类型，预估个长度
static uint8_t const kCrashExceptionTypeLength = 100;
@interface QMCrashSnifferSDKWrapper ()

// Crash Log 中的 Crash Exception Type
// 只有匹配到的crash类型才会输出，如 SIGSEGV，多个类型可以通过 | 连接, 如 SIGSEGV|SIGABRT
@property (nonatomic, strong) NSString *crashExceptionKey;

// Crash Log 中的 关键堆栈
// 只有匹配到对应的堆栈才会输出，如 objc_msgSend ，多个堆栈可以通过 | 连接，如objc_retain|objc_msgSend|objc_release
@property (nonatomic, strong) NSString *crashStackKey;

// 持有插件，方便调用插件功能

// TODO: xpyue
//@property (nonatomic, strong) QMCrashSnifferZombiePlugin *zombiePlugin;
//@property (nonatomic, strong) QMCrashSnifferDeallocStackPlugin *deallocStackPlugin;
//


@end


@implementation QMCrashSnifferSDKWrapper

+ (instancetype)shared
{
    static QMCrashSnifferSDKWrapper *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [QMCrashSnifferSDKWrapper new];
    });
    return shared;
}

#pragma mark - public
- (void)setup
{
    
    // 最大记录N个对象
    uint32_t recordZombieNumber = 200000;
    if (recordZombieNumber > 0)
    {
        QMCrashSnifferZombiePluginConfig *zombieConfig = [[QMCrashSnifferZombiePluginConfig alloc] init];
        zombieConfig.percent = 1;
        zombieConfig.recordZombieNumber = recordZombieNumber;
        QMCrashSnifferZombiePlugin *zombiePlugin = [[QMCrashSnifferZombiePlugin alloc] init];
        zombiePlugin.pluginConfig = zombieConfig;
        [QMCrashSnifferSDK.sharedInstance addPlugin:zombiePlugin];
        self.zombiePlugin = zombiePlugin;
    }
    NSString *specialObject = @"QMObj";
    if (specialObject.length > 0)
    {
        QMCrashSnifferDeallocStackPluginConfig *deallocStackConfig = [[QMCrashSnifferDeallocStackPluginConfig alloc] init];
        deallocStackConfig.specialObject = specialObject;
        deallocStackConfig.percent = 1;
        
        QMCrashSnifferDeallocStackPlugin *deallocStackPlugin = [[QMCrashSnifferDeallocStackPlugin alloc] init];
        deallocStackPlugin.pluginConfig = deallocStackConfig;
        [QMCrashSnifferSDK.sharedInstance addPlugin:deallocStackPlugin];
        self.deallocStackPlugin = deallocStackPlugin;
    }
    [QMCrashSnifferSDK.sharedInstance startPlugins];
    [self reportBeaconIfNeed];
}

- (NSString *)attachLogWhenCrash
{
    if ([self.zombiePlugin runingState] == NO)
    {
        return @"";
    }
    NSString *crashNames = [self getZombieClassNameByX0];
    if (crashNames.length == 0)
    {
        // x0 是 0，没啥意义
        return @"";
    }
    return crashNames;;
}

#pragma mark - private

- (NSString *)getZombieClassNameByX0
{
    NSString *crashLog = @"";
    NSString *x0Str = [self getRegisterAddressX0orR0:crashLog];
    if (x0Str.length == 0)
    {
        return @"";
    }
    NSUInteger x0Ptr = strtoul([x0Str UTF8String], 0, 16);
    NSArray<NSString *> *objNameArr = [self.zombiePlugin getObjectNameWith:x0Ptr];
    if (objNameArr.count == 0)
    {
        return @"";
    }
    
    // 看看有没有堆栈记录，先记录下来，下次启动在上报
    [self writeStackFrameToMMKVIfNeed:x0Ptr];
    
    // 弄个分隔符，方便分割
    return [NSString stringWithFormat:@"{X0: %@} {objectName: %@%@%@}", x0Str, kSplitCharacter, [objNameArr componentsJoinedByString:kSplitCharacter], kSplitCharacter];
}

- (NSString *)getRegisterAddressX0orR0:(NSString *)crashLog
{
    // 检查参数
    if (crashLog.length == 0)
    {
        return @"";
    }
    // 检查crash类型是否对应
    if ([self isNeedAnalysisX0ByExceptionType:self.crashExceptionKey crashLog:crashLog] == NO)
    {
        return @"";
    }
    // 检查堆栈是否匹配
    if ([self isNeedAnalysisX0ByStackKey:self.crashStackKey crashLog:crashLog] == NO)
    {
        return @"";
    }
    // 找到 x0 或者 r0 的位置
    NSString *regex = @"[xr]0:.*[xr]1:";
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regex
                                                                             options:0
                                                                               error:&error];
    NSArray *matches = [regular matchesInString:crashLog
                                        options:0
                                          range:NSMakeRange(0, crashLog.length)];
    if (matches.count == 0)
    {
        return @"";
    }
    
    // 找到值的位置
    NSRange range = [matches.lastObject range];
    if (range.length < kRangeMinX0Length || range.location > crashLog.length - kRangeMinX0Offset)
    {
        return @"";
    }
    range.location += kRangeMinX0Offset - 1;
    range.length -= kRangeMinX0Length;
    
    // 获取值
    NSString *value = [crashLog substringWithRange:range];
    
    NSString *address = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return address;
}

- (BOOL)isNeedAnalysisX0ByExceptionType:(NSString *)patternStr crashLog:(NSString *)crashLog
{
    NSString *exceptionType = @"Exception Type:";
    NSRange exceptionRange = [crashLog rangeOfString:exceptionType];
    if (exceptionRange.location == NSNotFound)
    {
        return NO;
    }
    // 取个范围来查找就行，没必要全文匹配
    exceptionRange.length += kCrashExceptionTypeLength;
    if (exceptionRange.length + exceptionRange.location < crashLog.length)
    {
        NSString *exceptionName = [crashLog substringWithRange:exceptionRange];
        NSArray<NSString *> *patternArray = [patternStr componentsSeparatedByString:@"|"];
        for (NSString *pattern in patternArray) {
            if ([exceptionName containsString:pattern])
            {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)isNeedAnalysisX0ByStackKey:(NSString *)patternStr crashLog:(NSString *)crashLog
{
    NSArray<NSString *> *patternArray = [patternStr componentsSeparatedByString:@"|"];
    for (NSString *pattern in patternArray) {
        if ([crashLog containsString:pattern])
        {
            return YES;
        }
    }
    return NO;
}

- (void)writeStackFrameToMMKVIfNeed:(uintptr_t)x0Ptr
{
    NSArray<NSArray<NSString *> *> *stacks = [self.deallocStackPlugin getStackSymbolWithAddress:x0Ptr];
    if (stacks.count > 0)
    {

    }
}

- (void)reportBeaconIfNeed
{
   
}

- (BOOL)isCanSetup:(NSDictionary *)config
{
    return YES;
}

+ (BOOL)qualifyUser:(NSArray<NSString *> *)qqTailArray
{
    
    return YES;
}
@end
