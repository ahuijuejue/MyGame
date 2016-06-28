
--[[
尾兽信息

]]
local GameTails = class("GameTails")

function GameTails:ctor(options)
	-- body
	self.id = options.id 	
	local cfg = GameConfig.Tails_Star[self.id]
	self.name 		= cfg.TailsName 		-- 名字
	self.iconAni 	= cfg.TailsImg			-- 动画名
	self.icon 		= cfg.Icon 				-- 图片
	self.openLv 	= checknumber(cfg.OpenLevel) -- 解锁等级
	self.desc 		= "\t"..(cfg.TailsInfo or "") -- 描述


	self.skillName 	= "尾兽技能" 				-- 技能名
	self.skillId 	= cfg.TailsSkillID 		-- 尾兽技能id 
	self.chipsId 	= cfg.TailsCoinID 		-- 尾兽硬币itemId 
	self.useChips 	= { 					-- 升星需要的硬币数量
		0,
		tonumber(cfg.StarNum2),
		tonumber(cfg.StarNum3),
		tonumber(cfg.StarNum4),
		tonumber(cfg.StarNum5),
		tonumber(cfg.StarNum6),
		tonumber(cfg.StarNum7),
	}

	self.starMax = table.nums(self.useChips) -- 最大星级

	self.star = 1 	-- 当前星级		
end

-- 当前星级升星需要的碎片数
function GameTails:getChipsMax()
	if self.star >= 0 and self.star < self.starMax then 
		return self.useChips[self.star + 1] 
	end 
	return 0
end 

-- 当前尾兽硬币数量 
function GameTails:getChipsCount()
	local item = ItemData:getItem(self.chipsId)
	if item then 
		return item.count
	end 
	return 0
end 

-- 碎片数是否达到升星要求 
function GameTails:canLvup()
    if self.star >= self.starMax then 
        return false 
    elseif self:getChipsCount() < self:getChipsMax() then  
        return false 
    end 

    return true 
end 

-- 获得尾兽等级
function GameTails:getLevel()
	return self.star
end 

-- 获得尾兽技能列表 
function GameTails:getSkillList()
	return TailsSkillData:getTailsSkillList(self.id)
end 

return GameTails 











