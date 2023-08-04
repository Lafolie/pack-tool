local Pack = require "resource.pack"
local packList = require "etc.packList"
local typeIcons = require "etc.typeIcons"

local noIcon = love.graphics.newImage "assets/noIcon.png"

return function(ioChannel, pack)
	pack = Pack(pack)
	packList.add(pack):initMain(noIcon, typeIcons)
end