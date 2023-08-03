local Pack = require "resource.pack"

return function(mainChannel, packsDir)
	local items = love.filesystem.getDirectoryItems(packsDir)
	mainChannel:push {cmd = "numPackItems", data = #items}

	for _, name in ipairs(items) do
		local path = packsDir .. name
		local info = love.filesystem.getInfo(path)
		local type_ = info.type == "file" and "archive" or "dir"
		local pack = Pack(name, path, type_)
		pack:readMeta()
		mainChannel:push {cmd = "addPack", data = pack}
	end
end