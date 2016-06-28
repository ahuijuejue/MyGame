--[[
累计签到单条数据 
]]

local GameSignInTotal = class("GameSignIn") 

function GameSignInTotal:ctor(params)
	self.id = params.id 
	local cfg = params.cfg 

	self.totalNum 	= checknumber(self.id) 		-- 累计次数 
	self.items 		= {} 						-- 奖励物品 

	for i,v in ipairs(cfg.ItemID) do
		self.items[v] = checknumber(cfg.ItemNum[i]) 
	end 
end

function GameSignInTotal:getItemsArr()
	local arr = {} 
	for k,v in pairs(self.items) do
		table.insert(arr, {
			id = k,
			count = v,
		})
	end
	table.sort(arr, function(a, b)
		return checknumber(a.id) > checknumber(b.id)
	end)
	return arr 
end 

return GameSignInTotal 
