local __class__
local metacache = setmetatable({}, {__mode = "k"})

local metaMethods =
{
	"__index", "__newindex", "__call",
	"__mode", "__metatable",
	"__tostring", "__concat",
	"__pairs", "__ipairs",
	"__add", "__unm", "__sub", "__mul", "__div", "__mod", "__pow",
	"__eq", "__lt", "__le" 
}

-- Utility Funcs ---------------------------------------------------------------

function is(self, other)
	local parent = getmetatable(self).__index
	return parent == other or (parent and _parent:is(other))
end

function typeof(self)
	return self._parent
end

-- Class -----------------------------------------------------------------------

local function classCall(t, ...)
	--get/create the mt for this class
	local meta = metacache[t]
	if not meta then
		meta = {}

		--check for metamethods
		for _, f in ipairs(metaMethods) do
			local method = t[f]
			if method then
				meta[f] = method
			end
		end

		local __index = meta.__index
		if __index and type(__index ) == "function" then
			--class supplied __index, so we need to wrap it
			local method = function(tbl, i)
				--IF YOU'RE HERE BECAUSE OF AN ERROR: Did you forget `self`?
				return __index(tbl, i) or t[i]
			end
			meta.__index = method
		else
			--no __index, so use direct lookup
			meta.__index = t
		end

		metacache[t] = meta
	end

	--instantiate
	local inst = setmetatable({}, meta)
	-- rawset(inst, "_parent", t)
	inst:init(...)
	return inst
end

__class__ = setmetatable(
	{
		init = function(self) end,

		is = is,

		typeof = typeof,
	},
	{
		__call = function(t, tbl)
			--check whether a parent was passed (new class definitions should not manually specify _parent!)
			if getmetatable(tbl) then --and tbl.__index then
				return function(newtbl)
					return setmetatable(newtbl, {__call = classCall, __index = tbl})
				end
			else
				--if not, the tbl passed was a new base class
				return setmetatable(tbl, {__call = classCall, __index = __class__})
			end
		end
	})

return __class__