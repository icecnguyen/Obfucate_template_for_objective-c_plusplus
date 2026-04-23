#ifndef ObfuscateModule_h
#define ObfuscateModule_h

#include "StringObfuscation.hpp"
#include "ObjCObfuscation.h"

#ifdef OBF_USE_ANTI_DEBUG
#include "AntiDebug.h"
#endif

#ifdef OBF_USE_ANTI_DUMP
#include "AntiDump.h"
#endif

#ifdef OBF_USE_ANTI_HOOK
#include "AntiHook.h"
#endif

#ifdef OBF_USE_ANTI_DECRYPTION
#include "AntiDecryption.h"
#endif

#ifdef OBF_USE_ANTI_ENVIRONMENT
#include "AntiEnvironment.h"
#endif

#ifdef __cplusplus
namespace Obf
{
    __attribute__((always_inline)) inline void _applyAllProtections()
    {
#ifdef OBF_USE_ANTI_DEBUG
        ObfEnableAntiDebug(); 
#endif

#ifdef OBF_USE_ANTI_DUMP
        ObfEnableAntiDump();
#endif

#ifdef OBF_USE_ANTI_DECRYPTION
        if (ObfIsAppDecrypted())
        {
#ifdef __arm64__
            asm volatile ("mov x0, #1\n mov x16, #1\n svc #0x80\n");
#endif
        }
#endif

#ifdef OBF_USE_ANTI_ENVIRONMENT
        if (ObfIsJailbrokenOrTampered())
        {
#ifdef __arm64__
            asm volatile ("mov x0, #1\n mov x16, #1\n svc #0x80\n");
#endif
        }
#endif
    }
}
#define OBF_INIT_PROTECTIONS() Obf::_applyAllProtections()

#else
#define OBF_INIT_PROTECTIONS() do {} while(0)
#endif

#endif