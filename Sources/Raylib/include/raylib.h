#if defined(__APPLE__)
#include "../raylib-5.0_macos/include/raylib.h"
#elif defined(__linux__) && defined(__x86_64__)
#include "../raylib-5.0_linux_amd64/include/raylib.h"
#elif defined(_WIN64)
#include "../raylib-5.0_win64_msvc16/include/raylib.h"
#endif
