-- main.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 7/10/2019, 9:19:09 PM
--
package.path = package.path .. ';./src/?.lua;./test/?.lua'

require('base')

dofile('test/describe.lua')

dofile('test/writebuffertest.lua')
dofile('test/readbuffertest.lua')
dofile('test/objectreadwrite.lua')
