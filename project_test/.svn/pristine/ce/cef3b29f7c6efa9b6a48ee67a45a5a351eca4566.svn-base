--[[
单个城建建筑数据
]]

local GameCity = class("GameCity")

function GameCity:ctor(params)
	self.id = params.id 
	local cfg = params.cfg 
	
	self.star 	= checknumber(cfg.Quality) 	-- 星级
	self.items = {} 	-- 升星消耗物品
	for i,v in ipairs(cfg.NeedItemID or {}) do		
		table.insert(self.items, {
			id = v,
			num = checknumber(cfg.NeedItemNum[i]),
		})
	end

	self.nextCityId = cfg.ForItemID -- 下一星级id

	self.openSkill = {} -- 解锁的技能
	for i,v in ipairs(cfg.OpenSkill or {}) do
		self.openSkill[v] = true 
	end

end

function GameCity:isSkillOpen(skillId)
	return self.openSkill[skillId]
end

return GameCity

