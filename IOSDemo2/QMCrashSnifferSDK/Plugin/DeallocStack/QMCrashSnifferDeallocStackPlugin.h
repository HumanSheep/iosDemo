//
//  QMCrashSnifferDeallocStackPlugin.h
//  QQMusic
//
//  Created by xpyue on 2021/12/28.
//

#import "QMCrashSnifferBasePlugin.h"
#import "QMCrashSnifferDeallocStackPluginConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMCrashSnifferDeallocStackPlugin : QMCrashSnifferBasePlugin

@property (nonatomic, strong) QMCrashSnifferDeallocStackPluginConfig *pluginConfig;

/// 异步接口，获取符号信息。completion将在子线程回调
/// @param objPtr  某个对象地址
/// @param completion 符号化后的回调，参数是已经符号好的堆栈信息，如果没有信息返回空数据的数组
- (void)fetchStackSymbolWithAddress:(uintptr_t)objPtr
                         completion:(QMCrashSnifferFetchStackSymbolBlock)completion;


- (NSArray<NSArray<NSString *> *> *)getStackSymbolWithAddress:(uintptr_t)objPtr;
@end

NS_ASSUME_NONNULL_END
