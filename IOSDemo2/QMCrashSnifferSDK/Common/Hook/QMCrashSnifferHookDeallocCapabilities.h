//
//  QMCrashSnifferHookDeallocCapabilities.h
//  QQMusic
//
//  Created by xpyue on 2021/12/31.
//  Copyright © 2021 Tencent. All rights reserved.
//

#ifndef QMCrashSnifferHookDeallocCapabilities_h
#define QMCrashSnifferHookDeallocCapabilities_h

#ifdef __cplusplus
extern "C" {
#endif

#include <stdbool.h>
#include "stdio.h"

/** 对象销毁回调
 *
 * @param objPtr 被销毁对象的地址
 *
 * @param className 类名
 *
 */
typedef void (*QMCrashSnifferHandleDeallocCallBack)(uintptr_t objPtr, const char *className);

/** Get the class of a deallocated object pointer, if it was tracked.
 *
 * @param object A pointer to a deallocated object.
 *
 * @return The object's class name, or NULL if it wasn't found.
 */

/**
 注册对象释放的回调
 */
void qmcs_setCallBack(QMCrashSnifferHandleDeallocCallBack callBack);

/**
 添加对象释放的回调
 @param identification 标识符，建议使用指针地址
 @param callBack dealloc时回调
 */
void qmcs_addCallBack(uintptr_t identification, QMCrashSnifferHandleDeallocCallBack callBack);

/**
 移除对象释放的回调
 @param identification 标识符，建议使用指针地址
 */
void qmcs_removeCallBack(uintptr_t identification);

/**
 hook dealloc
 */
void qmcs_hookDealloc(void);
#ifdef __cplusplus
}
#endif


#endif /* QMCrashSnifferHookDeallocCapabilities_h */
