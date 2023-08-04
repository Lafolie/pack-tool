local State = require "etc.state"
local packList = require "etc.packList"
local paths = require "etc.paths"
local colors = require "etc.colors"

local Startup = class (State) {}

function Startup:enter(ioChannel)
	ioChannel:push {cmd = "discoverPacks", data = paths.packs}
end

function Startup:leave()

end

function Startup:update(ioChannel)
	if packList.getLoadProgress() == 1 then
		return "selectPack"
	end
end

function Startup:keyPressed(key, ctrl)

end

function Startup:mouseMoved(x, y)

end

function Startup:mousePressed(btn, x, y)

end

function Startup:draw(x, y, w, h)
	local loaded = packList.getLoadProgress()
	if loaded < 1 then
		for x = 0, 3 do
			love.graphics.setColor(colors.blue)
			love.graphics.rectangle("fill", 0, h - 4 + x, math.floor(w * loaded + x), 1)
			-- love.graphics.rectangle("fill", 0, h - 28, math.floor(w * loaded), 4)
		end
	end
end

function Startup:getStatusString()
	return "Discovering resourcepacks..."
end

function Startup:getHelpString()
	return string.format("%d%%", packList.getLoadProgress() * 100)
end

return Startup