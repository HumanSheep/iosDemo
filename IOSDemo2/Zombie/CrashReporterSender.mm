//
//  CrashReporterSender+RegisterLog.m
//  QQMusic
//
//  Created by sheepliu on 2018/2/27.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "CrashReporterSender.h"

static NSString *const kStackFrameFeature = @"objc_object::release";    /// 需要打印的前提，堆栈特征
static const double kRandomRate = 0.05;                                 /// 随机打印概率，5%

static const NSString *matchCrash = @"SIGSEGV";

@implementation CrashReporterSender


NSString *GetRegisterAddressX0orR0(NSString *crashLog)
{
    // 检查参数
    if (!crashLog.length)
    {
        return @"Error: Empty crash log";
    }
    // 找到 x0 或者 r0 的位置
    NSString *regex = @"[xr]0:.*[xr]1:";
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regex
                                                                             options:0
                                                                               error:&error];
    NSArray *matches = [regular matchesInString:crashLog
                                        options:0
                                          range:NSMakeRange(0, crashLog.length)];
    if (!matches.count)
    {
        return @"Error: No x0 or r0 found";
    }
    
    // 找到值的位置
    NSRange range = [matches.lastObject range];
    if (range.length < 6 || range.location > crashLog.length - 4)
    {
        return @"Error: x0 or r0 range error";
    }
    range.location += 3;
    range.length -= 6;
    
    // 获取值
    NSString *value = [crashLog substringWithRange:range];
    
    NSString *address = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return address;
}

NSString *GetObjectInfoInMemoryAddress(NSString *address)
{
    // 检查参数
    if (!address.length)
    {
        return @"0 [REGISTER] X0 or R0 Read Failed, Empty address";
    }
    
    // 使用地址还原对象
    NSObject *retrievedObject = nil;
    sscanf([address cStringUsingEncoding:NSUTF8StringEncoding], "%p", &retrievedObject);
    
    // 返回输出
    return [NSString stringWithFormat:@"0 [REGISTER] X0 or R0 address:%@, className:%s", address, object_getClassName(retrievedObject)];
}

BOOL NeedLogRegisterClassNameWithStackArray(NSArray<NSString *> *stackArray)
{
    // 检查参数
    if (!stackArray.count)
    {
        return NO;
    }
    
    // 只针对 kStackFrameFeature 的情况做记录
    NSString *topStackFrame = stackArray.firstObject;
    if ([topStackFrame rangeOfString:kStackFrameFeature].location == NSNotFound)
    {
        return NO;
    }

    // 使用 kRandomRate 概率随机决定是否打印
    return YES;
}

BOOL isNeedAnalysisX0ByExceptionType(NSString *patternStr, NSString *crashLog)
{
    NSString *exceptionType = @"Exception Type:";
    NSRange exceptionRange = [crashLog rangeOfString:exceptionType];
    if (exceptionRange.location == NSNotFound)
    {
        return NO;
    }
    // 取个范围来查找就行，全文匹配速度比较耗时（crahsLog大概七万字符）
    exceptionRange.length += 100;
    if (exceptionRange.length + exceptionRange.location < crashLog.length)
    {
        NSString *exceptionName = [crashLog substringWithRange:exceptionRange];
        NSArray<NSString *> *patternArray = [patternStr componentsSeparatedByString:@"|"];
        for (NSString *pattern in patternArray) {
            if ([exceptionName containsString:pattern])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

BOOL isNeedAnalysisX0ByStackKey(NSString *patternStr, NSString *crashLog)
{
    NSArray<NSString *> *patternArray = [patternStr componentsSeparatedByString:@"|"];
    for (NSString *pattern in patternArray) {
        if ([crashLog containsString:pattern])
        {
            return YES;
        }
    }
    return NO;
}
@end

void hhh()
{
    pthread_t thread;
    pthread_create(&thread, nullptr, [](void *p) {
//        thread_suspend(main_thread);
//        // generate symbols of (main_thread);
//        thread_resume(main_thread);
        
        void *ptr = nullptr;
        return ptr;
    }, nullptr);
#if defined(__x86_64__)
    _STRUCT_MCONTEXT ctx;
    mach_msg_type_number_t count = x86_THREAD_STATE64_COUNT;
    thread_get_state(thread, x86_THREAD_STATE64, (thread_state_t)&ctx.__ss, &count);
    
    uint64_t pc = ctx.__ss.__rip;
    uint64_t sp = ctx.__ss.__rsp;
    uint64_t fp = ctx.__ss.__rbp;
#elif defined(__arm64__)
    _STRUCT_MCONTEXT ctx;
    mach_msg_type_number_t count = ARM_THREAD_STATE64_COUNT;
    thread_get_state(thread, ARM_THREAD_STATE64, (thread_state_t)&ctx.__ss, &count);
    
    uint64_t pc = ctx.__ss.__pc;
    uint64_t sp = ctx.__ss.__sp;
    uint64_t fp = ctx.__ss.__fp;
#endif
}
