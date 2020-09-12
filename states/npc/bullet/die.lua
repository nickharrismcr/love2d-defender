local state={}

function state:enter(ai,world,entity,dt)
	gl.engine:removeEntity(entity)
end

function state:update()

end

return state
