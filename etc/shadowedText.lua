local colors = require "etc.colors"

return function(font, elements)
	local txt = love.graphics.newText(font)
	local shadow = {}
	for k, v in ipairs(elements) do
		if k % 2 == 1 then
			shadow[k] = colors.shadow
		else
			shadow[k] = v
		end
	end

	txt:add(shadow, 1, 1)
	txt:add(elements)
	return txt
end