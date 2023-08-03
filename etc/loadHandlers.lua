return function(path)
	print(string.format("Loading handlers in %s:", path))
	local handlers = {}
	local rpath = path:gsub("/", "%.") .. "."
	for _, file in ipairs(love.filesystem.getDirectoryItems(path, "file")) do
		local name = file:match "(.+)%.lua"
		if name then
			print(string.format("\t%s%s", rpath, name))
			handlers[name] = require(rpath .. name)
		end
	end

	return handlers
end