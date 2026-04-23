#import "AntiDebug.h"
#import <Foundation/Foundation.h>
#import <sys/sysctl.h>
#import <unistd.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

void ObfPtraceDenyAttach(void)
{
#ifdef __arm64__
    asm volatile ("mov x0, #31\n" "mov x1, #0\n" "mov x2, #0\n" "mov x3, #0\n" "mov x16, #26\n" "svc #0x80\n");
#else
    void* handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    if (handle)
    {
        typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
        ptrace_ptr_t ptrace_ptr = (ptrace_ptr_t)dlsym(handle, "ptrace");
        if (ptrace_ptr) ptrace_ptr(31, 0, 0, 0);
        dlclose(handle);
    }
#endif
}

int ObfCheckSysctl(void)
{
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()};
    struct kinfo_proc info;
    size_t size = sizeof(info);
    info.kp_proc.p_flag = 0;
    
    if (sysctl(mib, 4, &info, &size, NULL, 0) == -1)
    {
        return 1;
    }
    if (info.kp_proc.p_flag & P_TRACED)
    {
        return 1;
    }
    return 0;
}

int ObfCheckHardwareBreakpoints(void)
{
#ifdef __arm64__
    arm_debug_state64_t dbg_state;
    mach_msg_type_number_t count = ARM_DEBUG_STATE64_COUNT;
    kern_return_t kr = thread_get_state(mach_thread_self(), ARM_DEBUG_STATE64, (thread_state_t)&dbg_state, &count);
    if (kr == KERN_SUCCESS)
    {
        for (int i = 0; i < 16; i++)
        {
            if (dbg_state.__bcr[i] != 0 || dbg_state.__bvr[i] != 0)
            {
                return 1;
            }
            if (dbg_state.__wcr[i] != 0 || dbg_state.__wvr[i] != 0)
            {
                return 1;
            }
        }
    }
#endif
    return 0;
}

void ObfDenyExceptionPort(void)
{
    task_set_exception_ports(mach_task_self(), EXC_MASK_ALL, MACH_PORT_NULL, EXCEPTION_DEFAULT, THREAD_STATE_NONE);
}

void ObfEnableAntiDebug(void)
{
    ObfPtraceDenyAttach();
    ObfDenyExceptionPort();
    
    if (ObfCheckSysctl() || ObfCheckHardwareBreakpoints())
    {
#ifdef __arm64__
        asm volatile ("mov x0, #1\n" "mov x16, #1\n" "svc #0x80\n");
#else
        _exit(1);
#endif
    }
}