
local GameOpenLv = class("GameOpenLv")

function GameOpenLv:ctor(params)
	local cfg = params.cfg 
	self.id = params.id 

	self.name 		= cfg.Name 				-- 名称 
	self.type 		= cfg.DeblockingType 	-- 开放类型。1.等级；2.新手引导步骤 

	local openLv 	= cfg.DeblockingNum 	-- 开发等级 
	local openInfo 	= cfg.Info 				-- 开放信息 
	local haveInfo  = openInfo and table.nums(openInfo) > 0 
	if openLv then 
		local nNums = table.nums(openLv)
		if nNums > 1 then 		-- 数组格式
			self.openLv = {} 
			for i,v in ipairs(openLv) do
				local data = {
					level = checknumber(v),
				} 
				if haveInfo then 
					data.desc = openInfo[i] 
				end 
				table.insert(self.openLv, data)
			end
		else 					-- 数值格式 
			self.openLv = checknumber(openLv[1]) 	-- 解锁等级 
			if haveInfo then 
				self.desc = openInfo[1]
			end 
		end 
	end 

	if params.test then 
		self.openLv = params.test 
	end 

end

return GameOpenLv
