local State = require "etc.state"
local packList = require "etc.packList"

local SelectPack = class (State) {}

function SelectPack:init()
	self.cursorPos = 0
end

function SelectPack:enter(ioChannel)

end

function SelectPack:leave(ioChannel)

end

function SelectPack:update(ioChannel)

end

function SelectPack:keyPressed(key, shift)
	if key == "up" then
		self.cursorPos = (self.cursorPos - 1) % #packList
		return
	end

	if key == "down" then
		self.cursorPos = (self.cursorPos + 1) % #packList
		return
	end
end

function SelectPack:mouseMoved(x, y)

end

function SelectPack:mousePressed(btn, x, y)

end

function SelectPack:draw(x, y, w, h)
	love.graphics.setColor(0, 0, 0, 0.4)
	love.graphics.rectangle("fill", x, y, 268, h)
	love.graphics.setColor(1, 1, 1, 1)
	for k, pack in ipairs(packList) do
		local u = x + 6
		local v = y + 6 + (k - 1) * 44

		local color = pack:getTypeColor()

		
		love.graphics.setColor(color.dark)
		-- love.graphics.setColor(color[1], color[2], color[3], 0.75)
		love.graphics.rectangle("line", u, v, 256, 38, 2, 2)

		love.graphics.setColor(color.light)
		-- love.graphics.rectangle("line", u, v, 256, 20, 2, 2)

		love.graphics.setColor(color.dark)
		love.graphics.rectangle("fill", u, v, 256, 38, 2, 2)
		love.graphics.setColor(color[1], color[2], color[3], 0.1)
		love.graphics.rectangle("fill", u, v, 256, 19, 2, 2)
		
		if k - 1 == self.cursorPos then
			love.graphics.setBlendMode "add"
			love.graphics.setColor(0, 1, 1, 0.25)
			love.graphics.rectangle("fill", u, v, 256, 38, 2, 2)
			love.graphics.setColor(1, 1, 1, 0.5)
			love.graphics.rectangle("line", u, v, 256, 38, 2, 2)
			love.graphics.setBlendMode "alpha"
		end
		pack:draw(u + 3, v + 3)
	end
end


function SelectPack:getStatusString()
	return "Select Pack"
end

function SelectPack:getHelpString()
	return "Use WASD/arrow keys to select a pack. Enter or space to confirm. Esc to cancel."
end

return SelectPack