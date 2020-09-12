local state={}
function state:update (co,world,entity,dt)

	local draw=entity:get("PlayerDraw")
	draw.disperse = draw.disperse - 0.06
	if draw.disperse <= 1 then
		draw.disperse = 1
		co.fsm:setState("play")
	end
end

return state
