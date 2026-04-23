#import "ObjCObfuscation.h"
#import <objc/runtime.h>
#import <string.h>

Class ObfGetClass(const char* className)
{
    if (!className)
    {
        return Nil;
    }
    
    return objc_getClass(className);
}

SEL ObfGetSelector(const char* selName)
{
    if (!selName)
    {
        return NULL;
    }
    
    return sel_registerName(selName);
}