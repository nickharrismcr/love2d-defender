local state={}
require "game/util"

function state:enter(game,world,entity,dt)

	log.trace("level enter")
	local eng=gl.engine
	eng:startSystem("AISystem")
	eng:startSystem("NPCDrawSystem")
	eng:startSystem("PlayerDrawSystem")
	eng:startSystem("PlayerSystem")
	eng:startSystem("WorldDrawSystem")
	eng:startSystem("LaserDrawSystem")
	eng:startSystem("StarDrawSystem")

	eng:levelSet()
	eng:addLanders(gl.landers)
	eng:addPods(gl.pods)
	eng:addBombers(gl.bombers)

	if (gl.level-1) % 3 == 0 then
		eng:addHumans(gl.humans)
	end
	game.wave=1
	gl.landers_killed=0
	game.level_landers = gl.landers*gl.level_waves 
	gl.baiters=0
end

function state:update (game,world,entity,dt)

	if game.wave < gl.level_waves and game.t > gl.wave_delay then
		gl.engine:addLanders(gl.landers)
		game.t=0
		game.wave = game.wave + 1
	end
	if gl.lives > 0 and game.wave == gl.level_waves and gl.landers_killed == game.level_landers then
		game.fsm:setState("level_finish")
	end
	if game.wave == gl.level_waves and gl.landers_killed > game.level_landers - 3  and gl.baiters < gl.max_baiters then 
		gl.engine:addBaiter()
		gl.baiters = gl.baiters + 1
	end
	
	local c=0
	for k,v in pairs(gl.engine:getEntitiesWithComponent("AI")) do

		if v.name=="Lander" and v:isActive() then
			c=c+1
		end
	end

end

return state
