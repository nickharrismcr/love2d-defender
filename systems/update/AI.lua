require "game/util"
require "events/PlayerHit"
require "events/NPCKill"
require "events/WorldExplode"
FSM=require "game/fsm"

local AISystem = class("AISystem", System)


function AISystem:initialize()

	System.initialize(self)
	local statetrees=require "game/initstates"
	self.fsm={}
	for k,v in pairs(statetrees) do
		self.fsm[k]=FSM(k,v)
	end

end

function AISystem:update(dt)

	for index, entity in pairs(self.targets) do
		local ai=entity:get("AI") 
		local world=entity:get("World")
		dbg(self.fsm[ai.fsm])
		self.fsm[ai.fsm]:update(ai,world,entity,dt)
		ai.t = ai.t + dt
	end
end

function AISystem:mutateAll(event)

	for key,entity in pairs(self.targets) do
		if entity:isActive() and entity.name=="Lander" then
			local ai=entity:get("AI") 
			if ai.state == "search" or ai.state=="grabbing" or ai.state=="grabbed" then
				ai.next_state="mutant"
			else
				gl.engine:removeEntity(entity)
			end
		end
	end
end 

function AISystem:resetEvent()

	for index, entity in pairs(self.targets) do
		local ai=entity:get("AI") 
		if entity.name=="Human" and ai.state ~= "walking" then
			ai.next_state="walking"
		end
		if entity.name=="Lander" then
			if ai.state == "grabbing" or ai.state == "grabbed" then
				ai.next_state="search"
				if ai.human then ai.human = nil end
			end
		end
	end
end

function AISystem:collideEvent(event)

	local pos=event.entity:get("Position")
	local draw=event.entity:get("NPCDraw")
	if draw.on_screen then
		event.entity:get("AI").next_state="die"
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
				local draw=entity:get("NPCDraw")
				if draw.on_screen then
					local ai=entity:get("AI") 
					ai.next_state="die"
					entity.eventManager:fireEvent(NPCKill(entity))
				end
			end
		end
	end
	gl.engine:schedule({bomb,3,"ticks"})
	gl.engine:schedule({bomb,10,"ticks"})
end 


function AISystem:requires()
	return {"AI","World"} 
end

return AISystem
