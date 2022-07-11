//
//  QMCrashSnifferZombiePluginCore.c
//  QQMusic
//
//  Created by xpyue on 2021/12/31.
//  Copyright © 2021 Tencent. All rights reserved.
//

#include "QMCrashSnifferZombiePluginCore.h"
#include "QMCrashSnifferHookDeallocCapabilities.h"
#include <dispatch/base.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

const static uint32_t kStoreObjectNumber = 3;
const static uint32_t kClassNameTotalLength = 300; // 三个对象名的总长度

typedef struct
{
    int nextStoreIndex;
    const char* className[kStoreObjectNumber];
} Zombie;

static volatile Zombie* g_zombieCache;
static unsigned g_zombieHashMask;

static inline unsigned hashIndex(uintptr_t object)
{
    uintptr_t objPtr = object;
    objPtr >>= (sizeof(object) - 1);
    return objPtr & g_zombieHashMask;
}

static void crashSnifferHandleDeallocCallBack(uintptr_t objPtr, const char *className)
{
    if (className == NULL)
    {
        return;
    }
    volatile Zombie* cache = g_zombieCache;
    if(cache != NULL)
    {
        Zombie* zombie = (Zombie*)cache + hashIndex(objPtr);
        zombie->className[zombie->nextStoreIndex] = className;
        zombie->nextStoreIndex = (zombie->nextStoreIndex + 1) % kStoreObjectNumber;
    }
}

void qmzombie_installZombie(uintptr_t identification, uint32_t recordZombieNumber)
{
    uint32_t cacheSize = recordZombieNumber;
    g_zombieHashMask = cacheSize - 1;
    g_zombieCache = calloc(cacheSize, sizeof(*g_zombieCache));
    qmcs_addCallBack(identification, crashSnifferHandleDeallocCallBack);
}

void qmzombie_uninstallZombie(uintptr_t identification)
{
    void* ptr = (void*)g_zombieCache;
    g_zombieCache = NULL;
    qmcs_removeCallBack(identification);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        free(ptr);
    });
}

char* qmzombie_classNameWithObject(const void* object)
{
    volatile Zombie* cache = g_zombieCache;
    if(cache == NULL || object == NULL)
    {
        return NULL;
    }
    
    Zombie* zombie = (Zombie*)cache + hashIndex((uintptr_t)object);
    char* result = calloc(kClassNameTotalLength, sizeof(char));
    bool isMatchSuccess = false;
    for (int32_t currentIndex = 0; currentIndex < kStoreObjectNumber; ++ currentIndex)
    {
        if (zombie->className[currentIndex] != NULL)
        {
            strcat(result, zombie->className[currentIndex]);
            strcat(result, ",");
            isMatchSuccess = true;
        }
    }
    if (isMatchSuccess)
    {
        return result;
    }
    free(result);
    return NULL;
}

char* qmzombie_classNameWithUintPtr(uintptr_t objPtr)
{
    return qmzombie_classNameWithObject((const void* )objPtr);
}


