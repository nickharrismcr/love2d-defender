require "game/util"
local PlayerSystem = class("PlayerSystem", System)

PlayerSystem.states={}

function PlayerSystem:initialize()

	System.initialize(self)
end

function PlayerSystem:register(list)
	for i,name in pairs(list) do
		local fn=require("states/player/"..name)
		if not fn then error("missing state definition for "..name) end
		self.states[name]=fn
	end
end

function PlayerSystem:update(dt)

	for index, entity in pairs(self.targets) do
		local ai=entity:get("Player") 
		local pos=entity:get("Position") 
		local world=entity:get("World")
		ai.fsm:update(ai,world,entity,dt)
		ai.t = ai.t + 1
	end
end


function PlayerSystem:playerCollide(event)

	assert(event.entity.name=="Human")
	local ai=event.entity:get("AI")
	if ai.fsm.state=="falling" then 
		ai.fsm:setState("rescued")
		self.engine.eventManager:fireEvent(HumanRescued(event.entity))
	end
end

function PlayerSystem:killEvent(event)
	for index, value in pairs(self.targets) do
		local ai=value:get("Player") 
		ai.fsm:setState("die")
	end
end

function PlayerSystem:requires()
	return {"Player"} 
end

return PlayerSystem
