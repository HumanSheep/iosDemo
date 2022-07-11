//
//  QMCrashSnifferZombiePluginConfig.h
//  QQMusic
//
//  Created by xpyue on 2021/12/28.
//

#import "QMCrashSnifferBasePluginConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMCrashSnifferZombiePluginConfig : QMCrashSnifferBasePluginConfig

/**
 记录释放的对象，开启比例
 取值范围[0, 1]，0是不开启，1是全部开启。默认0
 */
@property (assign, nonatomic) double percent;

/**
 记录释放对象的数量，耗费内存为;  recordZombieNumbe * 32 (byte) ，0则不开启。默认 200000  (20万）
 */
@property (assign, nonatomic) uint32_t recordZombieNumber;

@end

NS_ASSUME_NONNULL_END
