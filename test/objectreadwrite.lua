-- objectreadwrite.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 7/12/2019, 11:43:43 AM

require('core.object')
require('core.writebuffer')
require('core.objectwriter')
require('core.objectreader')

describe('ObjectReadWrite', function(_ENV)
    local data = string.char(0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x68, 0x63, 0x74,
                             0x77, 0x41, 0x30, 0x30, 0x31, 0x01, 0x00, 0x00, 0x00, 0x75, 0x6E, 0x61, 0x6D, 0x03, 0x00,
                             0x00, 0x00, 0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x57, 0x6F, 0x72, 0x6C, 0x64, 0x00, 0x00, 0x00,
                             0x00, 0x00)

    it('should write', function()
        local writer = ObjectWriter:new(DefinitionType.Unit)

        local def = {
            id = 'A001',
            superId = 'hctw',
            type = DefinitionType.Unit,
            fields = {unam = {id = 'unam', type = FieldType.String, value = 'HelloWorld'}},
        }

        writer:write({def})

        assert(writer:getBuffer() == data)
    end)

    it('should read', function()
        local reader = ObjectReader:new(DefinitionType.Unit, data)
        local definitions = reader:read()
        local def = definitions['A001']

        assert(def)
        assert(def.id == 'A001')
        assert(def.superId == 'hctw')
        assert(def.type == DefinitionType.Unit)

        local field = def.fields['unam']

        assert(field)
        assert(field.id == 'unam')
        assert(field.type == FieldType.String)
        assert(field.value == 'HelloWorld')
    end)
end)
