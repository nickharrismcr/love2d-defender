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



function TextSystem:addString(x,y,rate,str,align)

	self.string_index=self.string_index+1
	local color_func=getColorCycleFactory(rate)
	local ln=string.len(str)
	local width=ln*25
	if align and align=="center" then
		x=x-width/2
	end
	local quads={}
	local e=Entity()
	local tex=gl.graphics:getFontTexture()
	for i=1,ln do
		local c=string.sub(str,i,i)
		if not (c == " ") then
			local offset,_=string.find(self.chars,c)
			offset=(offset-1)*30
			local quad=love.graphics.newQuad(offset,0,self.width,self.height,tex:getWidth(),tex:getHeight())
			table.insert(quads,quad)
		else
			table.insert(quads,1)
		end
	end
	local td=TextDraw(tex,quads,color_func)
	local t=Text(x,y)
	e:add(td)
	e:add(t)
	self.engine:addEntity(e)
	self.strings[self.string_index]=e

	return self.string_index
end

function TextSystem:updateString(id,str)

	local e=self.strings[id]
	assert (e,sf("id %s not found",id))
	local ln=string.len(str)
	for i=1,ln do
		local c=string.sub(str,i,i)
		local offset,_=string.find(self.chars,c)
		offset=(offset-1)*30
		local d=e:get("TextDraw")
		d.quads[i]:setViewport(offset,0,self.width,self.height)
	end
end

function TextSystem:removeString(id)

	assert(self.strings[id],sf("Attempt to remove nonexistent id %s ",id))
	self.engine:removeEntity(self.strings[id])
	self.strings[id]=nil
end

function TextSystem:update(dt)

end


function TextSystem:requires()
	return {"Text"}
end

return TextSystem
