local Pack = require "share.resource.pack"
local Tex = require "share.resource.texSet"
local colors = require "etc.colors"
local shadowedText = require "etc.shadowedText"

local PackMain = class (Pack) {}

function PackMain:init(data, noIcon, typeIcons)
	self.name = data.name
	self.path = data.path
	self.type = data.type
	self.mountPath = data.mountPath
	self.meta = data.meta

	local font = love.graphics.getFont()
	self.typeIcon = typeIcons[self.type]
	self.nameText = shadowedText(font, {self:getTypeColor().light, self.name})
	self.metaText = shadowedText(font,
	{
		colors.grey,  string.format("(%s)", self.meta.pack_format),
		colors.white, self.meta.description
	})

	self.icon = self.meta.icon and love.graphics.newImage(self.meta.icon) or defaultIcon
end

function PackMain:draw(x, y)
	love.graphics.setColor(colors.white)
	if self.meta.icon then
		love.graphics.draw(self.icon, x, y, 0, 2, 2)
	end
	love.graphics.draw(self.typeIcon, x + 35, y - 2)
	love.graphics.draw(self.nameText, x + 53, y - 1)
	love.graphics.draw(self.metaText, x + 34, y + 18)
end

function PackMain:getTypeColor()
	return self.type == "dir" and colors.blue or colors.green
end

return PackMain