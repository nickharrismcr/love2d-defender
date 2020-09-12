
require "game/util"

local pixsize=5
local ParticleDrawSystem = class("ParticleDrawSystem", System)

function ParticleDrawSystem:draw(dt)

	for index, value in pairs(self.targets) do
		local ai=value:get("Particle")
		local camera=gl.engine.camera
		local translate=ai.x-camera.x
		if ai.x < (camera.x + gl.ww - gl.worldwidth) then
			translate=translate+gl.worldwidth
		end
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(ai.system,translate,ai.y)
	end
end

function ParticleDrawSystem:requires()
	return {"Particle","ParticleDraw", "Camera"}
end

return ParticleDrawSystem
