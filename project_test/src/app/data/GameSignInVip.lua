--[[
至尊签到单条数据
]]

local GameSignInVip = class("GameSignIn")

function GameSignInVip:ctor(params)
	self.id = params.id
	local cfg = params.cfg

	self.totalNum 	= checknumber(self.id) 		-- 累计次数
	self.items 		= {} 						-- 奖励物品
	self.heroId 	= cfg.HeroID 				-- 奖励英雄

	for i,v in ipairs(cfg.ItemID) do
		table.insert(self.items,{
			id = i,
			itemId = cfg.ItemID[i],
			itemNum = cfg.ItemNum[i]
			})
	end

	table.sort(self.items, function(a, b)
		return checknumber(a.id) < checknumber(b.id)
	end)

end

function GameSignInVip:getItemsArr()
	local arr = {}
	for i,v in pairs(self.items) do
		table.insert(arr, {
			id = self.items[i].itemId,
			count = self.items[i].itemNum,
		})
	end
	table.sort(arr, function(a, b)
		return checknumber(a.id) > checknumber(b.id)
	end)
	return arr
end

function GameSignInVip:getShowArr()
	local arr = {}
	for i,v in pairs(self.items) do
		table.insert(arr, {
			itemId 	= self.items[i].itemId,
			count 	= self.items[i].itemNum,
		})
	end

	if self.heroId then
		local heroId = self.heroId
		print("heroId:", heroId)
		table.insert(arr, {
			heroId 	= heroId,
			count 	= 1,
		})
	end

	return arr
end

return GameSignInVip

