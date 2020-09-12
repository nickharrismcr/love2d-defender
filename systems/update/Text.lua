require "game/util"

local TextSystem = class("TextSystem", System)
local Text=require("components/update/Text")
local TextDraw=require("components/draw/TextDraw")

function TextSystem:initialize()

	System.initialize(self)
	self.chars="0123456789:?ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	self.width=30
	self.height=28
	self.strings={}
	self.string_index=0
end

function TextSystem:add(x,y,character,color_func)

	local e=Entity()
	if not (character == " ") then
		local offset,_=string.find(self.chars,character)
		if (not offset) then return e end
		offset=(offset-1)*30
		local tex=gl.graphics:getFontTexture()
		local quad=love.graphics.newQuad(offset,0,self.width,self.height,tex:getWidth(),tex:getHeight())
		local td=TextDraw(tex,quad,color_func)
		local t=Text(x,y)
		e:add(td)
		e:add(t)
		self.engine:addEntity(e)
	end
	return e
end

function TextSystem:addString(x,y,rate,str,align)

	self.string_index=self.string_index+1
	local elist={}
	local color_func=getColorCycleFactory(rate)
	local ln=string.len(str)
	local width=ln*25
	if align and align=="center" then
		x=x-width/2
	end
	for i=1,ln do
		local c=string.sub(str,i,i)
		local e=self:add(x+(i*25),y,c,color_func)
		table.insert(elist,e)
	end
	self.strings[self.string_index]=elist
	return self.string_index
end

function TextSystem:updateString(id,str)

	local elist=self.strings[id]
	assert (elist,sf("id %s not found",id))
	local ln=string.len(str)
	assert(ln==#elist,sf ("%s <> %s ",ln,#elist))
	for i=1,ln do
		local c=string.sub(str,i,i)
		local offset,_=string.find(self.chars,c)
		offset=(offset-1)*30
		local c=elist[i]:get("TextDraw")
		c.quad:setViewport(offset,0,self.width,self.height)
	end
end

function TextSystem:removeString(id)

	assert(self.strings[id],sf("Attempt to remove nonexistent id %s ",id))
	for i,e in ipairs(self.strings[id]) do
		self.engine:removeEntity(e)
	end
	self.strings[id]=nil
end

function TextSystem:update(dt)

end


function TextSystem:requires()
	return {"Text"}
end

return TextSystem
