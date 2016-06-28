
local GameTrial = class("GameTrial") 

function GameTrial:ctor(params) 
	local cfg = params.cfg 
	self.id = cfg.id 

	self.name 			= cfg.Name 			-- 名称 
	self.limitTimes 	= checknumber(cfg.Trails_Times) 	-- 次数上限 
	self.info 			= "\t"..(cfg.Info or "")			-- 说明 	
	self.desc 			= cfg.Description 	-- 描述
	self.openDay 		= {} 				-- 开放时间
	local openDay 		= cfg.OpenDay 
	for i,v in ipairs(openDay) do
		table.insert(self.openDay, checknumber(v))
	end 

	self.overTimes = 0 	-- 通关次数 

end

function GameTrial:addTimes(times) 
	times = times or 1 
	self.overTimes = self.overTimes + times 
end 

function GameTrial:setTimes(times) 	
	self.overTimes = times 
end 

return GameTrial 