log=require "lib/log"

sf=string.format

red={r=1,g=0,b=0}
blue={r=0,g=0,b=1}
green={r=0,g=1,b=0}
yellow={r=1,g=1,b=0}
cyan={r=0,g=1,b=1}
orange={r=0.8,g=0.4,b=0}
purple={r=0.5,g=0,b=1}
magenta={r=1,g=0,b=1}
dgreen={r=0,g=0.5,b=0}
grey={r=0.5,g=0.5,b=0.5}

function getColorCycleFactory(frames)

	local col_list={red,blue,purple,yellow}
	local ind=1
	local col={r=1,g=0,b=0}
	local dr=0
	local dg=0
	local db=0
	local tc=frames

	function _closure(dt)

		tc=tc+420*dt
		gl.db1=tc
		col.r=col.r+dr
		col.g=col.g+dg
		col.b=col.b+db
		if tc>=frames then
			tc=0
			nextcol=col_list[(ind+1)%4+1]	
			ind=ind+1
			dr=2*(nextcol.r-col.r)/frames
			dg=2*(nextcol.g-col.g)/frames
			db=2*(nextcol.b-col.b)/frames
		end
		return col
	end

	return _closure
end
-------------------------------------------------------------------------------------------------------
function add_wrap(a,b)

	local c=a+b
	if c>1 then c=c-1 end
	return c
end
-------------------------------------------------------------------------------------------------------

function colors(n)
	local cols={green,orange,blue,yellow,red,purple,dgreen,grey}
	return cols[1+n%8]
end

-------------------------------------------------------------------------------------------------------
function rand_col()
	return { r=math.random(),
			g=math.random(),
			b=math.random(),
			a=math.random()
	}
end

-------------------------------------------------------------------------------------------------------
function rand_delta(range)

	local min=range[1]
	local max=range[2]
	local x=math.random()
	local y=math.random()
	local bv=math.sqrt(x*x+y*y)

	local dx=min+(x*(max-min))
	local dy=min+(y*(max-min))

	if coin(0.5)
	then
		dx=-dx
	end
	if coin(0.5)
	then
		dy=-dy
	end
	return {x=dx,y=dy,v=bv}
end

---------------------------------------------------------------------------
function HSL(h, s, l)
    if s == 0 then return l, l, l end
    local function to(p, q, t)
        if t < 0 then t = t + 1 end
        if t > 1 then t = t - 1 end
        if t < .16667 then return p + (q - p) * 6 * t end
        if t < .5 then return q end
        if t < .66667 then return p + (q - p) * (.66667 - t) * 6 end
        return p
    end
    local q = l < .5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    return {r=to(p, q, h + .33334), g=to(p, q, h), b=to(p, q, h - .33334)}
end
---------------------------------------------------------------------------
function distance(x1,y1,x2,y2)

	local x=x2-x1
	local y=y2-y1
	return math.sqrt(x*x+y*y)

end
---------------------------------------------------------------------------
function rand_choice(tab)
	sel=math.random(1,#tab)
	return tab[sel]
end
---------------------------------------------------------------------------
function randf(min,max)

	return min+(math.random()*(max-min))
end
---------------------------------------------------------------------------
function round(x,y,r)

	x=math.floor(x/r)
	y=math.floor(y/r)
	x=x*r
	y=y*r
	return x,y
end
---------------------------------------------------------------------------
function get_dir(dir)

	return math.cos(dir),math.sin(dir)
end
	
---------------------------------------------------------------------------
function intersect(x1,x2,w)

	return (math.abs(x1-x2) < w )
end
---------------------------------------------------------------------------
function box_translate(box,x,y)

	return {box[1]+x,box[2]+y,box[3]+x,box[4]+y}
end
---------------------------------------------------------------------------
function get_box(graphic)  -- x1,y1,x2,y2

	return { -graphic.xpixels*gl.pixsize/2, -graphic.ypixels*gl.pixsize/2, graphic.xpixels*gl.pixsize/2, graphic.ypixels*gl.pixsize/2 } 
end
---------------------------------------------------------------------------
function box_collision( box1,box2,offset1)

	local offs=offset or 0

	local b1x1,b1y1,b1x2,b1y2 = unpack(box1)
	local b2x1,b2y1,b2x2,b2y2 = unpack(box2)

	local left = math.max(b1x1+offs,b2x1)
	local top = math.max(b1y1,b2y1)
	local right = math.min(b1x2+offs,b2x2)
	local bottom = math.min(b1y2,b2y2 )

	return left < right and top < bottom
end
---------------------------------------------------------------------------
function collision( b1x1,b1y1,b1x2,b1y2,b2x1,b2y1,b2x2,b2y2 )

	local left = math.max(b1x1,b2x1)
	local top = math.max(b1y1,b2y1)
	local right = math.min(b1x2,b2x2)
	local bottom = math.min(b1y2,b2y2 )

	return left < right and top < bottom
end
---------------------------------------------------------------------------
function coin(weight)

	return (math.random() < weight)
end
---------------------------------------------------------------------------
function choice(list)

	return list[math.random(1,table.getn(list))]
end
---------------------------------------------------------------------------
function t(tab,...)

	dbg.pretty_depth=10
	return dbg.pretty(tab)
end
------------------------------------------------------------------------
function tt(tab)

	dbg.pretty_depth=1
	return dbg.pretty(tab)
end
-------------------------------------------------------------------------------------------------------
function sign(number)

    return number > 0 and 1 or number == 0 and 0 or -1
end

-------------------------------------------------------------------------------------------------------
function clamp(value,min,max)

	if value < min then return min end
	if value > max then return max end
	return value

end
-------------------------------------------------------------------------------------------------------
function calc_fire( px,py, ps, sx, sy , accuracy, t,dt ) 
        
	-- px,py = player pos
	-- ps = player speed pixels/sec
	-- sx,sy = start pos
	-- accuracy 0 to G1
	-- t = bullet time in seconds
	-- projected player x pos after t seconds
	--
	local tx=px+ps*t
	local ty=py

    local xdist=tx-sx
    local ydist=ty-sy

	local dx=accuracy*xdist/t
	local dy=accuracy*ydist/t

    return dx,dy
end
