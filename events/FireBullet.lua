FireBullet = class("FireBullet")

function FireBullet:initialize(x,y,accuracy,speedmult,type_)
    self.name = "FireBullet"
    self.x=x
    self.y=y
	self.accuracy = accuracy or 1
	self.speedmult= speedmult or 1
	self.type_ = type_ or ""   
end
