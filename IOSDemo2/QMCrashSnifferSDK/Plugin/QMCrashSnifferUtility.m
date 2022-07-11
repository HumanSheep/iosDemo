//
//  QMCrashSnifferUtility.m
//  QQMusic
//
//  Created by xpyue on 2021/12/28.
//

#import "QMCrashSnifferUtility.h"
#import "QMCrashSnifferHookDeallocCapabilities.h"

@implementation QMCrashSnifferUtility

+ (BOOL)qualifyPercent:(double)percent
{
    return drand48() < percent;
}

+ (void)startDependencyCapability:(QMCrashSnifferPluginBasicCapabilities)basicCapabilities
{
    if (basicCapabilities & QMCrashSnifferPluginBasicCapabilitiesType_HookDealloc)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            qmcs_hookDealloc();
        });
    }
}
@end
