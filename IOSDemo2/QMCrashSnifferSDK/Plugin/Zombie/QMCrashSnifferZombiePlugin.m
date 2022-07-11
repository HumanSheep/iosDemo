//
//  QMCrashSnifferZombiePlugin.m
//  QQMusic
//
//  Created by xpyue on 2021/12/28.
//

#import "QMCrashSnifferZombiePlugin.h"
#import "QMCrashSnifferZombiePluginCore.h"
#import "QMCrashSnifferUtility.h"

@interface QMCrashSnifferZombiePlugin ()

@property (nonatomic, assign, getter=isRuning) BOOL runing;

@end

@implementation QMCrashSnifferZombiePlugin

@dynamic pluginConfig;

#pragma mark - Supper
- (QMCrashSnifferPluginType)getPluginType
{
    return QMCrashSnifferPluginType_Zombie;
}

- (QMCrashSnifferPluginBasicCapabilities)getDependency
{
    return QMCrashSnifferPluginBasicCapabilitiesType_HookDealloc;
}

- (BOOL)start
{
    if (   [self isRuning] == NO
        && self.pluginConfig.recordZombieNumber > 0
        && [QMCrashSnifferUtility qualifyPercent:self.pluginConfig.percent])
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if ([super start])
            {
                self.runing = YES;
                qmzombie_installZombie((uintptr_t)self, self.pluginConfig.recordZombieNumber);
            }
        });
    }
    return [self isRuning];
}

- (void)stop
{
    if ([self isRuning])
    {
        [super stop];
        qmzombie_uninstallZombie((uintptr_t)self);
        self.runing = NO;
    }
}

- (BOOL)runingState
{
    return [self isRuning];
}
#pragma mark - Public

- (NSArray<NSString *> *)getObjectNameWith:(uintptr_t)objPtr
{
    
    char *c_strObjName = qmzombie_classNameWithUintPtr(objPtr);
    if (c_strObjName == NULL)
    {
        return @[];
    }
    NSString *ocObjName = [NSString stringWithCString:c_strObjName encoding:NSASCIIStringEncoding];
    free(c_strObjName);
    
    NSArray<NSString *> *objNames = [ocObjName componentsSeparatedByString:@","];
    NSMutableArray<NSString *> *result = [NSMutableArray arrayWithCapacity:objNames.count];
    [objNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (NSClassFromString(obj))
        {
            [result addObject:obj];
        }
    }];
    
    return [result copy];
}


@end
