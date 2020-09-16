require "game/util"
require "events/PlayerHit"
require "events/WorldExplode"

local Game=require("components/update/Game")
local GameSystem = class("GameSystem", System)

function GameSystem:initialize()

	System.initialize(self)
	self.scores={
		Lander=150,
		Baiter=200,
		Bomber=250,
		Pod=1000,
		Swarmer=150
	}
end

function GameSystem:onAddEntity(entity) 

	self.game=entity:get("Game")
end

function GameSystem:update(dt)

	self.game.fsm:update(self.game,nil,entity,dt)
	self.game.t = self.game.t + dt
	gl.gamestate = self.game.fsm.state
end

function GameSystem:playerStartEvent(event)

	if gl.lives==0 then	
		self.game.fsm:setState("game_over")
	end

end
function GameSystem:checkCountsEvent(event)

	if event.name=="NPCKill" and event.entity:has("Human") then
		local aisys=gl.engine:getSystem("AISystem")
		local c=0
		for key,entity in pairs(aisys.targets) do
			if entity:has("Human") and entity:isActive() then c=c+1 end
		end
		log.trace(sf("Human count %s ",c))
		-- last one?
		if c==1 then
			gl.flash=48
			gl.worldstatus = WORLD_EXPLODING
			entity.eventManager:fireEvent(WorldExplode())
			local f = function() gl.sound:playMultiple("die") end
			f()
			for i=1,15 do
				gl.engine:schedule{f,randf(0,3),"time"}
			end
		end
	end


	local s=self.engine:getSystem("TextSystem")
	s:updateString(gl.score_id, sf("%07d",gl.score))
end

function GameSystem:forwardSoundEvent(event)

	if event.name=="NPCKill" then
		if event.entity.name=="Lander" then
			gl.sound:play("landerdie")
		end
		if event.entity.name=="Bomber" then
			gl.sound:play("bomberdie")
		end
		if event.entity.name=="Baiter" then
			gl.sound:play("baiterdie")
		end
	end
end

function GameSystem:updateScoreEvent(event)

	if event.name=="NPCKill" then
		local score=self.scores[event.entity.name]
		if score then gl.score=gl.score+score end
	end
	if event.name=="HumanSaved" then gl.score=gl.score+500 end
	if event.name=="HumanLanded" then gl.score=gl.score+250 end
	if event.name=="HumanRescued" then gl.score=gl.score+500 end

	local s=self.engine:getSystem("TextSystem")
	s:updateString(gl.score_id, sf("%07d",gl.score))
end

function GameSystem:requires()
	return {"Game"} 
end

return GameSystem
