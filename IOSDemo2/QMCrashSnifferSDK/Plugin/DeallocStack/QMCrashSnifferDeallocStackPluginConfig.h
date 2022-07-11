//
//  QMCrashSnifferDeallocStackPluginConfig.h
//  QQMusic
//
//  Created by xpyue on 2021/12/28.
//

#import "QMCrashSnifferBasePluginConfig.h"

#define QMCrashSniffer_STACK_DEPTH_SIZE 254

NS_ASSUME_NONNULL_BEGIN

/// 堆栈符号化回调
/// @param callStacks 特定对象在该地址的所有释放堆栈
typedef void(^QMCrashSnifferFetchStackSymbolBlock)(uintptr_t objPtr, NSArray<NSArray<NSString *> *> *callStacks);

@interface QMCrashSnifferDeallocStackPluginConfig : QMCrashSnifferBasePluginConfig

/**
 需要特殊监控的类
 因为内部会获取堆栈信息，如果是监控高频率释放的对象，会有较高的CPU开销。
 */
@property (nonatomic, strong) NSString *specialObject;

/**
 监控重复释放的对象，开启比例。
 取值范围[0, 1]，0是不开启，1是全部开启。默认0
 */
@property (nonatomic, assign) double percent;
/**
 限制记录堆栈的最大深度，默认64。 内存花销大约为 maxStackDepth * 8 byte * maxStorageStackNumber
 取值范围 (0, 254]
 */
@property (nonatomic, assign) uint8_t maxStackDepth;

/// 记录堆栈的最大数量，默认20000。内存花销大约为 maxStackDepth * 8 byte * maxStorageStackNumber
@property (nonatomic, assign) uint32_t maxStorageStackNumber;
/**
 是否需要自动释放，默认YES
 时机：
 1. 内存警告的时候
 2. 超过存储数量后
 */
@property (nonatomic, assign) BOOL aotoStop;

@end

NS_ASSUME_NONNULL_END
