
local TextDraw = class("TextDraw")

function TextDraw:initialize(texture,quad,color_func)

	self.texture = texture
	self.quad = quad 
	self.color_func= color_func
end

return TextDraw
