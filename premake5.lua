-- premake.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 7/13/2019, 3:01:34 AM

workspace 'ObjEditing'
    configurations { 'Debug', 'Release' }
    location '.build'
    toolset 'v142'
    symbols 'Full'
    architecture 'x86'

    flags {
        'MultiProcessorCompile',
        'Maps',
    }

    startproject 'ObjEditing'
    staticruntime 'On'

    defines { 'WIN32', '_WINDOWS' }

    filter 'configurations:Debug'
        defines { '_DEBUG' }
    filter 'configurations:Release'
        defines { 'NDEBUG' }
        optimize 'On'

group '3rd'
    project 'LibLua'
        kind 'StaticLib'
        language 'C'

        files {
            '3rd/lua/*.h',
            '3rd/lua/*.c',
        }

        removefiles {
            '3rd/lua/lua.c',
            '3rd/lua/luac.c',
        }

        vpaths {
            ['Header Files/*'] = {
                '3rd/lua/*.h'
            },
            ['Source Files/*'] = {
                '3rd/lua/*.c',
            }
        }

    project 'Lua'
        kind 'ConsoleApp'
        language 'C'

        links { 'LibLua' }

        files {
            '3rd/lua/lua.c',
        }

        vpaths {
            ['Source Files/*'] = {
                '3rd/lua/lua.c',
            }
        }

group ''
    project 'ObjEditing'
        kind 'ConsoleApp'
        language 'C++'
        dependson { 'Lua' }
        links { 'LibLua' }

        files {
            'src/**.cpp',
            'src/**.lua'
        }

        removefiles {
            'src/lua/**/main.lua',
            'src/lua/**/init.lua',
            'src/lua/test/**',
        }

        vpaths {
            ['Source Files/*'] = {
                'src/*.cpp',
            },
            ['Lua Files/*'] = {
                'src/lua/**.lua',
            }
        }

        includedirs {
            '3rd/lua',
            '.build'
        }

        filter 'files:**.lua'
            buildmessage 'Compiling %{file.abspath}'
            buildcommands { [[%{ generateBuildLuaCommand(wks, prj, file, cfg) }]] }
            buildoutputs { [[%{ getOutLuaPath(wks, prj, file, cfg) }]] }

-- for lua

function getOutLuaPath(wks, prj, file, cfg)
    return path.join(prj.location, 'lua', path.getrelative(path.join(_MAIN_SCRIPT_DIR, 'src/lua'), file.abspath)) .. '.inc'
end

function generateBuildLuaCommand(wks, prj, file, cfg)
    local lua = path.join(cfg.buildtarget.directory, 'Lua.exe')
    local script = path.join(_MAIN_SCRIPT_DIR, 'bin/build.lua')
    local out = path.getrelative(prj.location, getOutLuaPath(wks, prj, file, cfg))

    return string.format('"%s" "%s" "%s" "%s"', lua, script, file.abspath, out)
end
