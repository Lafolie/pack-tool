class = require "share.class"
local packList = require "etc.packList"
local Pack = require "mainThread.resource.packMain"
local xprint = require "etc.xprint"
local colors = require "etc.colors"

local insert = table.insert
local format, match = string.format, string.match

local ioThread = love.thread.newThread "ioThread/init.lua"
local ioChannel = love.thread.getChannel "io"
local mainChannel = love.thread.getChannel "main"

local handlers = require "share.loadHandlers" "mainThread/handlers"

local background = love.graphics.newImage "assets/bg2.png"
background:setFilter("linear", "linear", 0)

local states = require "mainThread.states"
local currentString
local statusText, helpString

function love.load()
	ioThread:start()
	-- ioChannel:push {cmd = "discoverPacks", data = packsDir}
	currentState = states.startup
	currentState:enter(ioChannel)
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

	local newState = currentState:update(ioChannel)
	newState = states[newState]

	if newState and newState ~= currentState then
		currentState:leave()
		newState:enter(ioChannel)
		currentState = newState
	end

	statustring = currentState:getStatusString()
	helpString = currentState:getHelpString()
end

function love.draw()
	local loaded = packList.getLoadProgress()
	local w, h = love.graphics.getDimensions()
	love.graphics.setColor(colors.grey)
	love.graphics.draw(background, 0, 0, 0, w / 512, h / 512)

	currentState:draw(0, 0, w, h - 32)

	love.graphics.setColor(colors.status.dark)
	love.graphics.rectangle("fill", 0, h - 32, w, 16)
	love.graphics.setColor(0.02, 0.1, 0.07, 1)
	love.graphics.line(0, h - 32, w, h - 32)
	love.graphics.setColor(colors.status)
	love.graphics.rectangle("fill", 0, h - 16, w, 16)
	love.graphics.setColor(colors.status.light)
	love.graphics.line(0, h - 16, w, h - 16)
	xprint(statustring, 4, h - 32, colors.status.light)
	xprint(helpString, 4, h - 16, colors.white)
end

function love.keypressed(key)
	local ctrl = love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")
	if key == "q" and ctrl then
		return love.event.push "quit"
	end

	currentState:keyPressed(key, ctrl)
end

function love.quit()
	ioChannel:supply {cmd = "shutdown"}
	-- ioThread:wait()
end