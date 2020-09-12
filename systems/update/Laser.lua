require "game/util"
log=require "lib/log"

local Laser = class("Laser", System)

function Laser:initialize()
	System:initialize(self)
end

local fn=require("states/player/laser")

function Laser:update(dt)

	for index, value in pairs(self.targets) do
		local ai=value:get("Laser") 
		local pos=value:get("Position")
		if ai.active then
			fn:update(ai,world,value,dt)
			ai.alive = ai.alive + dt 
			if ai.alive > 2 then
				ai.active=false
				pos.y=-1000
			end
		end
	end
end

function Laser:requires()
	return {"Laser"}
end

return Laser
