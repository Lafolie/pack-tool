local Tex = {}

function Tex:init(name, path)
	self.name = name
	self.img = love.graphics.newImage(string.format("%s/%s", path, name))
	self.w, self.h = self.img:getDimensions()
	self.x = 0
	self.y = 0
end

function Tex:draw()
	love.graphics.draw(self.img, self.x, self.y)
end

return setmetatable(Tex, {__call = function(...)
	local t = setmetatable({}, {__index = Tex})
	t:init(...)
	return t
end})