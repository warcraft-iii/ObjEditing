-- premake.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 7/13/2019, 3:01:34 AM

workspace 'ObjEditing'
    configurations { 'Debug', 'Release' }
    location '.build'
    symbols 'Full'
    architecture 'x86'
    startproject 'ObjEditing'
    flags {
        'MultiProcessorCompile',
        'Maps',
    }

    filter 'system:Windows'
        systemversion 'latest'
        characterset 'MBCS'
        staticruntime 'On'
        defines { 'WIN32', '_WINDOWS' }
    filter 'configurations:Debug'
        defines { '_DEBUG' }
    filter 'configurations:Release'
        defines { 'NDEBUG' }
        optimize 'On'

project 'ObjEditing'
    kind 'ConsoleApp'
    language 'C++'
    dependson { 'Lua' }
    links { 'LibLua' }

    files {
        'src/*.c',
        'src/*.cpp',
        'src/*.h',
        'src/*.hpp',
        'src/**.lua',
        'src/*.natvis',
    }

    removefiles {
        'src/lua/**/main.lua',
        'src/lua/**/init.lua',
    }

    vpaths {
        ['Source Files/*'] = {
            'src/*.cpp',
            'src/*.c',
        },
        ['Header Files/*'] = {
            'src/*.h',
        },
        ['Lua Files/*'] = {
            'src/lua/**.lua',
        },
        [''] = {
            '**.natvis'
        },
    }

    includedirs {
        '3rd/lua',
        '3rd/cmdline',
        '.build',
        'src'
    }

    filter 'system:Windows'
        defines { 'PLATFORM_WINDOWS' }

    filter 'files:**.lua'
        buildmessage 'Compiling %{file.name}'
        buildinputs { 'bin/build.lua' }
        buildcommands { [[%{ generateBuildLuaCommand(_ENV) }]] }
        buildoutputs {
            [[%{ getGeneratedSource(_ENV) }]],
            [[%{ getGeneratedHeader(_ENV) }]],
        }
        compilebuildoutputs 'On'

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

do -- for lua

    function getGeneratedDir(_ENV)
        return path.join(prj.location, path.getrelative(path.join(_MAIN_SCRIPT_DIR, 'src'), file.directory))
    end

    function getGeneratedSource(_ENV)
        return path.join(getGeneratedDir(_ENV), file.basename .. '.lua.cpp')
    end

    function getGeneratedHeader(_ENV)
        return path.join(getGeneratedDir(_ENV), file.basename .. '.lua.h')
    end

    function generateBuildLuaCommand(_ENV)
        local lua = path.join(cfg.buildtarget.directory, 'Lua.exe')
        local script = path.join(_MAIN_SCRIPT_DIR, 'bin/build.lua')
        local out = getGeneratedDir(_ENV)

        return string.format([["%s" "%s" "%s" "%s"]], lua, script, file.abspath, out)
    end
end
