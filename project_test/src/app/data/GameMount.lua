
local GameMount = class("GameMount") 

--[[
庐山五老峰 单个难度 
]]

function GameMount:ctor(params) 

	self.id = tostring(params.id) 				-- 配置id
	local enemyType = checknumber(params.type) 	-- 钟的类型。1.物理 2.魔法 
	self.formation 	= params.formation or {}	-- 阵型 阵型数组
	
	local cfg = GameConfig["Trials_Skill"][self.id] 
	
	self.level 			= checknumber(cfg.Level) 			-- 开放等级 
	self.limitTime 			= checknumber(cfg.Time) 			-- 通关时间 
	self.type 				= enemyType 						-- 类型。1.物理 2.魔法

-------------------------------------------------
-- 奖励物品 
	function parseItem(value)
		return checknumber(value)
	end

	self.reward 	= {} 	-- 奖励物品 
	table.insert(self.reward, parseItem(cfg.SmallSkill))	-- 一重心魔 的奖励
	table.insert(self.reward, parseItem(cfg.MiddleSkill)) 	-- 二重心魔 的奖励
	table.insert(self.reward, parseItem(cfg.LargeSkill)) 	-- 三重心魔 的奖励
	
-------------------------------------------------
-- 心魔等级
	self.enemyLevel = {}
	for i,v in ipairs(cfg.EnemyLevel) do
		table.insert(self.enemyLevel, checknumber(v)) 	
	end  

end 

-- 获取阵型 id 数组 
function GameMount:getDataList() 
	local arr = {} 	
	for i,v in ipairs(self.formation) do
		if string.len(v) > 0 then 
			table.insert(arr, v)
		end 
	end 
	
	return arr 
end 

-- 获取 奖励灵能值 列表 
function GameMount:getRewardList() 	
	return self.reward  
end 

-- 获取 心魔等级 列表 
function GameMount:getLevelList() 
	return self.enemyLevel 
end 

-- 获取 阵型 人物变身后id 和 等级 
function GameMount:getHeroList() 
	local data = self:getDataList() 
	local arr = {} 
	for i,v in ipairs(data) do
	 	local level = self.enemyLevel[i] 
	 	local heroId = checknumber(v) + 1 
	 	heroId = tostring(heroId)
	 	table.insert(arr, {
	 		roleId 	= heroId,
	 		level 	= level,
	 	})
	end 
	return arr 
end 


return GameMount 
