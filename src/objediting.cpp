#include <cmdline.h>
#include "lua.hpp"
#include "luaapi.h"
#include "luasource.h"

constexpr char* CMDLINE_MAP = "map";
constexpr char* CMDLINE_OUTPUT = "output";

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
    parser.set_program_name("ObjEditing");
    parser.add<std::string>(CMDLINE_MAP, 'm', "The origin map directory");
    parser.add<std::string>(CMDLINE_OUTPUT, 'o', "The output directory");

    if (!parser.parse(argc, argv))
    {
        std::cerr << parser.usage();
        return -1;
    }

    auto L = luaL_newstate();
    luaL_openlibs(L);

    // init apis
    {
        RegisterTo(L, os_chdir, "os", "chdir");
    }

    // init env
    {
        lua_newtable(L); // _ENV
        {
            lua_newtable(L); // args
            {
                for (auto arg : {CMDLINE_MAP, CMDLINE_OUTPUT})
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
    }

    // run files
    {
        using LuaFile = void (*)(lua_State*, int);

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

        auto env = lua_gettop(L);
        for (auto file : files)
        {
            file(L, env);
        }
    }

    lua_pop(L, 1);
    lua_close(L);
    return 0;
}
