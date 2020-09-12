local World = class("World")

function World:initialize()

	self.points={}
	self.screenwidth=gl.ww
	self.worldwidth=gl.worldwidth
	self.dx=1
	local p=gl.wh-101
	local dp=-1
	local i = 0
	while true do

		i=i+1
		if i > self.worldwidth then
			if p > self.points[i-self.worldwidth] then break end
			self.points[i-self.worldwidth]=p
		else
			self.points[i]=p
		end
		p=p+dp
		if p > gl.wh-50 or p < gl.wh - 200 or coin(0.1) then
			dp = -dp
		end
	end
end

function World:at(x)

	if x > self.worldwidth then x = x - self.worldwidth end
	if x < 1 then x = x + self.worldwidth end
	return self.points[math.floor(x)]
end

return World
