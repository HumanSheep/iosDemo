//
//  QMCrashSnifferBasePlugin.m
//  QQMusic
//
//  Created by xpyue on 2021/12/28.
//

#import "QMCrashSnifferBasePlugin.h"

@interface QMCrashSnifferBasePlugin ()

@property (nonatomic, weak) id<QMCrashSnifferPluginListenerDelegate> pluginListener;

@end

@implementation QMCrashSnifferBasePlugin

@synthesize pluginConfig;

- (QMCrashSnifferPluginType)getPluginType
{
    return QMCrashSnifferPluginType_Unknown;
}

- (QMCrashSnifferPluginBasicCapabilities)getDependency
{
    return QMCrashSnifferPluginBasicCapabilitiesType_Unknown;
}

- (void)setupPluginListener:(id<QMCrashSnifferPluginListenerDelegate>)pluginListener
{
    _pluginListener = pluginListener;
}

- (BOOL)start
{
    if ([_pluginListener respondsToSelector:@selector(onStart:)])
    {
        [_pluginListener onStart:self];
    }
    return YES;
}

- (void)stop
{
    if ([_pluginListener respondsToSelector:@selector(onStop:)])
    {
        [_pluginListener onStop:self];
    }
}

- (BOOL)runingState
{
    return NO;
}

@end
