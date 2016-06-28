
local GameHouse = class("GameHouse") 

--[[
精神时间屋 单个难度 
]]

function GameHouse:ctor(params) 

	self.id = tostring(params.id) 				-- 配置id
	local enemyType = checknumber(params.type) 	-- 钟的类型。1.物理 2.魔法 
	self.formation 	= params.formation or {}	-- 阵型 阵型数组
	
	local cfg = GameConfig["Trials_Exp"][self.id] 
	
	self.level 			= checknumber(cfg.Level) 			-- 开放等级 
	
	self.type 				= enemyType 						-- 类型。1.物理 2.魔法

-------------------------------------------------
-- 奖励物品
	function parseItem(idlist, countlist)
		local items = {} 
		for i,v in ipairs(idlist or {}) do
			local nCount = checknumber(countlist[i]) 
			items[v] = nCount 
		end
		return items 
	end

	self.reward 	= {} 	-- 奖励物品 
	table.insert(self.reward, parseItem(cfg.Alive1ItemID, cfg.Alive1ItemNum))	-- 存活1个人的奖励
	table.insert(self.reward, parseItem(cfg.Alive2ItemID, cfg.Alive2ItemNum)) 	-- 存活2个人的奖励
	table.insert(self.reward, parseItem(cfg.Alive3ItemID, cfg.Alive3ItemNum)) 	-- 存活3个人的奖励

	self.overReward = parseItem(cfg.Alive4ItemID, cfg.Alive4ItemNum) 			-- 全部存活奖励
	
-------------------------------------------------
-- 怪物 
	self.enemy1 	= {} 	-- 物理怪 
	table.insert(self.enemy1, cfg.enemy1_id) 	-- 1波物理怪
	table.insert(self.enemy1, cfg.enemy2_id) 	-- 2波物理怪
	table.insert(self.enemy1, cfg.enemy3_id) 	-- 3波物理怪

	self.enemy2 	= {} 	-- 魔法怪 
	table.insert(self.enemy2, cfg.m_enemy1_id) 	-- 1波魔法怪 
	table.insert(self.enemy2, cfg.m_enemy2_id) 	-- 2波魔法怪 
	table.insert(self.enemy2, cfg.m_enemy3_id) 	-- 3波魔法怪 

end 

-- 获取阵型 id 数组 
function GameHouse:getDataList() 
	local arr = {} 	
	for i,v in ipairs(self.formation) do
		if string.len(v) > 0 then 
			table.insert(arr, v)
		end 
	end 
	
	return arr 
end 




return GameHouse 
