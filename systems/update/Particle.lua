
require "game/util"

local ParticleSystem = class("ParticleSystem", System)

function ParticleSystem:fireEvent(event)

	log.trace("fs fired")
	for index, value in pairs(self.targets) do
		local ai=value:get("Particle") 
		ai.x,ai.y=event.x,event.y
		log.trace(sf("particle fire %s %s",ai.x,ai.y))
		ai.system:emit(100)
	end
	return "PS fired"
end

function ParticleSystem:update(dt)

	for index, value in pairs(self.targets) do
		local ai=value:get("Particle") 
		ai.system:update(dt)
	end
end


function ParticleSystem:requires()
	return {"Particle"} 
end

return ParticleSystem
