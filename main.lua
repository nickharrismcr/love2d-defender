HooECS = require('lib/HooECS')
HooECS.initialize({ debug=true,gl=true })

require "game/initgame"
require "game/intro"
require "game/initeffect"

dbg=require("lib/debugger")
dbg.auto_where=15
gl={}

local engine
local state
local effect
---------------------------------------------------------------------------
function love.load()

	io.stdout:setvbuf('no')
	math.randomseed(os.time())
	intro=Intro()
	engine=init_game(gl)
	effect=init_effect()
	states={intro,engine}
	gl.state=1
end	
---------------------------------------------------------------------------
function love.update(dt)

	states[gl.state]:update(dt)
end
---------------------------------------------------------------------------
function love.draw()

	love.graphics.setCanvas(gl.canvas)
	local col=gl.clearcol
	effect(function()
		love.graphics.clear(col.r,col.g,col.b)
		states[gl.state]:draw()	
	end)
	love.graphics.setCanvas()
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(gl.canvas,0,0)

	--debug_draw()
end
---------------------------------------------------------------------------
function love.keypressed(key, scancode, isrepeat)

   if key == "escape" then love.event.quit() end
   if key == "space" and gl.state==1 then gl.state=2 end
   if key == "6" then
	   if gl.freeze==false then gl.freeze=true else gl.freeze=false end
	end
end
---------------------------------------------------------------------------
function debug_draw()

	love.graphics.print(sf("%4.1f",love.timer.getFPS()),100,100)

	if gl.db1 then 
		love.graphics.print(sf("%s",gl.db1),100,150)
	end
	if gl.db2 then 
		love.graphics.print(sf("%s",gl.db2),100,170)
	end
	if gl.db3 then 
		love.graphics.print(sf("%s",gl.db3),100,190)
	end
	if gl.db4 then 
		love.graphics.print(sf("%s",gl.db4),100,210)
	end
end
