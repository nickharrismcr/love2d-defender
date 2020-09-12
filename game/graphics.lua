require "game/util"
require "game/pickle"
log=require "lib/log"

local smartbomb={[[
w.www..
.wwwvvv
w.www..
]],[[
w.www..
.www...
w.www..
]]}
local bomber={[[
.vvvvv
bbbbbv
bbbbbv
bbybbv
bbbbbv
bbbbb.
]],[[
.vvvvv
bbbbbv
byyybv
bybybv
byyybv
bbbbb.
]],[[
.vvvvv
yyyyyv
ybbbyv
ybbbyv
ybbbyv
yyyyy.
]]}
local swarmer={[[
..r..
.rrr.
rgrgr
.rrr.
]]}
local pod={[[
...y...
.b.m.b.
..mvm..
bmvmvmb
..mvm..
.b.m.b.
...y...
]],[[
...b...
.b.m.b.
..mvm..
ymvmvmy
..mvm..
.b.m.b.
...b...
]]}
local baiter={[[
..ggggggg..
.g.r..r..g.
g.y.yy.yyyg
.ggggggggg.
]],[[
..ggggggg..
.g..r..r.g.
g.yy.yy.yyg
.ggggggggg.
]]}

local thrust={[[
...r
..rr
.roo
rroo
roro
.ror
..rr
]],[[
...r
..rr
.roo
rroo
rror
.rro
..rr
]]}

local s250={[[
rrrr.yyyy.bbbb
...r.y....b..b
...r.y....b..b
rrrr.yyyy.b..b
r.......y.b..b
r.......y.b..b
rrrr.yyyy.bbbb
]],[[
bbbb.rrrr.yyyy
...b.r....y..y
...b.r....y..y
bbbb.rrrr.y..y
b.......r.y..y
b.......r.y..y
bbbb.rrrr.yyyy
]],[[
yyyy.bbbb.rrrr
...y.b....r..r
...y.b....r..r
yyyy.bbbb.r..r
y.......b.r..r
y.......b.r..r
yyyy.bbbb.rrrr
]]}
local s500={[[
rrrr.yyyy.bbbb
r....y..y.b..b
r....y..y.b..b
rrrr.y..y.b..b
...r.y..y.b..b
...r.y..y.b..b
rrrr.yyyy.bbbb
]],[[
bbbb.rrrr.yyyy
b....r..r.y..y
b....r..r.y..y
bbbb.r..r.y..y
...b.r..r.y..y
...b.r..r.y..y
bbbb.rrrr.yyyy
]],[[
yyyy.bbbb.rrrr
y....b..b.r..r
y....b..b.r..r
yyyy.b..b.r..r
...y.b..b.r..r
...y.b..b.r..r
yyyy.bbbb.rrrr
]]}

local player={[[
..hh...........
.hhhh..........
ghhhhh.........
.gmmhhhhhbby...
ghmmmmhhhhhhhwg
..mmm.wg.......
]],[[
..hh...........
.hhhh..........
ghhhhh.........
.gmmhhhhhybb...
ghmmmmhhhhhhhwg
..mmm.wg.......
]],[[
..hh...........
.hhhh..........
ghhhhh.........
.gmmhhhhhbyb...
ghmmmmhhhhhhhwg
..mmm.wg.......
]]}

local r_lander={[[
oo
pp
]]}

local r_mutant={[[
bb
pp
]],[[
mm
pp
]],[[
yy
pp
]]}

local r_human={[[
m
m
]]}

local r_bomber={[[
bb
mm
]]}

local r_pod={[[
rr
mm
]]}

local r_swarmer={[[
r
]]}

local r_baiter={[[
pp
]]}

local lander={[[
...ooo...
..pooop..
.pp.pp.p.
.pp.pp.p.
..popop..
..p.p.p.. 
.p..p..p. 
p...p...p 
]],[[
...ooo...
..pooop..
.p.pp.pp.
.p.pp.pp.
..popop..
..p.p.p.. 
.p..p..p. 
p...p...p 
]],[[
...ppp...
..ppppp..
.ppp.ppp.
.ppp.ppp.
..ppppp..
..p.p.p.. 
.p..p..p. 
p...p...p 
]]}

local mini_bullet={[[
w
]]}

local bomb={[[
.w.
www
.w.
]]}

local bullet={[[
w.w
.w.
w.w
]],[[
.w.
www
.w.
]]}

local human={[[
gg.
yg.
ygm
mrm
mrm
.r.
.r.
.r.
]]}

local mutant={[[
...mm....
..pmm.p..
.p.mmr.p.
.p.ryr.p.
..pryrp..
..p.y.p.. 
.p..y..p. 
p...y...p 
]],[[
...yy....
..pyy.p..
.p.yyr.p.
.p.rgr.p.
..prgrp..
..p.g.p.. 
.p..g..p. 
p...g...p 
]],[[
...cc....
..pcc.p..
.p.ccg.p.
.p.grg.p.
..pgrgp..
..p.r.p.. 
.p..r..p. 
p...r...p 
]],[[
...gg....
..pgg.p..
.p.ggc.p.
.p.cbc.p.
..pcbcp..
..p.b.p.. 
.p..b..p. 
p...b...p 
]]}

Graphics=class("Graphics")

function Graphics:initialize()

	self.list={}
	self:addSprites()

	local function pixelmap(x,y,r,g,b,a)
		if g<0.1 then a=0;r=0;g=0;b=0 else a=1; r=1; g=1; b=1 end
		return r,g,b,a
	end

	self.img=love.image.newImageData("assets/font.bmp")
	self.img:mapPixel(pixelmap)
	self.font=love.graphics.newImage(self.img)

	--self:saveData()
	--self:loadData()
end

function Graphics:saveData()

	local f=io.open("assets/gfx","w")
	io.output(f)
	io.write(pickle(self.list))
	io.close(f)
end

function Graphics:loadData()

	local f=io.open("assets/gfx","r")
	io.input(f)
	local s=io.read()
	io.close(f)
	self.list=unpickle(s)
end

function Graphics:getFontTexture()

	return self.font
end

function Graphics:addSprites()

	self.cols={
		r={1,0,0,1},
		o={0.8,0.5,0,1},
		g={0,1,0,1},
		p={0,0.5,0,1},
		b={0,0,1,1},
		y={1,1,0,1},
		c={0,1,1,1},
		m={1,0,1,1},
		v={0.4,0,1,1},
		w={1,1,1,1},
		h={0.5,0.5,0.5,1},
		x={0,0,0,0}}

	self:add("player",player)
	self:add("lander",lander)
	self:add("bullet",bullet)
	self:add("bomb",bomb)
	self:add("smartbomb",smartbomb)
	self:add("mini_bullet",mini_bullet)
	self:add("human",human)
	self:add("mutant",mutant)
	self:add("pod",pod)
	self:add("swarmer",swarmer)
	self:add("r_lander",r_lander)
	self:add("r_human",r_human)
	self:add("r_mutant",r_mutant)
	self:add("r_baiter",r_baiter)
	self:add("r_pod",r_pod)
	self:add("r_swarmer",r_swarmer)
	self:add("r_bomber",r_bomber)
	self:add("s500",s500)
	self:add("s250",s250)
	self:add("thrust",thrust)
	self:add("baiter",baiter)
	self:add("bomber",bomber)

end

function Graphics:add(name,data)

	pixels=self:getPixels(data)
	xpixels=#pixels[1][1]
	ypixels=#pixels[1]
	frames=#pixels
	self.list[name]={
		xpixels=xpixels,
		ypixels=ypixels,
		frame=1,
		frames=frames,
		pixels=pixels
	}
end

function Graphics:getPixels(data)

	local pixels={}
	for i,frame in ipairs(data) do
	   pixels[i]={}
	   c=0
	   for s in frame:gmatch("[^\r\n]+") do
		   c=c+1
		   pixels[i][c]={}
		   for ch in s:gmatch("[.a-z]") do
			   if ch == "." then ch = "x" end
			   table.insert(pixels[i][c],self.cols[ch])
		   end
	   end
	   if pixels[i]=={} then pixels[i]=nil end
	end
	return pixels 
end

function Graphics:get(name)

	local s=self.list[name]
	assert(s,sf("Graphics : %s not found",name))
	return s

end

