//
//  KSCrashMonitor_Thread.m
//  IOSDemo2
//
//  Created by xpyue on 2021/10/19.
//

#import "KSCrashMonitor_Thread.h"
#include <pthread.h>
#include <mach/mach.h>
#include <mach-o/arch.h>

@implementation KSCrashMonitor_Thread

- (void)testThread
{
    pthread_t thread;
    pthread_create(&thread, nil, [](void *p) {
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
@end
