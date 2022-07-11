//
//  QMCrashSnifferDeallocStackPluginConfig.m
//  QQMusic
//
//  Created by xpyue on 2021/12/28.
//

#import "QMCrashSnifferDeallocStackPluginConfig.h"

static uint8_t kDefaultMaxStackDepth = 16;
static uint32_t kDefaultMaxStorageStackNumber = 20000;

@implementation QMCrashSnifferDeallocStackPluginConfig

- (instancetype)init
{
    if (self = [super init])
    {
        self.maxStackDepth = kDefaultMaxStackDepth;
        self.maxStorageStackNumber = kDefaultMaxStorageStackNumber;
        self.aotoStop = YES;
    }
    return self;
}

- (void)setMaxStackDepth:(uint8_t)maxStackDepth
{
    _maxStackDepth = MIN(maxStackDepth, QMCrashSniffer_STACK_DEPTH_SIZE);
}
@end
