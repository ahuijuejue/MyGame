--[[
签到单条数据 
]]

local GameSignIn = class("GameSignIn") 

function GameSignIn:ctor(params)
	self.id = params.id 
	local cfg = params.cfg 

	self.itemId 	= cfg.ItemID 				-- 物品id 
	self.itemNum 	= checknumber(cfg.ItemNum)	-- 物品数量 	
	self.heroId 	= cfg.HeroID 				-- 奖励英雄 
	self.vip 		= checknumber(cfg.VipLv) 			-- 多倍奖励要求Vip等级 
	self.vipMult 	= checknumber(cfg.VipMultiple) 		-- 多倍奖励倍数 
	self.month 		= tostring(cfg.Month) 		-- 月份 

end

function GameSignIn:haveVip() 
	return self.vip > 0 
end 

return GameSignIn 
