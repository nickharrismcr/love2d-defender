
local Position = class("Position")

function Position:initialize(x,y,dx,dy)

	self.x=x
	self.y=y
	self.dx=dx or 0
	self.dy=dy or 0
	self.ix=x
	self.iy=y
end

return Position
