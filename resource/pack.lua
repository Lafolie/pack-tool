local image = require "love.image"
local Tex = require "resource.texSet"
local colors = require "etc.colors"
local shadowedText = require "etc.shadowedText"

local Pack = {}

local MOUNT_PATH = "mount/"

function Pack:init(name, path, type_)
	self.name = name
	self.path = path
	self.type = type_
	self.mountPath = self.type == "archive" and (MOUNT_PATH .. self.path) or self.path
	self.meta =
	{
		description = "",
		pack_format = "??",
		icon = false
	}
end

function Pack:initMain(defaultIcon)
	local font = love.graphics.getFont()

	self.nameText = shadowedText(font, {self:getTypeColor(), self.name})
	self.metaText = shadowedText(font,
	{
		colors.grey,  string.format("(%s)", self.meta.pack_format),
		colors.white, self.meta.description
	})

	self.icon = self.meta.icon and love.graphics.newImage(self.meta.icon) or defaultIcon
end

function Pack:draw(x, y)
	love.graphics.setColor(colors.white)
	if self.meta.icon then
		love.graphics.draw(self.icon, x, y, 0, 2, 2)
	end
	love.graphics.draw(self.nameText, x + 34, y - 1)
	love.graphics.draw(self.metaText, x + 34, y + 16)
end

function Pack:getTypeColor()
	return self.type == "dir" and colors.blue or colors.green
end

function Pack:isMounted()
	return self.type == "dir" or (self.type == "archive" and self.mounted)
end

function Pack:mount()
	if self.type == "archive" then
		if love.filesystem.mount(self.path, self.mountPath) then
			print("Mounted   " .. self.mountPath)
			self.mounted = true
		else
			print("ERROR: Could not mount " .. self.mountPath)
		end
	end
end

function Pack:unmount()
	if self.type == "archive" then
		if love.filesystem.unmount(self.path) then
			print("Unmounted " .. self.mountPath)
			self.mounted = false
		else
			print("ERROR: Could not unmount " .. self.mountPath)
		end
	end
end

function Pack:readMeta()
	local wasMounted = self:isMounted()
	if not wasMounted then
		self:mount()
	end

	local metaPath = self.mountPath .. "/pack.mcmeta"
	local iconPath = self.mountPath .. "/pack.png"
	
	if love.filesystem.getInfo(metaPath, "file") then
		print("Found meta for " .. self.name)
		local file = love.filesystem.read(metaPath)
		local description = file:match('"description":%s*(%b"")')
		local pack_format = file:match('"pack_format":%s*(%d+)[%s%c,]*')

		if description then
			self.meta.description = description:sub(2, -2)
		end

		if pack_format then
			self.meta.pack_format = pack_format
		end
	end

	if love.filesystem.getInfo(iconPath, "file") then
		self.meta.icon = image.newImageData(iconPath)
	end

	if not wasMounted then
		self:unmount()
	end
end

return setmetatable(Pack, {__call = function(_, a, ...)
	if type(a) == "table" then
		return setmetatable(a, {__index = Pack})
	else
		local t = setmetatable({}, {__index = Pack})
		t:init(a, ...)
		return t
	end
end})