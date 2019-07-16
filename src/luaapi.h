#pragma once

#include "lua.h"

#if __cplusplus
extern "C"
{
#endif

    int os_chdir(lua_State* L);

#if __cplusplus
}
#endif
