local util = require "etc.util"
local packList = require "etc.packList"
local Pack = require "resource.pack"

local insert = table.insert
local format, match = string.format, string.match

love.graphics.setDefaultFilter("nearest", "nearest")

local packsDir = "packs/"

local ioThread = love.thread.newThread "ioThread/main.lua"
local ioChannel = love.thread.getChannel "io"
local mainChannel = love.thread.getChannel "main"

local handlers = require "etc.loadHandlers" "mainThread/handlers"


function love.load()
	ioThread:start()
	ioChannel:push {cmd = "discoverPacks", data = packsDir}
end

function love.update()
	while mainChannel:getCount() > 0 do
		local msg = mainChannel:pop()
		local handler = handlers[msg.cmd]
		if handler then
			handler(mainChannel, msg.data)
		else
			print("ERROR: No handler for mainThread: " .. msg.cmd)
		end
	end
end

function love.draw()
	local loaded = packList.getProgress()

	if loaded < 1 then
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth() * loaded, 64)
		-- return
	end

	love.graphics.print(loaded, 1, 1)
	love.graphics.setColor(1, 1, 1, 1)
	for k, pack in ipairs(packList) do
		local y = 4 + (k - 1) * 42
		local x = 4
		pack:draw(x, y)
	end
end

function love.keypressed(key)
	local ctrl = love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")
	if key == "q" and ctrl then
		return love.event.push "quit"
	end
end

function love.quit()
	-- ioChannel:supply {cmd = "shutdown"}
	-- ioThread:wait()
end