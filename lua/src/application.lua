-- manager.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 7/12/2019, 2:42:12 PM

---@class Application
---@field typedDefinitions table<DefinitionType, table<string, Definition>>
Application = {}
Application.definitions = {}
Application.typedDefinitions = {}

function Application:init()
    self:initObjects()
    self:execute()
    self:saveObjects()
end

function Application:initObjects()
    local types = {'w3u', 'w3t', 'w3b', 'w3d', 'w3a', 'w3h', 'w3q'}

    for _, t in ipairs(types) do
        local name = [[/mnt/f/war3/WowTD/map.w3x/war3map.]] .. t
        local file = io.open(name, 'rb')
        if file then
            local data = file:read('*a')
            file:close()
            local reader = ObjectReader:new(t, data)
            local objects = reader:read()

            self.typedDefinitions[t] = objects

            for id, def in pairs(objects) do
                self.definitions[id] = def
            end
        end
    end
end

---@param id string
---@return Definition
function Application:getDefinition(id)
    return self.definitions[id]
end

---@param def Definition
function Application:register(type, def)
    self.typedDefinitions[type][def.id] = def
    self.definitions[def.id] = def
end

function Application:execute()
    -- body...
end

function Application:saveObjects()
    for t, defs in pairs(self.typedDefinitions) do
        local writer = ObjectWriter:new(t)
        writer:write(table.values(defs))
        io.open('1.w3u', 'w+'):write(writer:getBuffer())
    end
end

Application:init()

local registered = {}

---@param type DefinitionType
---@param id string
---@param superId string
function createDefinition(type, id, superId)
    if registered[id] then
        error('', 2)
    end

    local def = Application:getDefinition(id)
    if def and (def.superId ~= superId or def.type ~= type) then
        error('', 2)
    end

    registered[id] = true

    local obj = def and ObjectDefinition:from(def) or ObjectDefinition:new(type, id, superId)

    Application.definitions[obj.def.id] = obj
    Application.typedDefinitions[obj.def.type][obj.def.id] = obj

    return obj
end
