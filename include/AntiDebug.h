#ifndef AntiDebug_h
#define AntiDebug_h

#ifdef __cplusplus
extern "C"
{
#endif

void ObfEnableAntiDebug(void);
void ObfPtraceDenyAttach(void);
int ObfCheckSysctl(void);
int ObfCheckHardwareBreakpoints(void);
void ObfDenyExceptionPort(void);

#ifdef __cplusplus
}
#endif

#endif