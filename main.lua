local util = require "etc.util"
local Pack = require "resource.pack"

local insert = table.insert
local format, match = string.format, string.match

local packs = {}

local MOUNT_PATH = "zip/"
function love.load()
	local discovered = util.discoverPacks "packs/"
	print(format("Discovered %s potential packs:", #packs))
	for k, pack in ipairs(discovered) do
		local metaPath = pack.name
		if pack.isArchive then
			metaPath = MOUNT_PATH .. metaPath
			love.filesystem.mount(pack.path, metaPath)
		end

		local meta = util.readMeta(metaPath)
		print(format("\t%s\n\t\tType: %s\n\t\tDesc: %s\n\t\tFormat: %s", pack.name, (pack.isArchive and "archive" or "dir"), meta.description, meta.format))
	end
end

function love.draw()

end

function love.keypressed(key)
	local ctrl = love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")
	if key == "q" and ctrl then
		return love.event.push "quit"
	end
end