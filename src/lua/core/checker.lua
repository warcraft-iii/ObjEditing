-- checker.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 7/14/2019, 10:27:56 PM

local function itype(value)
    local t = type(value)
    if t == 'number' then
        return math.type(v)
    end
    return t
end

function checktype(value, checkType, api, index)
    local t = itype(value)
    if t == checkType then
        return
    end

    if checkType == 'float' and t == 'integer' then
        return
    end

    error(string.format([[bad argument #%s to '%s' (%s expected, got %s)]], index, api, checkType, t), 3)
end

local enumCache = setmetatable({}, {__index = function(t, k)
    local r = {}
    for _, v in pairs(k) do
        r[v] = true
    end
    t[k] = r
    return r
end})

function checkenum(value, enum, api, index)
    local e = _G[enum]
    if not e then
        return
    end
    if value == enumCache[e][value] then
        return
    end

    error(string.format([[bad argument #%s to '%s' (%s expected, got %s)]], index, api, enum, type(value)))
end
