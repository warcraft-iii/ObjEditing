---@class Dummper
Dummper = class('Dummper')

function Dummper:constructor(defType)
    self.defType = defType
    self:prepareAPIs(defType)
end

function Dummper:prepareAPIs(defType)

    if not sourcecode[defType] then
        print('Not find APIs with', defType)
        return
    end

    self.file = io.open(string.format([[dump.%s.lua]], defType), 'w')

end

---@param defs table<string, Definition>
function Dummper:exec(defs)

    if not self.file then
        print('Not find APIs with', self.defType)
        return
    end

    local info = {}
    for id, def in pairs(defs) do
        local index = #info + 1
        local cls
        for k, v in pairs(def.fields) do
            if not sourcecode[self.defType][v.id] then
                print('Miss API with', self.defType, def.id, v.id, v.value)
            else
                local value = v.value
                if type(value) == 'string' then
                    if value ~= '' then
                        value = '[[' .. value .. ']]'
                    else
                        value = '""'
                    end
                end
                if v.level then
                    table.insert(info, string.format('u%s:%s(%s, %s)', def.id, sourcecode[self.defType][v.id].func,
                                                     v.level, value))
                else
                    table.insert(info, string.format('u%s:%s(%s)', def.id, sourcecode[self.defType][v.id].func, value))
                end
                cls = sourcecode[self.defType][v.id].cls
            end
        end

        if def.superId then
            table.insert(info, index, string.format('\nlocal u%s=%s:new("%s", "%s")', def.id, cls, def.id, def.superId))
        else
            table.insert(info, index, string.format('\nlocal u%s=%s:new("%s")', def.id, cls, def.id))
        end
    end

    table.insert(info, '\n')
    self.file:write(table.concat(info, '\n'))

end

