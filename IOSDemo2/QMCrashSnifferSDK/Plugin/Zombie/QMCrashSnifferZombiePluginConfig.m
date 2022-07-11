//
//  QMCrashSnifferZombiePluginConfig.m
//  QQMusic
//
//  Created by xpyue on 2021/12/28.
//

#import "QMCrashSnifferZombiePluginConfig.h"

static uint32_t kDefaultRecordZombieNumber = 200000;

@implementation QMCrashSnifferZombiePluginConfig

- (instancetype)init
{
    if (self = [super init])
    {
        self.recordZombieNumber = kDefaultRecordZombieNumber;
    }
    return self;
}
@end
