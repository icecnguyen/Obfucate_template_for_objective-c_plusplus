#pragma once

#include <string>
#include <array>

namespace Obf
{

constexpr unsigned int compile_time_seed()
{
    return (__TIME__[0] * 1000000) ^ (__TIME__[1] * 10000) ^ (__TIME__[3] * 100) ^ (__TIME__[4] * 1) ^ (__TIME__[6] * 10) ^ (__TIME__[7] * 1);
}
constexpr unsigned int lcg_random(unsigned int& seed)
{
    seed = (1103515245 * seed + 12345) % 2147483648;
    return seed;
}

template<size_t Size>
struct XorString
{
    char _encrypted[Size];
    constexpr XorString(const char* str, unsigned int key) : _encrypted{}
    {
        unsigned int cur_key = key;
        for (size_t i = 0; i < Size; ++i)
        {
            _encrypted[i] = str[i] ^ (static_cast<char>(lcg_random(cur_key) % 255));
        }
    }
};

}

#define OBF_STR(str) ([]() -> char* \
{ \
    constexpr unsigned int key = __LINE__ ^ Obf::compile_time_seed(); \
    constexpr Obf::XorString<sizeof(str)> obfuscated(str, key); \
    static char decrypted[sizeof(str)] = {0}; \
    static bool is_decrypted = false; \
    if (!is_decrypted) \
    { \
        unsigned int cur_key = key; \
        for (size_t i = 0; i < sizeof(str); ++i) \
        { \
            decrypted[i] = obfuscated._encrypted[i] ^ (static_cast<char>(Obf::lcg_random(cur_key) % 255)); \
        } \
        decrypted[sizeof(str) - 1] = '\0'; \
        is_decrypted = true; \
    } \
    return decrypted; \
}())