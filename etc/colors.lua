local colors = 
{
	white  = {1.0, 1.0, 1.0, 1.0},
	grey   = {0.6, 0.6, 0.6, 1.0},
	green  = {0.3, 1.0, 0.5, 1.0},
	blue   = {0.3, 0.6, 1.0, 1.0},
	shadow = {0.0, 0.0, 0.0, 0.6}
}

for k, color in pairs(colors) do
	if color ~= white and color ~= shadow then
		color.dark = {color[1] * 0.1, color[2] * 0.1, color[3] * 0.1, color[4]}
	end
end

return colors