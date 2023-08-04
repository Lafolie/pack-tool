local Pack = require "mainThread.resource.packMain"
local packList = require "etc.packList"
local typeIcons = require "etc.typeIcons"

local noIcon = love.graphics.newImage "assets/noIcon.png"

return function(ioChannel, pack)
	pack = Pack(pack, noIcon, typeIcons)
	packList.add(pack)
end