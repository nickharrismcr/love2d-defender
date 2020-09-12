

require "game/util"

local state={}

function state:enter(ai,world,entity,dt)
	entity:addMultipleTags({"Shootable","Deadly"})
end

function state:update (ai,world,entity,dt)

end


return state
