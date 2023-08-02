local Tex = require "resource.texSet"
local Pack = {}

function Pack:init(t)
	self.name = name

	self.inputPath = string.format("img/%s/")
	self.outputPath = string.format("%s/")

	self.originals = TexSet(self, self.inputPath)
	self.edited = TexSet(self, self.outputPath)
end

function Pack:readMeta()

end

return setmetatable(Pack, {__call = function(config)
	local t = setmetatable(config, {__index = Pack})
	t:init()
	return t
end})