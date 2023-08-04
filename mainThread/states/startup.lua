local packList = require "etc.packList"
local paths = require "etc.paths"
local colors = require "etc.colors"

local startup = {}

function startup.enter(ioChannel)
	ioChannel:push {cmd = "discoverPacks", data = paths.packs}
end

function startup.leave()

end

function startup.update(ioChannel)
	if packList.getLoadProgress() == 1 then
		return "selectPack"
	end
end

function startup.keyPressed(key, shift)

end

function startup.mouseMoved(x, y)

end

function startup.mousePressed(btn, x, y)

end

function startup.draw(x, y, w, h)
	local loaded = packList.getLoadProgress()
	if loaded < 1 then
		for x = 0, 3 do
			love.graphics.setColor(colors.blue)
			love.graphics.rectangle("fill", 0, h - 4 + x, math.floor(w * loaded + x), 1)
			-- love.graphics.rectangle("fill", 0, h - 28, math.floor(w * loaded), 4)
		end
	end
end

function startup.getStatusText()
	return "Discovering resourcepacks..."
end

function startup.getHelpText()
	return string.format("%d%%", packList.getLoadProgress() * 100)
end

return startup