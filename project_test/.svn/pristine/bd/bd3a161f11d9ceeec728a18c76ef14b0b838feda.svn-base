
--[[
尾兽技能 
]]
local TailsSkillData = class("TailsSkillData") 
local GameTailsSkill = import(".GameTailsSkill") 

function TailsSkillData:ctor()
	self.dict = {}
	local cfg = GameConfig["skill_tails"]	-- 配置表 
	for k,v in pairs(cfg) do
		local skill = GameTailsSkill.new({id=k, cfg=v}) 
		self.dict[k] = skill 
	end
end

function TailsSkillData:getSkill(skillId)
	return self.dict[skillId]
end 

function TailsSkillData:getTailsSkill(tailsId, star)
	local arr = self:getTailsSkillList(tailsId)
	
	return arr[star]
end

function TailsSkillData:getTailsSkillList(tailsId)
	local arr = {} 
	for k,v in pairs(self.dict) do 
		if v.tailsId == tailsId then 
			table.insert(arr, v)
		end 
	end
	table.sort(arr, function(a, b)
		return tonumber(a.id) < tonumber(b.id)
	end)

	return arr 
end

-- 获取对应尾兽列表的技能id 
function TailsSkillData:getTailsSkillIdList(arrTailsId, arrStar) 
	local idList = {}
	for i,v in ipairs(arrTailsId) do 
		local star = arrStar[i]
		local skill = self:getTailsSkill(v, star)	    
		table.insert(idList, skill.id)
	end

	return idList 
end

return TailsSkillData
