//
//  QMCrashSnifferZombiePluginCore.h
//  QQMusic
//
//  Created by xpyue on 2021/12/31.
//  Copyright © 2021 Tencent. All rights reserved.
//

#ifndef QMCrashSnifferZombiePluginCore_h
#define QMCrashSnifferZombiePluginCore_h

#ifdef __cplusplus
extern "C" {
#endif

#include <stdbool.h>
#include "stdio.h"


/**
 * 返回至多三个对象类名，并使用 ,（英文逗号） 隔开
 * 外部使用完后需要主动释放指针
 * @param objPtr 指针地址
 *
 * @return 返回至多三个对象类名，并使用 ,（英文逗号） 隔开
 */

char* qmzombie_classNameWithUintPtr(uintptr_t objPtr);

/**
 记录需要释放的对象
 @param identification   唯一标识，建议使用self地址
 @param recordZombieNumber   设置需要记录的对象数量
 */
void qmzombie_installZombie(uintptr_t identification, uint32_t recordZombieNumber);

/**
 释放记录对象的所用资源
 @param identification   唯一标识，建议使用self地址
 */
void qmzombie_uninstallZombie(uintptr_t identification);


#ifdef __cplusplus
}
#endif

#endif /* QMCrashSnifferZombiePluginCore_h */
