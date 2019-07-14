-- manager.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 7/12/2019, 2:42:12 PM

---@class Application
Application = {}

function Application:init()
    self:initObjects()
    self:execute()
    self:saveObjects()
end

function Application:initObjects()
    for _, t in pairs(DefinitionType) do
        local name = [[/mnt/f/war3/WowTD/map.w3x/war3map.]] .. t
        local file = io.open(name, 'rb')
        if file then
            local data = file:read('a')
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

function Application:execute()
    -- body...
end

function Application:saveObjects()
    for defType, defs in pairs(TYPED_DEFINITIONS) do
        local writer = ObjectWriter:new(defType)
        writer:write(table.values(defs))
        io.open('1.w3u', 'w+'):write(writer:getBuffer())
    end
end

Application:init()
