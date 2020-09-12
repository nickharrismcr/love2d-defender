
local state={}
require "game/util"

function state:enter(game,world,entity,dt)

	local eng=gl.engine
	eng:stopSystem("NPCDrawSystem")
	eng:stopSystem("PlayerSystem")
	eng:stopSystem("PlayerDrawSystem")
	eng:stopSystem("WorldDrawSystem")
	eng:stopSystem("LaserDrawSystem")
	eng:stopSystem("StarDrawSystem")
	game.endt=game.t
	local txtsys=eng:getSystem("TextSystem")
	game.endtextid=txtsys:addString(550,300,1000,sf("GAME OVER PLAYER ONE",gl.level))
end

function state:update (game,world,entity,dt)

	if game.t > game.endt + 3 then
		love.event.quit()
		log.trace("quit")
	end

end

return state
