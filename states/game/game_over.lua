
local state={}
require "game/util"

function state:enter(game,world,entity,dt)

	local eng=gl.engine
	eng:stopSystem("AISystem")
	eng:stopSystem("NPCDrawSystem")
	eng:stopSystem("PlayerSystem")
	eng:stopSystem("PlayerDrawSystem")
	eng:stopSystem("WorldDrawSystem")
	eng:stopSystem("LaserDrawSystem")
	eng:stopSystem("StarDrawSystem")
	game.endt=game.t
	local txtsys=eng:getSystem("TextSystem")
	game.endtextid=txtsys:addString(gl.ww/2,gl.wh/2,5000,sf("GAME OVER PLAYER ONE",gl.level),"center")
end

function state:update (game,world,entity,dt)

	if game.t > game.endt + 3 then
		love.event.quit()
		log.trace("quit")
	end

end

return state
