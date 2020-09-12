local StateTree = class("StateTree")

function StateTree:initialize()

	self.states={}
	self.transitions={}
	self.last_added=nil
end

function StateTree:addStates(path,names)

	for _,name in ipairs(names) do
		self:addState(path,name)
	end
end

function StateTree:addState(path,name)
	local fn=require(sf("%s/%s",path,name))
	self.states[name]=fn
	self.last_added=name
end

function StateTree:addTransition(from,to)

	if not self.transitions[from] then
		self.transitions[from]={}
	end
	self.transitions[from][to]=true
end

function StateTree:validTransition(from,to)

	if from==to then return true end

	if self.transitions[from] then
		if self.transitions[from][to] then
			return true
		end
	end
	return false
end

return StateTree
