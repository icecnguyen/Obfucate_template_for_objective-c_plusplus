#import <Foundation/Foundation.h>

#ifndef ObjCObfuscation_h
#define ObjCObfuscation_h

#include "StringObfuscation.hpp"

#ifdef __cplusplus
extern "C"
{
#endif

Class ObfGetClass(const char* className);
SEL ObfGetSelector(const char* selName);

#ifdef __cplusplus
}
#endif

#define OBJC_CLASS(str) ObfGetClass(OBF_STR(str))
#define OBJC_SEL(str) ObfGetSelector(OBF_STR(str))

#endif