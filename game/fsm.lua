local FSM = class("FSM")

function FSM:initialize(name,tree)

	self.statetree=tree 
	self.name=name
end

function FSM:setStateTree(tree)
	self.statetree=tree
end

function FSM:update(ai,world,entity,dt)

	if not (ai.next_state == ai.state) then
		if ai.state then
			assert(self.statetree:validTransition(ai.state,ai.next_state),sf("FSM %s : Illegal transition %s -> %s",self.name,ai.state,ai.next_state))
		end
		local save_next_state = ai.next_state
		local next_fn = self.statetree.states[ai.next_state]
		assert(next_fn,sf("FSM %s : No state for %s ",self.name,ai.next_state))
		if next_fn.enter then
			next_fn:enter(ai,world,entity,dt)
		end
		if not (save_next_state == ai.next_state) then 
			error(sf("Don't set new states in enter functions (%s)",ai.next_state))
		end
		if ai.state then
			log.trace(sf("FSM %s : transition %s to %s ",self.name,ai.state,ai.next_state))
		end
		ai.state=ai.next_state
	end
	assert (self.statetree.states[ai.state].update, sf("FSM %s : No update function in %s ",self.name,ai.state))
	self.statetree.states[ai.state]:update(ai,world,entity,dt)

end

return FSM
