//
//  QMCrashSnifferSDK.m
//  QQMusic
//
//  Created by xpyue on 2021/12/28.
//

#import "QMCrashSnifferSDK.h"
#import "QMCrashSnifferUtility.h"

@interface QMCrashSnifferSDK ()

// 放插件
@property (nonatomic, strong) NSMutableSet<QMCrashSnifferBasePlugin *> *plugins;

@end

@implementation QMCrashSnifferSDK

+ (instancetype)sharedInstance
{
    static QMCrashSnifferSDK *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QMCrashSnifferSDK alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.plugins = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)addPlugin:(QMCrashSnifferBasePlugin *)plugin {
    if (plugin == nil)
    {
        return;
    }
    [self.plugins addObject:plugin];
}

- (void)startPlugins
{
    QMCrashSnifferPluginBasicCapabilities basicCapabilities = QMCrashSnifferPluginBasicCapabilitiesType_Unknown;
    for (QMCrashSnifferBasePlugin *plugin in self.plugins)
    {
        [plugin setupPluginListener:self.pluginListener];
        if ([plugin start])
        {
            basicCapabilities |= [plugin getDependency];
        }
    }
    [QMCrashSnifferUtility startDependencyCapability:basicCapabilities];
}

- (void)stopPlugins
{
    for (QMCrashSnifferBasePlugin *plugin in self.plugins)
    {
        [plugin stop];
    }
}

- (BOOL)isRuningWithPluginType:(QMCrashSnifferPluginType)type
{
    for (QMCrashSnifferBasePlugin *plugin in self.plugins)
    {
        if ([plugin getPluginType] == type)
        {
            return [plugin runingState];
        }
    }
    return NO;
}
@end
