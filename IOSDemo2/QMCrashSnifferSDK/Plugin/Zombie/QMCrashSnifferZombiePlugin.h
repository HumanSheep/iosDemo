//
//  QMCrashSnifferZombiePlugin.h
//  QQMusic
//
//  Created by xpyue on 2021/12/28.
//

#import "QMCrashSnifferBasePlugin.h"
#import "QMCrashSnifferZombiePluginConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMCrashSnifferZombiePlugin : QMCrashSnifferBasePlugin

@property (nonatomic, strong) QMCrashSnifferZombiePluginConfig *pluginConfig;

/// 根据地址获取类名（由于哈希冲突和地址复用的情况，名字可能不准）
/// @return 返回至多三个可能的类名
- (NSArray<NSString *> *)getObjectNameWith:(uintptr_t)objPtr;;

@end

NS_ASSUME_NONNULL_END
