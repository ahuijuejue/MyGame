--[[
开服活动 子数据
]]

local GameActivity = class("GameActivity")

function GameActivity:ctor(params)
	local cfg = params.cfg 

	self.id = params.id 

	self.subName 	= cfg.Name or "" -- 子分区名
	self.desc 		= cfg.Description or "" 	-- 描述
	self.sectionId 	= tostring(cfg.Tpye)		-- 主分区id
	self.subSectionId = tostring(cfg.Label)		-- 子分区id
	self.sort 		= checknumber(cfg.Sort) 	-- 排序
	self.jumpUI 	= checknumber(cfg.JumpUI) 	-- 跳转场景
	self.okCode 	= checknumber(cfg.FinishCondition) 	-- 完成代号
	self.okParam1 	= cfg.FinishNumber1 		-- 完成参数1
	self.okParam2 	= cfg.FinishNumber2 		-- 完成参数2
	self.items 		= {} 						-- 奖励物品 
	self.itemsDict 	= {}

	for i,v in ipairs(cfg.AwardItemID or {}) do
		local itemData = {
			id = v, 	-- 物品id
			count = checknumber(cfg.ItemNumber[i]), 	-- 物品数量
			quality = checknumber(cfg.AwardQuality[i]), -- 物品品质
		}
		table.insert(self.items, itemData)
		self.itemsDict[v] = itemData
	end

	self.completed 	= false 	-- 完成情况
	self.ok = false				-- 是否达成完成条件
	self.processLabel = "" 		-- 达成进度
end

-- 重置
function GameActivity:resetData()
	self.completed = false 
	self.ok = false 
	self.processLabel = ""
end 

------------------------------------------------
-- 是否已经结束
function GameActivity:isCompleted()
	return self.completed
end 

-- 是否达成完成条件
function GameActivity:isOk()
	return self.ok
end 

-- 达成进度字符串
function GameActivity:getProcessString()
	return self.processLabel
end 

-- 设置是否已经结束
function GameActivity:setCompleted(b)
	self.completed = b
	return self 
end 

-- 设置是否达成完成条件
function GameActivity:setOk(b)
	self.ok = b
	return self 
end 

-- 设置达成进度字符串
function GameActivity:setProcessString(txt)
	self.processLabel = txt
	return self 
end

-----------------------------------------------------

return GameActivity
