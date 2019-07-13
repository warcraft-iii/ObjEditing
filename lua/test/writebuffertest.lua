-- buffertest.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 7/10/2019, 9:18:44 PM
--
local WriteBuffer = require('writebuffer')
local describe = require('describe')

describe('WriteBuffer', function(_ENV)
    local buf

    local function h(n)
        if not n then
            return #buf:getBuffer()
        end
        return buf:getBuffer():byte(n)
    end

    beforeEach(function()
        buf = WriteBuffer:new()
    end)

    it('should addString', function()
        buf:addString('hello world')
        assert(h() == 11)
        assert(h(1) == 0x68)
        assert(h(11) == 0x64)
    end)

    it('should addNewLine', function()
        buf:addNewLine()
        assert(h() == 2)
        assert(h(1) == 0x0d)
        assert(h(2) == 0x0a)
    end)

    it('should addChar', function()
        buf:addChar('A')
        assert(h() == 1)
        assert(h(1) == 65)
    end)

    it('should addInt', function()
        buf:addInt(0xa1b2c3d4)
        assert(h() == 4)
        assert(h(1) == 0xd4)
        assert(h(2) == 0xc3)
        assert(h(3) == 0xb2)
        assert(h(4) == 0xa1)
    end)

    it('should addShort', function()
        buf:addShort(14)
        assert(h() == 2)
        assert(h(1) == 0x0e)
        assert(h(2) == 0x00)
    end)

    it('should addFloat', function()
        buf:addFloat(1.234)
        assert(h() == 4)
        assert(h(1) == 0xb6)
        assert(h(2) == 0xf3)
        assert(h(3) == 0x9d)
        assert(h(4) == 0x3f)
    end)

    it('should addByte', function()
        buf:addByte(15)
        assert(h() == 1)
        assert(h(1) == 15)
    end)

    it('should addNullTerminator', function()
        buf:addNullTerminator()
        assert(h() == 1)
        assert(h(1) == 0)
    end)
end)
