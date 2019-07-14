#include "lua.hpp"

static void lua_openobjediting(lua_State* L, int env)
{
#include "lua/base/string.lua.inc"
#include "lua/base/table.lua.inc"
#include "lua/base/class.lua.inc"
#include "lua/core/checker.lua.inc"
#include "lua/core/object.lua.inc"
#include "lua/core/readbuffer.lua.inc"
#include "lua/core/writebuffer.lua.inc"
#include "lua/core/objectreader.lua.inc"
#include "lua/core/objectwriter.lua.inc"
#include "lua/application.lua.inc"
}

int main()
{
	auto L = luaL_newstate();
	luaL_openlibs(L);

	lua_newtable(L); // _ENV
	{
		lua_createtable(L, 0, 1); // _META
		lua_pushglobaltable(L);
		lua_setfield(L, -2, "__index");

		lua_setmetatable(L, -2);
	}

	auto env = lua_gettop(L);
	lua_openobjediting(L, env);

	lua_pop(L, 1);
	lua_close(L);
	return 0;
}
