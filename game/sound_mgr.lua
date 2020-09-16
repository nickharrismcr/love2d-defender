Sound = class("Sound")

function Sound:initialize(data,loop,group)

	self.data=data
	self.sources={love.audio.newSource(data)}
	self.loop=false
	if loop then  
		self.loop=true
		self.sources[1]:setLooping(true)
	end
	self.group = group or 0
end

function Sound:isPlaying()
	for i,v in ipairs(self.sources) do
		if v:isPlaying() then return true end
	end
	return false
end

function Sound:playOne()

	for i,sound in ipairs(self.sources) do
		sound:stop()
	end
	self.sources[1]:play()
end

function Sound:playMany()

	for i,v in ipairs(self.sources) do
		if (not v:isPlaying()) then
			v:play()
			return
		end
	end
	table.insert(self.sources,love.audio.newSource(self.data))
	self.sources[#self.sources]:setLooping(self.loop)
	self.sources[#self.sources]:play()
end

function Sound:stop()

	for i,sound in ipairs(self.sources) do
		sound:stop()
	end
end

function Sound:setVolume(volume)

	for i,v in ipairs(self.sources) do
		v:setVolume(volume)
	end
end
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

SoundMgr = class("SoundMgr")
    
function SoundMgr:initialize()

   self.sounds={}
   self.groups={}
   self.mute=false

end
    
function SoundMgr:load(name, filename, looping, group)
        
    local sdata=love.sound.newSoundData(filename)
	local sound=Sound(sdata,looping,group)
	if group then
		if not self.groups[group] then
			self.groups[group]={}
		end
		table.insert(self.groups[group],sound)
	end
	self.sounds[name]=sound
end

function SoundMgr:isPlaying(name)

	if self.sounds[name] then
		return self.sounds[name]:isPlaying()
	end
	return false
end

function SoundMgr:play_func(name)

	log.trace(sf("soundmanager : return play func %s ",name))
	local f = function(self,event)
		log.trace(sf("soundmanager : play func %s %s %s",name,self,event))
		self:play(name)
	end
	return f

end
    
function SoundMgr:setVolume(name,volume)
	local s=self.sounds[name]
    if s then
		s:setVolume(volume)
	end
end

-- play if not playing
function SoundMgr:playIfNot(name)

    if self.mute then return end
	local s=self.sounds[name]
    if s then
		if not s:isPlaying() then
			s:playOne()
		end
	end
end

-- force play 
function SoundMgr:playMultiple(name)

    if self.mute then return end
	local s=self.sounds[name]
    if s then
		s:playMany()
	end
end

-- restart if already playing
-- stop other sounds in group
function SoundMgr:play(name)
        
    if self.mute then return end

	local s=self.sounds[name]
    if s then
		if s.group > 0 then
			for i,v in ipairs(self.groups[s.group]) do
				v:stop()
			end
		end
        s:playOne()
	end   
end           

function SoundMgr:stop(name)
        
	local s=self.sounds[name]
    if s then s:stop() end
end

function SoundMgr:stopall()
    
	for k,v in pairs(self.sounds) do
        v:stop()
	end
end

            
