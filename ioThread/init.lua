class = require "share.class"
local ioChannel = love.thread.getChannel "io"
local mainChannel = love.thread.getChannel "main"
local handlers = require "share.loadHandlers" "ioThread/handlers"

--TODO: remove this
timer = require "love.timer"

while not shutdown do
	local msg = ioChannel:demand()

	local handler = handlers[msg.cmd]
	if handler then
		handler(mainChannel, msg.data)
	else
		print("ERROR: No handler for ioThread: " .. msg.cmd)
	end
end