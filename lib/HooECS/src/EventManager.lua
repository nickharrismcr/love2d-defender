-- Getting folder that contains our src
local folderOfThisFile = (...):match("(.-)[^%/%.]+$")

local HooECS = require(folderOfThisFile .. 'namespace')
local EventManager = HooECS.class("EventManager")

log=require("lib/log")
require "game/util"

function EventManager:initialize()
    self.eventListeners = {}
end

-- Adding an eventlistener to a specific event
function EventManager:addListener(eventName, listener, listenerFunction)
    -- If there's no list for this event, we create a new one
    if not self.eventListeners[eventName] then
        self.eventListeners[eventName] = {}
    end

    if not listener.class or (listener.class and not listener.class.name) then
        HooECS.debug('Eventmanager: The listener has to implement a listener.class.name field.')
    end

    if type(listenerFunction) == 'function' then
		if not self.eventListeners[eventName][listener] then
			self.eventListeners[eventName][listener] = {}
		end
        table.insert(self.eventListeners[eventName][listener],listenerFunction)
    else
        HooECS.debug('Eventmanager: Third parameter has to be a function! Please check listener for ' .. eventName)
        if listener.class and listener.class.name then
            HooECS.debug('Eventmanager: Listener class name: ' .. listener.class.name)
        end
    end
end

-- Removing an eventlistener from an event
function EventManager:removeListener(eventName, listener)
    if self.eventListeners[eventName] then
		if self.eventListeners[eventName][listener] then
            table.remove(self.eventListeners[eventName],listener)
            return
        end
        HooECS.debug(string.format("Eventmanager: Listener %s to be deleted on Event %s  is not existing.", listener.class.name, eventName))
    end
    HooECS.debug(string.format("Eventmanager: Event %s listener should be removed from is not existing ", eventName))
end

-- Firing an event. All registered listener will react to this event
function EventManager:fireEvent(event)

    local name = event.class.name
	HooECS.debug(sf("EventManager:fireEvent %s ",name))
    if self.eventListeners[name] then
        local returns = {}
		for instance,func_list in pairs(self.eventListeners[name]) do
			for i,func in ipairs(func_list) do 
				local val = func(instance, event)
				table.insert(returns, val)
			end
        end
        if #returns > 0 then
            if #returns == 1 then
                return returns[1]
            else
                return returns
            end
        end
    end
end

return EventManager
