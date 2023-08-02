local insert = table.insert

local util = {}

function util.readMeta(path)
	local metaPath = path .. "/pack.mcmeta"
	local iconPath = path .. "/pack.png"
	local meta = {}
	if love.filesystem.getInfo(metaPath, "file") then
		local file = love.filesystem.read(metaPath)
		local description = file:match('"description":%s*(%b"")')
		local pack_format = file:match('"pack_format":%s*(%b"")')

		meta.description = description and description:sub(2, -2) or ""
		meta.format = pack_format and format:sub(2, -2) or "??"
	end

	if love.filesystem.getInfo(iconPath, "file") then
		meta.icon = love.graphics.newImage(iconPath)
	end

	return meta
end

function util.discoverPacks(packsDir)
	local packs = {}

	for _, item in ipairs(love.filesystem.getDirectoryItems(packsDir)) do
		local path = packsDir .. item
		local info = love.filesystem.getInfo(path)
		
		if info.type == "directory" then
			insert(packs, {name = item, path = path})
		elseif info.type == "file" then
			local name = item:match("(.+)%.zip")
			if name then
				insert(packs, {name = name, path = path, isArchive = true})
			end
		end
	end

	return packs
end

return util