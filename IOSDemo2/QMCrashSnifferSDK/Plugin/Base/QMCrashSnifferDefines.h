//
//  QMCrashSnifferDefines.h
//  QQMusic
//
//  Created by xpyue on 2021/12/30.
//  Copyright © 2021 Tencent. All rights reserved.
//

#ifndef QMCrashSnifferDefines_h
#define QMCrashSnifferDefines_h


/**
 需要启动的插件，可能依赖多项能力
 */
typedef NSUInteger QMCrashSnifferPluginBasicCapabilities;

/**
 插件依赖哪些通用能力
*/
typedef NS_OPTIONS(NSUInteger, QMCrashSnifferPluginBasicCapabilitiesType)
{
    QMCrashSnifferPluginBasicCapabilitiesType_Unknown           = 1 << 0,
    /// 基于hook Dealloc的能力
    QMCrashSnifferPluginBasicCapabilitiesType_HookDealloc       = 1 << 1,
};

/**
 插件类型
 */
typedef NS_OPTIONS(NSUInteger, QMCrashSnifferPluginType)
{
    QMCrashSnifferPluginType_Unknown                        = 1 << 0,
    /// 记录所以释放的对象
    QMCrashSnifferPluginType_Zombie                         = 1 << 1,
    /// 监控某个对象的释放堆栈
    QMCrashSnifferPluginType_DeallocStack                   = 1 << 2,
};

#endif /* QMCrashSnifferDefines_h */
