
log=require("lib/log")
require "game/util"

local Particle = class("Particle")

function Particle:initialize()

	self.system=love.graphics.newParticleSystem(love.graphics.newImage("assets/particle.png"))
	self.system:setColors(1,1,1,1, 1,1,1,1, 1,0,0,1, 1,0,0,0)
	self.system:setParticleLifetime(2)
	self.system:setLinearDamping(0,2)
	self.system:setLinearAcceleration(0,0,200,200)
	self.system:setRadialAcceleration(100,400)
	self.system:setSpeed(1,1000)
	self.system:setSpread(2*math.pi)
	self.system:setSizes(1,0.2)
	self.x=0
	self.y=0

end

return Particle
