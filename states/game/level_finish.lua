
local state={}
require "game/util"

function state:enter(game,world,entity,dt)

	local eng=gl.engine
	for k,v in pairs(eng:getEntitiesWithComponent("AI")) do
		if not (v.name == "Human") then 
			eng:removeEntity(v)
		end
	end
	--eng:stopSystem("AISystem")
	eng:stopSystem("NPCDrawSystem")
	eng:stopSystem("PlayerSystem")
	eng:stopSystem("PlayerDrawSystem")
	eng:stopSystem("WorldDrawSystem")
	eng:stopSystem("LaserDrawSystem")
	eng:stopSystem("StarDrawSystem")
	gl.player_pos.dx=0
	gl.player.speed=0
	game.time=game.t
end

function state:update (game,world,entity,dt)

	if game.t > game.time +  0.5 then
		game.fsm:setState("level_start")
	end
end

return state
