//
//  QMCrashSnifferHookDeallocCapabilities.c
//  QQMusic
//
//  Created by xpyue on 2021/12/31.
//  Copyright © 2021 Tencent. All rights reserved.
//

#include "QMCrashSnifferHookDeallocCapabilities.h"

#include <objc/runtime.h>
#include <dispatch/base.h>
#include <stdlib.h>
#include <string.h>

const static uint32_t kDefaultCapacity = 5;

// Compiler hints for "if" statements
#define likely_if(x) if(__builtin_expect(x,1))
#define unlikely_if(x) if(__builtin_expect(x,0))

typedef struct
{
    uintptr_t m_identification;
    QMCrashSnifferHandleDeallocCallBack m_callBack;
} QMCSHDCallBack;

typedef struct
{
    uint32_t m_length; // 当前长度
    uint32_t m_capacity; // 总容量
    uint32_t m_validLength; // 有效的回调长度
    QMCSHDCallBack* m_callbacks;
} QMCSHDCallBackArray;

static QMCSHDCallBackArray g_callBackArray = {};

static void initCallBackArray(void)
{
    if (g_callBackArray.m_capacity == 0)
    {
        g_callBackArray.m_length = 0;
        g_callBackArray.m_capacity = kDefaultCapacity;
        g_callBackArray.m_validLength = 0;
        g_callBackArray.m_callbacks = calloc(kDefaultCapacity, sizeof(QMCSHDCallBack));
    }
}

static void handleDealloc(const void* self)
{
    likely_if(g_callBackArray.m_validLength > 0)
    {
        Class class = object_getClass((id)self);
        const char* className = class_getName(class);
        uint32_t validLength = g_callBackArray.m_validLength;
        for (uint32_t i = 0; i <= g_callBackArray.m_length; i ++)
        {
            QMCSHDCallBack* cshdCallBack = g_callBackArray.m_callbacks + i;
            likely_if (cshdCallBack->m_callBack != NULL)
            {
                cshdCallBack->m_callBack((uintptr_t)self, className);
                validLength --;
                unlikely_if (validLength <= 0)
                {
                    return;
                }
            }
        }
    }
}

#define CREATE_ZOMBIE_HANDLER_INSTALLER(CLASS) \
static IMP g_originalDealloc_ ## CLASS; \
static void handleDealloc_ ## CLASS(id self, SEL _cmd) \
{ \
handleDealloc(self); \
typedef void (*fn)(id,SEL); \
fn f = (fn)g_originalDealloc_ ## CLASS; \
f(self, _cmd); \
} \
static void installDealloc_ ## CLASS() \
{ \
Method method = class_getInstanceMethod(objc_getClass(#CLASS), sel_registerName("dealloc")); \
g_originalDealloc_ ## CLASS = method_getImplementation(method); \
method_setImplementation(method, (IMP)handleDealloc_ ## CLASS); \
}

CREATE_ZOMBIE_HANDLER_INSTALLER(NSObject)
CREATE_ZOMBIE_HANDLER_INSTALLER(NSProxy)


void qmcs_addCallBack(uintptr_t identification, QMCrashSnifferHandleDeallocCallBack callBack)
{
    if (callBack == NULL)
    {
        return;
    }
    initCallBackArray();
    if (g_callBackArray.m_length + 1 >= g_callBackArray.m_capacity)
    {
        // 1.5倍扩容
        uint32_t newCapacity = g_callBackArray.m_length * 1.5 + 1;
        QMCSHDCallBack* tempCallbacks = g_callBackArray.m_callbacks;
        g_callBackArray.m_callbacks = calloc(newCapacity, sizeof(QMCSHDCallBack));
        memcpy(g_callBackArray.m_callbacks, tempCallbacks, sizeof(QMCSHDCallBack) * g_callBackArray.m_length);
        free(tempCallbacks);
        g_callBackArray.m_capacity = newCapacity;
    }
    QMCSHDCallBack* cshdCallBack = g_callBackArray.m_callbacks + g_callBackArray.m_length;
    cshdCallBack->m_identification = identification;
    cshdCallBack->m_callBack = callBack;
    g_callBackArray.m_length ++;
    g_callBackArray.m_validLength ++;
}

void qmcs_removeCallBack(uintptr_t identification)
{
    for (uint32_t i = 0; i <= g_callBackArray.m_length; i ++)
    {
        QMCSHDCallBack* cshdCallBack = g_callBackArray.m_callbacks + i;
        if (cshdCallBack->m_identification == identification)
        {
            cshdCallBack->m_callBack = NULL;
            g_callBackArray.m_validLength --;
        }
    }
}

void qmcs_hookDealloc(void)
{
    installDealloc_NSObject();
    installDealloc_NSProxy();
}

