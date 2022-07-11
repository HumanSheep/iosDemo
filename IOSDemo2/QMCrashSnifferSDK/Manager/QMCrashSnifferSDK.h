//
//  QMCrashSnifferSDK.h
//  QQMusic
//
//  Created by xpyue on 2021/12/28.
//

#import <Foundation/Foundation.h>
#import "QMCrashSnifferBasePlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMCrashSnifferSDK : NSObject

/**
 设置插件生命周期的事件代理
 */
@property (nonatomic, weak) id<QMCrashSnifferPluginListenerDelegate> pluginListener;

+ (instancetype)sharedInstance;

/**
 添加插件
 */
- (void)addPlugin:(QMCrashSnifferBasePlugin *)plugin;

/**
 启动所有插件
 */
- (void)startPlugins;

/**
 停止所有插件
 */
- (void)stopPlugins;

/**
 查询某插件是否在运行
 */
- (BOOL)isRuningWithPluginType:(QMCrashSnifferPluginType)type;

@end

NS_ASSUME_NONNULL_END
