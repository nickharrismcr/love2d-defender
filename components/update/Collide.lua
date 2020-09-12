local Collide = class("Collide")

function Collide:initialize(graphic)


	self.box= {0,0,0,0}
	if graphic then 
		self.box=get_box(graphic)
	end
end

return Collide
