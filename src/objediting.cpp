#include <cmdline.h>

#include "lua.hpp"
#include "luaapi.h"
#include "luasource.h"

constexpr const char* cmdline_map = "map";
constexpr const char* cmdline_output = "output";

using LuaFile = void (*)(lua_State*, int);

static void InitLuaFiles(lua_State* L, int env)
{
    LuaFile files[] = {
        InitBaseString,
        InitBaseTable,
        InitBaseClass,
        InitCoreChecker,
        InitCoreEnum,
        InitCoreObject,
        InitCoreReadbuffer,
        InitCoreWritebuffer,
        InitCoreObjectreader,
        InitCoreObjectwriter,
        InitObjectAbilityObjEditing,
        InitObjectBuffObjEditing,
        InitObjectDestructableObjEditing,
        InitObjectItemObjEditing,
        InitObjectUnitObjEditing,
        InitObjectUpgradeObjEditing,
        InitApplication,
    };

    for (auto file : files)
    {
        file(L, env);
    }
}

static void RegisterTo(lua_State* L, lua_CFunction f, const char* table, const char* name)
{
    lua_getglobal(L, table);
    lua_pushcfunction(L, f);
    lua_setfield(L, -2, name);
    lua_pop(L, 1);
}

int main(int argc, const char** argv)
{
    cmdline::parser parser;
    parser.add<std::string>(cmdline_map, 'm', "The origin map directory");
    parser.add<std::string>(cmdline_output, 'o', "The output directory");

    if (!parser.parse(argc, argv))
    {
        std::cerr << parser.usage();
        return -1;
    }

    auto L = luaL_newstate();
    luaL_openlibs(L);

    RegisterTo(L, os_chdir, "os", "chdir");

    lua_newtable(L); // _ENV
    {
        lua_newtable(L); // args
        {
            for (auto arg : {cmdline_map, cmdline_output})
            {
                lua_pushstring(L, parser.get<std::string>(arg).c_str());
                lua_setfield(L, -2, arg);
            }

            lua_newtable(L);
            {
                auto i = 0;
                for (auto& file : parser.rest())
                {
                    lua_pushstring(L, file.c_str());
                    lua_rawseti(L, -2, ++i);
                }
                lua_setfield(L, -2, "files");
            }

            lua_setfield(L, -2, "args");
        }

        lua_newtable(L); // meta
        {
            lua_pushglobaltable(L);
            lua_setfield(L, -2, "__index");
        }

        lua_setmetatable(L, -2);
    }

    InitLuaFiles(L, lua_gettop(L));

    lua_pop(L, 1);
    lua_close(L);
    return 0;
}
