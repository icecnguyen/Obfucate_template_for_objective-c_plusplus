#import "AntiEnvironment.h"
#import <Foundation/Foundation.h>
#import <sys/stat.h>

bool ObfIsJailbrokenOrTampered(void)
{
    const char *jailbreak_paths[] = {"/Applications/Cydia.app", "/Applications/Sileo.app", "/Applications/Zebra.app", "/usr/sbin/sshd", "/bin/bash", "/etc/apt", "/Library/MobileSubstrate/MobileSubstrate.dylib", "/var/jb/Applications/Sileo.app", "/var/jb/usr/bin/bash", "/var/jb/Library/MobileSubstrate/MobileSubstrate.dylib", "/Applications/TrollStore.app", NULL};
    
    for (int i = 0; jailbreak_paths[i] != NULL; i++)
    {
        struct stat stat_info;
        if (stat(jailbreak_paths[i], &stat_info) == 0)
        {
            return true;
        }
    }
    
    struct stat lstat_info;
    if (lstat("/var/jb", &lstat_info) == 0)
    {
        if (S_ISLNK(lstat_info.st_mode))
        {
            return true;
        }
    }
    
    return false;
}