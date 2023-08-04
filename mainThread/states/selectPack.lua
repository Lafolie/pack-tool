local packList = require "etc.packList"
local selectPack = {}

function selectPack.enter(ioChannel)

end

function selectPack.leave()

end

function selectPack.update(ioChannel)

end

function selectPack.keyPressed(key, shift)

end

function selectPack.mouseMoved(x, y)

end

function selectPack.mousePressed(btn, x, y)

end

function selectPack.draw(x, y, w, h)
	love.graphics.setColor(0, 0, 0, 0.4)
	love.graphics.rectangle("fill", x, y, 264, h)
	love.graphics.setColor(1, 1, 1, 1)
	for k, pack in ipairs(packList) do
		local u = x + 4
		local v = y + 4 + (k - 1) * 42

		love.graphics.setColor(pack:getTypeColor().dark)
		love.graphics.rectangle("fill", u, v, 256, 38, 2, 2)
		pack:draw(u + 3, v + 3)
	end
end


function selectPack.getStatusText()
	return "Select Pack"
end

function selectPack.getHelpText()
	return "Use WASD/arrow keys to select a pack. Enter or space to confirm. Esc to cancel."
end

return selectPack