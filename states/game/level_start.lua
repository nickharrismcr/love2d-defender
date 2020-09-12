
local state={}
require "game/util"

-- dont set new states in enter functions!!!! will bypass enter function of new state
-- TODO fix
function state:enter(game,world,entity,dt)

	game.savet=nil
	if gl.level > 0 then
		game.savet=game.t
		local txtsys=gl.engine:getSystem("TextSystem")
		game.endtextid=txtsys:addString(500,300,1000,sf("ATTACK WAVE %s COMPLETED",gl.level))
	end
	gl.level=gl.level+1
	game.c=1
end

function state:update (game,world,entity,dt)

	if game.savet then
		if game.t > game.savet + 3 then
			game.fsm:setState("level")
			local txtsys=gl.engine:getSystem("TextSystem")
			txtsys:removeString(game.endtextid)
			game.savet=nil
		end
	else
		game.fsm:setState("level")
	end
end

return state