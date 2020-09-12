local keys={}

local mapping={
	up="q",
	down="a",
	reverse="space",
	thrust="]",
	fire="return",
	smartbomb="backspace",
	hyperspace="s"
}

local up = false 
local move = false 

function keys:isDown(action)

	return love.keyboard.isDown(mapping[action])
end

function keys:random(action)

	if coin(0.0005) then
		up = not up
	end
	if coin(0.0005) then
		move = not move
	end
	if action=="fire" then return coin(0.01) end
	if action=="up" then if up and move then return true end end
	if action=="down" then if not up and move then return true end end
	if action=="reverse" then return coin(0.001) end
	if action=="thrust" then return true end 
	return false
end

return keys
