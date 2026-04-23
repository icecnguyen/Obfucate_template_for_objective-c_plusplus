#import "AntiDump.h"
#import <mach-o/dyld.h>
#import <mach/mach.h>
#import <dlfcn.h>
#import <string.h>

void ObfEnableAntiDump(void)
{
#ifdef __arm64__
    Dl_info info;
    dladdr((const void*)ObfEnableAntiDump, &info);
    if (info.dli_fbase)
    {
        struct mach_header_64 *header = (struct mach_header_64*)info.dli_fbase;
        vm_address_t page = (vm_address_t)header & ~(vm_page_size - 1);
        kern_return_t kr = vm_protect(mach_task_self(), page, vm_page_size, false, VM_PROT_READ | VM_PROT_WRITE);
        if (kr == KERN_SUCCESS)
        {
            header->magic = 0;
            header->cputype = 0;
            header->cpusubtype = 0;
            header->filetype = 0;
            vm_protect(mach_task_self(), page, vm_page_size, false, VM_PROT_READ | VM_PROT_EXEC);
        }
    }
#endif
}