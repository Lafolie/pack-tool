local colors = require "etc.colors"

return function(text, x, y, color)
	love.graphics.setColor(0, 0, 0, 0.6)
	love.graphics.print(text, x + 1, y + 1)
	love.graphics.setColor(color or colors.white)
	love.graphics.print(text, x, y)
end