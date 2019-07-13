-- object.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 7/10/2019, 4:39:42 PM

---@class FieldType
FieldType = {Int = 0, Real = 1, Unreal = 2, String = 3}

---@class DefinitionType
DefinitionType = {
    Unit = 'w3u',
    Item = 'w3t',
    Destructable = 'w3b',
    Buff = 'w3h',

    -- level
    Doodad = 'w3d',
    Ability = 'w3a',
    Upgrade = 'w3q',
}

---@class Filed
---@field id string
---@field type FieldType
---@field value any
---@field level number
---@field column number

---@class Definition
---@field id string
---@field superId string
---@field type DefinitionType
---@field fields table<string, Filed>

---@class ObjectDefinition: object
---@field def Definition
ObjectDefinition = class('ObjectDefinition')

function ObjectDefinition:constructor(type, id, superId)
    self.def = {}
    self.def.id = id
    self.def.superId = superId
    self.def.type = type
    self.def.fields = {}
end

function ObjectDefinition:from(def)
    def.fields = def.fields or {}
    self.def = def
end

---setRaw
---@private
---@param id string
---@param type FieldType
---@param value any
---@return void
function ObjectDefinition:setRaw(id, type, value)
    self.def.fields[id] = {id = id, type = type, value = value}
end

---setInt
---@param id string
---@param value integer
---@return void
function ObjectDefinition:setInt(id, value)
    return self:setRaw(id, FieldType.Int, value)
end

---setBoolean
---@param id string
---@param value boolean
---@return void
function ObjectDefinition:setBoolean(id, value)
    return self:setInt(id, value and 1 or 0)
end

---setString
---@param id string
---@param value string
---@return void
function ObjectDefinition:setString(id, value)
    return self:setRaw(id, FieldType.String, value)
end

---setReal
---@param id string
---@param value float
---@return void
function ObjectDefinition:setReal(id, value)
    return self:setRaw(id, FieldType.Real, value)
end

---setUnread
---@param id string
---@param value number
---@return void
function ObjectDefinition:setUnread(id, value)
    return self:setRaw(id, FieldType.Unreal, value)
end
