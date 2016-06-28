
local GameTails = import(".GameTails")
local TailsData = class("TailsData")

function TailsData:ctor()
	-- 尾兽信息
	self.arrList_ = {}
	self.dictList_ = {}
	for i,v in ipairs(table.keys(GameConfig.Tails_Star)) do
		local tails = GameTails.new({id=v})
		table.insert(self.arrList_, tails)
		self.dictList_[tails.id] = tails 
	end
	table.sort(self.arrList_, function(a, b)
		return a.openLv < b.openLv
	end)

end

--------------------------------------------
--------------------------------------------
-- 重置所有数据 
function TailsData:resetAllDatas()
	for k,v in pairs(self.dictList_) do
		v.star = 1	
	end
end 
--------------------------------------------
--------------------------------------------

function TailsData:createTails(id)
	return GameTails.new({id=v}) 
end 

function TailsData:getTails(id)
	return self.dictList_[id]
end

function TailsData:getTailsList()
	return self.arrList_
end
-- 获得解锁尾兽
function TailsData:getOpenTails()
	local arr = {}
	local level = SealData:getSealLevel()	
	for i,v in ipairs(self.arrList_) do
		if level >= tonumber(v.openLv) then 
			table.insert(arr, v)
		end 
	end
	return arr 
end

function TailsData:getTailsStarList(arrId)
	local list = {} 
	for i,v in ipairs(arrId) do
		local tails = self:getTails(v) 
		table.insert(list, tails.star)
	end
	return list 
end

-- 尾兽技能id列表
function TailsData:getTailsSkillIdList()
	local idList = UserData:getTailsBattleList()
	local starList = self:getTailsStarList(idList)
	return TailsSkillData:getTailsSkillIdList(idList, starList) 
end



return TailsData 








