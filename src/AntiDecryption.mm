#import "AntiDecryption.h"
#import <mach-o/dyld.h>
#import <mach-o/getsect.h>

bool ObfIsAppDecrypted(void)
{
#ifdef __arm64__
    const struct mach_header *header = _dyld_get_image_header(0);
    const struct mach_header_64 *header64 = (const struct mach_header_64 *)header;
    struct load_command *cmd = (struct load_command *)((uint8_t *)header64 + sizeof(struct mach_header_64));
    for (uint32_t i = 0; i < header64->ncmds; i++)
    {
        if (cmd->cmd == LC_ENCRYPTION_INFO_64)
        {
            struct encryption_info_command_64 *crypt_cmd = (struct encryption_info_command_64 *)cmd;
            if (crypt_cmd->cryptid == 0)
            {
                return true;
            }
            return false;
        }
        cmd = (struct load_command *)((uint8_t *)cmd + cmd->cmdsize);
    }
#endif
    return false;
}