-- build.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 7/13/2019, 9:50:37 PM
package.path = package.path .. ';../src/lua/?.lua'

require('base.string')

local hTemplate = [[
#pragma once
#include "lua.hpp"
void Init%s(lua_State* L, int env);
]]

local cTemplate = [[
#include "lua.hpp"

const unsigned char CODE[] = {
    %s
};

const unsigned char API[] = {
    %s
};

void Init%s(lua_State* L, int env)
{
    luaL_loadbuffer(L, (const char*)CODE, %s, "@%s");
    lua_pushvalue(L, env);
    lua_setupvalue(L, -2, 1);
    lua_call(L, 0, 0);

    if (*API != 0) {
        lua_getfield(L, -1, "sourcecode");
        
        luaL_loadbuffer(L, (const char*)API, %s, "@%s");
        lua_pushvalue(L, env);
        lua_setupvalue(L, -2, 1);
        lua_call(L, 0, 1);

        lua_setfield(L, -2, "%s");
        lua_pop(L, 1);
    }
}
]]

local function writeFile(path, data)
    local file = assert(io.open(path, 'wb'))
    file:write(data)
    file:close()
end

local function upperFirst(word)
    return (word:gsub('^.', string.upper))
end

local function generateFuncName(filePath)
    local r = {}
    for word in filePath:gsub('%.lua$', ''):gmatch('[%w]+') do
        table.insert(r, upperFirst(word))
    end
    return table.concat(r)
end

local function generateAPI(file, name)
    name = name:gsub('.lua', '')

    local files = {
        UnitObjEditing = 'w3u',
        ItemObjEditing = 'w3t',
        DestructableObjEditing = 'w3b',
        BuffObjEditing = 'w3h',
        AbilityObjEditing = 'w3a',
        UpgradeObjEditing = 'w3q',
    }

    if not files[name] then
        return
    end

    local o = io.open(file)
    local lua = o:read('a')
    o:close()

    local apis = {}

    local lastfunc
    local lastClass
    for i, line in ipairs(string.split(lua, '\n')) do
        if string.startswith(line, '_G.') then
            lastClass = line:split(' ')[3]
        elseif string.find(line, 'function') then
            lastfunc = string.gsub(string.gsub(line, 'function %w+:', ''), '%(.*%)', '')
        elseif string.find(line, '^end') then
            lastfunc = nil
        elseif string.find(line, 'self.def:') then
            local k = string.gsub(line, '.*%(\'(%w+).*', '%1')
            apis[k] = {cls = lastClass, func = lastfunc}
        end
    end

    local lines = {'return {'}
    for key, value in pairs(apis) do
        table.insert(lines, string.format('["%s"]={cls="%s", func="%s"},', key, value.cls, value.func))
    end
    table.insert(lines, '}')
    local ret = table.concat(lines, '\n')
    return files[name], ret
end

local function main(input, output)
    local filePath = input:match('src/lua/(.+)$')
    local fileName = input:match('/([^/]+)$')
    local funcName = generateFuncName(filePath)
    local code = string.dump(assert(loadfile(input)))
    local len = #code

    local api
    local defType
    if string.endswith(fileName, 'ObjEditing.lua', true) then
        local t, c = generateAPI(input, fileName)
        if t and c then
            defType = t
            api = string.dump(assert(load(c)))
        end
    end

    do
        local n = 0
        local function conv(x)
            local r = string.format('0x%02X', string.byte(x)) .. ', '
            n = n + 1
            if n % 16 == 0 then
                n = 0
                return r .. '\n    '
            else
                return r
            end
        end

        code = code:gsub('.', conv)
        if api then
            n = 0
            api = api:gsub('.', conv)
        end
    end

    local h = string.format(hTemplate, funcName)
    local c = string.format(cTemplate, code, api or 0, funcName, len, filePath, api and #api or 0, filePath,
                            defType or 'NONE')

    writeFile(output .. '/' .. fileName .. '.cpp', c)
    writeFile(output .. '/' .. fileName .. '.h', h)
end

main(arg[1], arg[2])
