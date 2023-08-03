local packList = require "etc.packList"

return function(ioChannel, num)
	packList.expect(num)
end