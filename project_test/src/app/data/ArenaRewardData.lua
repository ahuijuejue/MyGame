

local ArenaRewardData = class("ArenaRewardData") 

function ArenaRewardData:ctor(params)
	self.id 		= params.id 
	local cfg 		= params.cfg 

	self.score 		= checknumber(self.id) 				-- 完成需要的积分

	self.items 		= {} 	-- 奖励的物品 

	for i,v in ipairs(cfg.AwardItemID or {}) do
		self.items[v] = checknumber(cfg.ItemNumber[i])
	end

	self.completed 	= false 	-- 是否已经领取过 
end 

function ArenaRewardData:isCompleted()
	return self.completed 
end 

function ArenaRewardData:getItemIcon()
	local item = ItemData:getItemConfig(self.itemId) 
	return item.imageName 
end 

function ArenaRewardData:getRewardList()
	local list = {} 

	for k,v in pairs(self.items) do
		table.insert(list, {
			icon 	= UserData:getItemIcon(k),
			border 	= UserData:getItemBorder(k),
			count 	= v, 
		})
	end	

	return list 
end 

return ArenaRewardData 
