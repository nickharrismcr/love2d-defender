
local TextDraw = class("TextDraw")

function TextDraw:initialize(texture,quads,color_func)

	self.texture = texture
	self.quads = quads
	self.color_func= color_func
end

return TextDraw
