require "game/util"
local FSM=require "game/fsm"

local PlayerSystem = class("PlayerSystem", System)

PlayerSystem.states={}

function PlayerSystem:initialize()

	System.initialize(self)
	local StateTree=require "game/statetree"
	player_states = StateTree()
	player_states:addStates("states/player",{"materialize", "play", "die", "explode"})
	player_states:addTransition("play","die")
	player_states:addTransition("die","explode")
	player_states:addTransition("explode","play")
	self.fsm=FSM("Player",player_states)
end

function PlayerSystem:update(dt)

	gl.engine.camera:update(dt)

	for index, entity in pairs(self.targets) do
		local ai=entity:get("Player") 
		local pos=entity:get("Position") 
		local world=entity:get("World")
		self.fsm:update(ai,world,entity,dt)
		ai.t = ai.t + 1
	end
end


function PlayerSystem:playerCollide(event)

	assert(event.entity.name=="Human")
	local ai=event.entity:get("AI")
	if ai.state=="falling" then 
		ai.next_state="rescued"
		self.engine.eventManager:fireEvent(HumanRescued(event.entity))
	end
end

function PlayerSystem:killEvent(event)
	for index, value in pairs(self.targets) do
		local ai=value:get("Player") 
		ai.next_state="die"
	end
end

function PlayerSystem:requires()
	return {"Player"} 
end

return PlayerSystem
