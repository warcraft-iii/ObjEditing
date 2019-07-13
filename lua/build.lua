-- build.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 7/13/2019, 9:50:37 PM

local template = [[
{
    constexpr unsigned char CODE[] = {
        %s
    };
    luaL_loadbuffer(L, (const char*)CODE, %s, "@%s");
    lua_call(L, 0, 0);
}
]]

local input = arg[1]
local output = arg[2]
local out
do
    local source = output:gsub('%.inc', '')
    local code = string.dump(assert(loadfile(input)))
    local n = 0
    out = code:gsub('.', function(x)
        local r = string.format('%3s', string.byte(x)) .. ','
        n = n + 1
        if n % 16 == 0 then
            n = 0
            return r .. '\n    '
        else
            return r
        end
    end)
    out = string.format(template, out, #code, source)
end

local file = assert(io.open(output, 'w+'))
file:write(out)
file:close()
