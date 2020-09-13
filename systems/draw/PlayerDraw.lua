require "game/util"

local PlayerDrawSystem = class("PlayerDrawSystem", System)

local flashcols={{1,1,1,1},{1,0,0,1}}
local black={r=0,g=0,b=0}
local bombflashcols={red,blue,green,yellow,cyan,orange,purple,magenta}

function PlayerDrawSystem:draw()

	for index, value in pairs(self.targets) do

		local dt=love.timer.getDelta()
		local draw=value:get("PlayerDraw")
		if gl.flash > 0 then
			if gl.flash%2 == 0 then
				gl.clearcol=black
			else
				gl.clearcol=bombflashcols[gl.flash%8+1]
			end
			draw.flashcounter=draw.flashcounter+360*dt
			if draw.flashcounter > draw.flashtime then
				gl.flash = gl.flash - 1
				draw.flashcounter = 0
			end
		else
			gl.clearcol=black
		end
			
		if draw.hide then return end
		local pos=value:get("Position")
		local ai=value:get("Player")

		local g=draw.graphic
		local tg=draw.tgraphic
		local bg=draw.bgraphic
		local camera=gl.engine.camera
		local translate=pos.x-camera.x
		if pos.x < (camera.x + gl.ww - gl.worldwidth) then
			translate=translate+gl.worldwidth
		end
		local override_col = nil
		if draw.flash > 0 then 
			override_col = flashcols[draw.flash]
		end
		if gl.gamestate=="level" then
			self:DoDraw(gl.pixsize,translate ,pos.y,g , g.frame, draw.disperse, ai.dir, override_col)
			self:DoDrawRadar(ai,pos)

			if ai.thrust then
				self:DoDraw(gl.pixsize/1.5,translate-(30*ai.dir) , pos.y+5 , tg , tg.frame, 1, ai.dir)
			end
		end

		draw.t1=draw.t1+1
		draw.t2=draw.t2+1

		if draw.t1 > draw.ticks and g.frames > 1 and draw.disperse == 1 then
			draw.t1 = 0
			if g.frame == g.frames then
				g.frame= 1
			else
				g.frame = g.frame + 1
			end
		end
		if draw.t2 > draw.ticks and tg.frames > 1 and draw.disperse == 1 then
			draw.t2 = 0
			if tg.frame == tg.frames then
				tg.frame= 1
			else
				tg.frame = tg.frame + 1
			end
		end


		for i = 1, math.min(7,gl.lives) do
			self:DoDraw(2,i*40,80 ,g , g.frame, 1, 1 )
		end
		for i = 1, math.min(7,gl.bombs) do
			self:DoDraw(3,gl.radar_rect.x1-20,i*15,bg ,g.frame, 1, 1 )
		end
	end
end

function PlayerDrawSystem:DoDraw(pixsize,x,y,graphic,frame,disperse,dir,override_col)

	local xp=graphic.xpixels
	local yp=graphic.ypixels
	local ps=pixsize
	local sw=xp*ps
	local sh=yp*ps

	if frame > #graphic.pixels then frame = #graphic.pixels end

	local lp=graphic.pixels[frame]

	for i = 1,xp do
		for j = 1,yp do
			ind=i
			if dir == -1 then
				ind=xp+1-i
			end
			local r,g,b,a = unpack(lp[j][ind])
			if override_col and a > 0 then 
				r,g,b,a = unpack(override_col)
			end
			local xx = x + disperse * (ps*i-sw/2)
			local yy = y + disperse * (ps*j-sh/2)
			love.graphics.setColor(r,g,b,a)
			love.graphics.rectangle("fill",xx,yy,ps,ps)
			if a > 0 then
				love.graphics.setColor(r,g,b,0.05)
				love.graphics.rectangle("fill",xx-ps,yy-ps,ps*2,ps*2)
				love.graphics.rectangle("fill",xx-ps,yy-ps,ps*4,ps*4)
			end
		end
	end
end

function PlayerDrawSystem:DoDrawRadar(ai,pos)

	local rr=gl.radar_rect
	local radar_width=rr.x2-rr.x1
	local player_screen_x = pos.x - gl.cam_pos
	local radar_win_start=(gl.ww/2)-(gl.ww/2)*radar_width/gl.worldwidth

	local xp=radar_win_start+(player_screen_x * radar_width/gl.worldwidth)
	local yp=pos.y/8
	love.graphics.setColor(1,1,1,1)
	love.graphics.rectangle("fill",xp,yp,4,4)

end


function PlayerDrawSystem:requires()
	return {"Player","PlayerDraw", "Camera"}
end

return PlayerDrawSystem
