local image = require "love.image"

local Pack = class {}

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

return Pack