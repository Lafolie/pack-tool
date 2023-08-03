local packList = {}

local expected = -1
local received = 0

function packList.expect(num)
	assert(expected < 0, "packList.expect called more than once!")
	expected = num
end

function packList.add(pack)
	table.insert(packList, pack)
	received = received + 1
	return pack
end

function packList.getProgress()
	return expected >= 0 and received / expected or 0
end

return packList