//
//  QMCrashSnifferBasePlugin.h
//  QQMusic
//
//  Created by xpyue on 2021/12/28.
//

#import <Foundation/Foundation.h>
#import "QMCrashSnifferBasePluginConfig.h"
#import "QMCrashSnifferDefines.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QMCrashSnifferPluginProtocol;

@protocol QMCrashSnifferPluginListenerDelegate <NSObject>
/**
 插件启动时回调
 @param plugin 被响应的插件
 */
- (void)onStart:(id<QMCrashSnifferPluginProtocol>)plugin;
/**
 插件停止时回调
 @param plugin 被响应的插件
 */
- (void)onStop:(id<QMCrashSnifferPluginProtocol>)plugin;

@end

@protocol QMCrashSnifferPluginProtocol <NSObject>

@required
/**
 启动
 */
- (BOOL)start;
/**
 停止
 */
- (void)stop;
/**
 设置代理监听插件的启动状态
 */
- (void)setupPluginListener:(id<QMCrashSnifferPluginListenerDelegate>)pluginListener;

- (QMCrashSnifferPluginType)getPluginType;

/**
 插件运行状态，
 @return YES：运行中。 NO：未运行
 */
- (BOOL)runingState;

/**
 该插件所依赖的基础能力，依赖多个能力通过 ｜连接
 */
- (QMCrashSnifferPluginBasicCapabilities)getDependency;

@end

@interface QMCrashSnifferBasePlugin : NSObject <QMCrashSnifferPluginProtocol>

@property (nonatomic, strong) QMCrashSnifferBasePluginConfig *pluginConfig;

@end

NS_ASSUME_NONNULL_END
