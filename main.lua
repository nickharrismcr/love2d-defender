HooECS = require('lib/HooECS')
HooECS.initialize({ debug=true,gl=true })

require "game/init"
dbg=require("lib/debugger")
dbg.auto_where=15
gl={}

local engine
---------------------------------------------------------------------------
function love.load()

	io.stdout:setvbuf('no')
	math.randomseed(os.time())
	engine=initialise(gl)
end	
---------------------------------------------------------------------------
function love.update(dt)

	engine.camera:update(dt)
	engine:update(dt)
	log.flush()
end
---------------------------------------------------------------------------
function love.draw()

	love.graphics.setCanvas(gl.canvas)
	local col=gl.clearcol
	gl.effect(function()
		love.graphics.clear(col.r,col.g,col.b)
		engine:draw()	
	end)

	love.graphics.setCanvas()
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(gl.canvas,0,0)
	love.graphics.print(sf("%4.1f",love.timer.getFPS()),100,100)

	if gl.db1 then 
		love.graphics.print(sf("%d",gl.db1),100,150)
	end
	if gl.db2 then 
		love.graphics.print(sf("%d",gl.db2),100,170)
	end
	if gl.db3 then 
		love.graphics.print(sf("%d",gl.db3),100,190)
	end
	if gl.db4 then 
		love.graphics.print(sf("%d",gl.db4),100,210)
	end
	love.timer.sleep(1/70)
end
---------------------------------------------------------------------------
function love.keypressed(key, scancode, isrepeat)
   if key == "escape" then love.event.quit() end
   if key == "tab" then 
	  if gl.freeze then gl.freeze = false else gl.freeze = true end
   end
   if key == "1" then 
	  gl.debug=true 
   end
end
---------------------------------------------------------------------------
