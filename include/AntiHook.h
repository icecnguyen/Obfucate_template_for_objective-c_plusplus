#ifndef AntiHook_h
#define AntiHook_h

#include <stdbool.h>

#ifdef __cplusplus
extern "C"
{
#endif

bool ObfIsHooked(void *targetFunction);
bool ObfIsFunctionOutsourced(void* targetFunction);

#ifdef __cplusplus
}
#endif

#endif