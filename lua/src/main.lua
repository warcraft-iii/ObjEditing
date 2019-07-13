-- init.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 7/12/2019, 1:27:11 PM

require('base')

local env = setmetatable({}, {__index = _G})

local files = {
    'object.lua', 'readbuffer.lua', 'writebuffer.lua', 'objectreader.lua', 'objectwriter.lua', 'application.lua',
}

for _, file in ipairs(files) do
    assert(loadfile('src/' .. file, nil, env))()
end
