require "game/util"
require "events/PlayerHit"
require "events/NPCKill"
require "events/WorldExplode"

local AISystem = class("AISystem", System)

AISystem.states={}

function AISystem:initialize()

	System.initialize(self)
end

function AISystem:update(dt)

	for index, entity in pairs(self.targets) do

		local ai=entity:get("AI") 
		local world=entity:get("World")
		ai.fsm:update(ai,world,entity,dt)
		ai.t = ai.t + dt
	end
end

function AISystem:mutateAll(event)

	for key,entity in pairs(self.targets) do
		if entity:isActive() and entity.name=="Lander" then
			local ai=entity:get("AI") 
			if ai.fsm.state ~= "die" then
				ai.fsm:setState("mutant")
			end
		end
	end
end 

function AISystem:collideEvent(event)


	local pos=event.entity:get("Position")
	local draw=event.entity:get("NPCDraw")
	if draw.on_screen then
		event.entity:get("AI").fsm:setState("die")
		entity.eventManager:fireEvent(NPCKill(event.entity))
		event.entity:remove("Collide")
	end
end 

function AISystem:smartBombEvent()

	if gl.bombs==0 then return end
	gl.bombs=gl.bombs-1
	gl.flash=6
	local bomb = function ()
		for key,entity in pairs(self.targets) do
			if entity:isActive() and entity:has("Shootable") and not (entity.name == "Human") then
				local pos=entity:get("Position")
				local draw=entity:get("NPCDraw")
				if draw.on_screen then
					local ai=entity:get("AI") 
					ai.fsm:setState("die")
					entity.eventManager:fireEvent(NPCKill(entity))
				end
			end
		end
	end
	gl.engine:queue({bomb,3,"ticks"})
	gl.engine:queue({bomb,10,"ticks"})
end 


function AISystem:requires()
	return {"AI","World"} 
end

return AISystem
