#include "lua.hpp"
#include <cmdline.h>

constexpr char* cmdline_map = "map";
constexpr char* cmdline_src = "src";
constexpr char* cmdline_output = "output";

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

int main(int argc, const char** argv)
{
	cmdline::parser parser;
	parser.add<std::string>(cmdline_map, 'm', "The origin map directory");
	parser.add<std::string>(cmdline_src, 's', "The source directory");
	parser.add<std::string>(cmdline_output, 'o', "The output directory");

	if (!parser.parse(argc, argv))
	{
		std::cerr << parser.usage();
		return -1;
	}

	auto L = luaL_newstate();
	luaL_openlibs(L);

	lua_createtable(L, 0, 1); // _ENV
	{
		lua_createtable(L, 0, 3); // args
		{
			lua_pushstring(L, parser.get<std::string>(cmdline_map).c_str());
			lua_setfield(L, -2, cmdline_map);

			lua_pushstring(L, parser.get<std::string>(cmdline_src).c_str());
			lua_setfield(L, -2, cmdline_src);

			lua_pushstring(L, parser.get<std::string>(cmdline_output).c_str());
			lua_setfield(L, -2, cmdline_output);

			lua_setfield(L, -2, "args");
		}

		lua_createtable(L, 0, 1); // meta
		{
			lua_pushglobaltable(L);
			lua_setfield(L, -2, "__index");
		}

		lua_setmetatable(L, -2);
	}

	auto env = lua_gettop(L);
	lua_openobjediting(L, env);

	lua_pop(L, 1);
	lua_close(L);
	return 0;
}
