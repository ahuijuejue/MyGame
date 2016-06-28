
local GameLight = class("GameLight") 

--[[
山多拉的灯 单个难度 
]]

function GameLight:ctor(params) 

	self.id = tostring(params.id) 				-- 配置id
	local enemyType = checknumber(params.type) 	-- 钟的类型。1.物理 2.魔法 
	self.formation 	= params.formation or {}	-- 钟的阵型 阵型数组
	
	local cfg = GameConfig["Trials_Gold"][self.id] 
	
	self.level 			= checknumber(cfg.Level) 			-- 开放等级 
	self.enemyLevel 		= checknumber(cfg.EnemyLevel) 		-- 敌人等级 
	self.limitTime 			= checknumber(cfg.Time) 			-- 关卡限制时间 
	self.gold1 				= checknumber(cfg.SmallGold) 		-- 小钟奖励 
	self.gold2 				= checknumber(cfg.MiddleGold) 		-- 中钟奖励 
	self.gold3 				= checknumber(cfg.LargeGold) 		-- 大钟奖励 
	self.overGold 			= checknumber(cfg.TotleGold) 		-- 全部通过奖励
	self.type 				= enemyType 						-- 钟的类型。1.物理 2.魔法

	local enemyIds
	if enemyType == 1 then 
		enemyIds 			= cfg.EnemyID1 						-- 敌人队伍1
	elseif enemyType == 2 then 
		enemyIds 			= cfg.EnemyID2 						-- 敌人队伍2
	end 
	local enemySize 		= cfg.EnemyVolume 					-- 钟的格数 

	self.enemySize = {} 	-- 钟的信息 
	for i,v in ipairs(enemyIds) do
		local size = checknumber(enemySize[i]) 
		table.insert(self.enemySize, {
			id 		= v,
			size 	= size,
			type 	= enemyType, 	-- 钟的类型。1.物理 2.魔法
		})
	end
end 

-- 获取钟的阵型 
function GameLight:getDataList() 
	local arr = {} 
	local preArr = {} 	
	for i,v in ipairs(self.formation) do
		local data = self.enemySize[checknumber(v)] 
		if data then 
			if data.size == 1 then 
				table.insert(preArr, data) 
				if table.nums(preArr) == 2 then 
					preArr = {} 					
				elseif table.nums(preArr) == 1 then 
					table.insert(arr, preArr) 
				end 
			else 				
				table.insert(arr, data)
			end 
		end 
	end 
	
	return arr 
end 




return GameLight 
