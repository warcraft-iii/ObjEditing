#include "lua.hpp"

static void lua_openobjediting(lua_State* L, int env)
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
