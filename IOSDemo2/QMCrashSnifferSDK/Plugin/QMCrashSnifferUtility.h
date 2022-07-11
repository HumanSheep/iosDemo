//
//  QMCrashSnifferUtility.h
//  QQMusic
//
//  Created by xpyue on 2021/12/28.
//

#import <Foundation/Foundation.h>
#import "QMCrashSnifferDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMCrashSnifferUtility : NSObject
/**
 灰度校验
 */
+ (BOOL)qualifyPercent:(double)percent;

/**
 启动插件依赖的能力
 */
+ (void)startDependencyCapability:(QMCrashSnifferPluginBasicCapabilities)basicCapabilities;
@end

NS_ASSUME_NONNULL_END
