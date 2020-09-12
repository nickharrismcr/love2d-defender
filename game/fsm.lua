local FSM = class("FSM")

function FSM:initialize(name,tree,init_state)

	self.statetree=tree 
	self.state=nil
	self.next_state=init_state or tree.last_added
	self.name=name
end

function FSM:setStateTree(tree)
	self.statetree=tree
end

function FSM:setState(state)

	if self.state then
		assert(self.statetree:validTransition(self.state,state),sf("FSM %s : Illegal transition %s -> %s",self.name,self.state,state))
	end
	self.next_state=state
end

function FSM:update(ai,world,entity,dt)

	if not (self.next_state == self.state) then
		local save_next_state = self.next_state
		local next_fn = self.statetree.states[self.next_state]
		assert(next_fn,sf("FSM %s : No state for %s ",self.name,self.next_state))
		if next_fn.enter then
			next_fn:enter(ai,world,entity,dt)
		end
		if not (save_next_state == self.next_state) then 
			error(sf("Don't set new states in enter functions (%s)",self.next_state))
		end
		if self.state then
			log.trace(sf("FSM %s : transition %s to %s ",self.name,self.state,self.next_state))
		end
		self.state=self.next_state
	end
	assert (self.statetree.states[self.state].update, sf("FSM %s : No update function in %s ",self.name,self.state))
	self.statetree.states[self.state]:update(ai,world,entity,dt)

end

return FSM
