//
//  QMCrashSnifferSDKWrapper.h
//  QQMusic
//
//  Created by xpyue on 2021/12/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMCrashSnifferZombiePlugin.h"
#import "QMCrashSnifferDeallocStackPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMCrashSnifferSDKWrapper : NSObject

@property (nonatomic, strong) QMCrashSnifferZombiePlugin *zombiePlugin;
@property (nonatomic, strong) QMCrashSnifferDeallocStackPlugin *deallocStackPlugin;

/// 获取单例
+ (instancetype)shared;

/**
 根据红石配置，启动一些插件
 */
- (void)setup;

/**
 crash的时候，追加crash日志，给出x0地址对应的类名（由于哈希冲突的存在，名字可能不准）
 如果没有crash时调用，返回  @""
 */
- (NSString *)attachLogWhenCrash;

@end

NS_ASSUME_NONNULL_END
