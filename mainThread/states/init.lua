local states = {}
for _, item in ipairs(love.filesystem.getDirectoryItems "mainThread/states", "file") do
	local file = item:match "(.+)%.lua"
	if file and file ~= "init" then
		states[file] = require("mainThread.states." .. file)()
	end
end

return states