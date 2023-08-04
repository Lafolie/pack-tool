local packList = require "etc.packList"
local Pack = require "resource.pack"
local xprint = require "etc.xprint"
local colors = require "etc.colors"

local insert = table.insert
local format, match = string.format, string.match

love.graphics.setDefaultFilter("nearest", "nearest")

local ioThread = love.thread.newThread "ioThread/main.lua"
local ioChannel = love.thread.getChannel "io"
local mainChannel = love.thread.getChannel "main"

local handlers = require "etc.loadHandlers" "mainThread/handlers"

local background = love.graphics.newImage "assets/bg.png"
background:setFilter("linear", "linear", 0)

local states = require "mainThread.states"
local currentState
local statusText, helpText

function love.load()
	ioThread:start()
	-- ioChannel:push {cmd = "discoverPacks", data = packsDir}
	currentState = states.startup
	currentState.enter(ioChannel)
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

	local newState = currentState:update()
	newState = states[newState]

	if newState and newState ~= currentState then
		currentState:leave()
		newState:enter(ioChannel)
		currentState = newState
	end

	statusText = currentState.getStatusText()
	helpText = currentState.getHelpText()
end

function love.draw()
	local loaded = packList.getLoadProgress()
	local w, h = love.graphics.getDimensions()
	love.graphics.draw(background, 0, 0, 0, w * 0.5, h * 0.5 )

	currentState.draw(0, 0, w, h - 32)

	love.graphics.setColor(colors.status.dark)
	love.graphics.rectangle("fill", 0, h - 32, w, 16)
	love.graphics.setColor(colors.status)
	love.graphics.rectangle("fill", 0, h - 16, w, 16)
	xprint(statusText, 4, h - 32, colors.status.light)
	xprint(helpText, 4, h - 16, colors.white)
end

function love.keypressed(key)
	local ctrl = love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")
	if key == "q" and ctrl then
		return love.event.push "quit"
	end

	currentState.keyPressed(key, ctrl)
end

function love.quit()
	ioChannel:supply {cmd = "shutdown"}
	-- ioThread:wait()
end