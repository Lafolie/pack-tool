local colors = 
{
	white  = { 1.0,  1.0, 1.0, 1.0},
	grey   = { 0.6,  0.6, 0.6, 1.0},
	red    = { 0.9,  0.2, 0.5, 1.0},
	green  = { 0.2,  0.9, 0.5, 1.0},
	blue   = { 0.2, 0.58, 0.9, 1.0},
	shadow = { 0.0,  0.0, 0.0, 0.6},
	status = {0.05, 0.35, 0.3, 1.0},
}

local darken = 0.2
local lighten = 1.4

for k, color in pairs(colors) do
	if color ~= white and color ~= shadow then
		color.dark = {color[1] * darken, color[2] * darken, color[3] * darken, color[4]}
		color.light = {math.min(1, color[1] * lighten), math.min(1, color[2] * lighten), math.min(1, color[3] * lighten), color[4]}
	end
end

return colors