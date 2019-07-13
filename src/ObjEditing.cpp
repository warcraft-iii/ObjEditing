#include "lua.hpp"

static void lua_openobjediting(lua_State* L)
{
#include "base/string.lua.inc"
#include "base/table.lua.inc"
#include "base/class.lua.inc"
#include "src/object.lua.inc"
#include "src/readbuffer.lua.inc"
#include "src/writebuffer.lua.inc"
#include "src/objectreader.lua.inc"
#include "src/objectwriter.lua.inc"
#include "src/application.lua.inc"
}

int main()
{
	auto L = luaL_newstate();
	luaL_openlibs(L);
	lua_openobjediting(L);
	lua_close(L);
	return 0;
}
