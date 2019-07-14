-- readbuffertest.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 7/10/2019, 11:19:50 PM

local ReadBuffer = require('core.readbuffer')
local describe = require('describe')

describe('ReadBuffer', function(_ENV)
    local data = string.char(table.unpack{
        0x57, 0x33, 0x64, 0x6f, -- char(4): "W3do"
        0x01, 0x00, 0x00, 0x00, -- int: 1
        0x00, 0x00, 0x9b, 0xc5, -- float: -4960
        0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x00, -- string: "WWWWWWW"
        0x02, -- byte: 2
    })

    local buf = ReadBuffer:new(data)

    it('should readString with length', function()
        assert(buf:readString(4) == 'W3do')
    end)

    it('should readInt', function()
        assert(buf:readInt() == 1)
    end)

    it('should readFloat', function()
        assert(buf:readFloat() == -4960)
    end)

    it('should readString', function()
        assert(buf:readString() == 'WWWWWWW')
    end)

    it('should readByte', function()
        assert(buf:readByte() == 2)
    end)
end)
