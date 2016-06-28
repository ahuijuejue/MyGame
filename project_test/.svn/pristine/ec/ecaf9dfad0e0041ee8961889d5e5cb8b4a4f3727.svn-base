--[[
单个任务信息
]]

local GameTask = class("GameTask")

function GameTask:ctor(params)	
	self.id 		= 	params.id 			-- 任务id
	self.taskType 	= 	params.taskType 	-- 任务类型
	self.completed 	= 	params.completed 	-- 是否已经结束
	self.per 		= 	params.per 			-- 任务完成度 
	local cfg 		= 	params.cfg 			-- 配置文件

	self.serverParams = 0 					-- 服务器获取的参数
--------------------------------------------------------------
		
	if self.taskType == "daily" then 		
		self.okParams1 	= 	cfg.FinishNumber 	-- 完成条件数值 
		self.okParams2 	= 	{} 						-- 完成条件其他数值
		if cfg.OtherCondition then 
			for k,v in pairs(cfg.OtherCondition) do
				self.okParams2[v] = true 
			end 
		end 	

	elseif self.taskType == "dailyTime" then 		
		self.okParams1 	= 	cfg.FinishNumber 	-- 完成条件数值 
		self.okParams2 	= 	cfg.CloseNumber 	-- 关闭时间
		
	elseif self.taskType == "achievement" then 		
		self.okParams1 	= 	cfg.FinishNumber1 	-- 完成条件数值 
		self.okParams2 	= 	cfg.FinishNumber2 	-- 完成条件其他数值
	end 	 
	
	----------------------------------------------------------
	self.cfgDes		= 	cfg.Description
	self.name 		= 	cfg.Name 				-- 任务名 
	self.desc 		= 	cfg.Description 		-- 任务描述 
	self.icon 		= 	cfg.Icon 				-- 图标 
	self.jumpCode 	= 	cfg.JumpUI 				-- 挑战至UI编号 
	self.okCode 	= 	tostring(cfg.FinishCondition) 	-- 完成条件编号 	
	self.openCode 	= 	tostring(cfg.OpenCondition) 		-- 开启条件编号 
	self.openParams = 	cfg.OpenNumber 			-- 开启条件参数
	self.border 	= 	"AwakeStone2.png" 		-- icon边框 
	self.params 	= 	{} 						-- 跳转场景的参数
	self.sort 		= 	checknumber(cfg.Sort) 	-- 排序 

	----------------------------------------------------------
	-- 奖励 
	-- self.gold 		= 	tonumber(cfg.AwardGold) or 0 		-- 奖励金币数量 
	-- self.diamond 	= 	tonumber(cfg.AwardDiamond) or 0 	-- 奖励宝石数量
	-- self.soul 		= 	tonumber(cfg.AwardSkill) or 0 		-- 奖励灵能数量 
	-- self.power 		= 	tonumber(cfg.AwardEnergy) or 0 		-- 奖励体力数量 
	-- self.teamExp 	= 	tonumber(cfg.AwardLeagueExp) or 0 	-- 奖励战队经验 
	self.items 		=   {} 	-- 奖励物品 
	self.heros 		= 	{} 	-- 奖励英雄 

	-------------------------------------------------------------
	---------- 数据处理
	-- 物品 
	local nItem = table.nums(cfg.AwardItemID or {})
	for i=1,nItem do
		table.insert(self.items,{itemId = cfg.AwardItemID[i], count = tonumber(cfg.ItemNumber[i])})
	end

	-- 英雄 
	local nHero = table.nums(cfg.AwardHeroID or {})
	for i=1,nHero do
		self.heros[cfg.AwardHeroID[i]] = tonumber(cfg.HeroNum[i])
	end
	
	-- 跳转场景参数
	if self.okParams1 then 
		table.insert(self.params, self.okParams1)
	end 
	if self.okParams2 then 
		table.insert(self.params, self.okParams2)
	end 	

end

------------------------------------------------
-- 是否已经结束
function GameTask:isCompleted()
	return self.completed
end 

function GameTask:compare(obj)
	local sort1 = self.sort 
	local sort2 = obj.sort 
	if sort1 > sort2 then 
		return 1 
	elseif sort1 == sort2 then 
		return 0 
	else 
		return -1
	end 
end

-----------------------------------------------------



return GameTask

