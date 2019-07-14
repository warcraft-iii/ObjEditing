-- describe.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 7/10/2019, 9:22:06 PM

local pcall, print, assert = pcall, print, assert

function describe(name, callback)
    local _ENV = setmetatable({}, {__index = _G})
    local _beforeEach

    function beforeEach(task)
        _beforeEach = task
    end

    function it(name, callback)
        if _beforeEach then
            _beforeEach()
        end

        local ok, err = pcall(callback)
        if ok then
            print('Pass', name)
        else
            print('Fail', name, err)
        end
    end

    print('Start', name)

    callback(_ENV)

    print('Finish', name)
end

return describe
