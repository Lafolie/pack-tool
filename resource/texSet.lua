local Tex = require "resource.tex"
local TexSet = {}

local padding = 32

function TexSet:init(pack, path)
	self.canvas = love.graphics.newCanvas()
	love.graphics.setCanvas(self.canvas)

	local w, h = self.canvas:getDimensions()
	local x, y, max = 0, 0, padding
	for k, name in ipairs(pack) do
		local tex = Tex(name, path)
		insert(self, tex)

		x = x + tex.w
		max = tex.h > max + 32 and tex.h + 32 or max

		if x > w then
			x = 0
			y = max
		end

		tex.x = x
		tex.y = y
		tex:draw()
	end

	love.graphics.setCanvas()
end

function TexSet:exportSheet(path)
	self.canvas:newImageData():encode("png", path)
end

function TexSet:split()

end

function TexSet:draw(x, y)
	love.graphics.draw(self.canvas(), x, y)
end

return setmetatable(TexSet, {__call = function(_, ...)
	local t = setmetatable({}, {__index = TexSet})
	t:init(...)
	return t
end})