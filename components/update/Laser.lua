
local Laser = class("Laser")

function Laser:initialize()

	self.active=false 
	self.x=0
	self.y=0
	self.dir=1
	self.len=0
	self.alive=0
	self.gaps={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
end

return Laser
