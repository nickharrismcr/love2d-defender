function pixeldraw_disperse(x,y,graphic,frame,disperse,pixsize,col)

	assert (graphic.pixels)
	assert (frame)
	assert (disperse)
	assert (pixsize)

	local xp=graphic.xpixels
	local yp=graphic.ypixels
	local ps=pixsize
	local sw=xp*ps
	local sh=yp*ps
	local pix = ps
	if disperse > 1 and xp > 5 then pix=ps*2 end

	if frame > #graphic.pixels then frame = #graphic.pixels end

	local lp=graphic.pixels[frame]

	for i = 1,xp do
		for j = 1,yp do
			dbg(lp[j][i])
			local r,g,b,a = unpack(lp[j][i])
			if col then 
				r=add_wrap(r,col.r)
				g=add_wrap(g,col.g)
				b=add_wrap(b,col.b)
			end
			local xx = x + disperse * (ps*i-sw/2)
			local yy = y + disperse * (ps*j-sh/2)
			dbg(r)
			love.graphics.setColor(r,g,b,a)
			love.graphics.rectangle("fill",xx,yy,pix,pix)
		end
	end
end

function pixeldraw(x,y,graphic,frame,pixsize)

	pixeldraw_disperse(x,y,graphic,frame,1,pixsize)
end
