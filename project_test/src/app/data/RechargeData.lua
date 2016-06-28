
local RechargeData = class("RechargeData")

function RechargeData:ctor()

	local cfgRecharge = GameConfig["Recharge"]
	self.arr = {}
	for k,v in pairs(cfgRecharge) do

		local item = {
			id = k,
			icon = v.Icon,
			name = v.Name,
			gems = v.Diamond,
			desc = v.Description,
			rmb = v.Rmb,
			limit = v.Limit,
			mark = v.Mark,
			sort = v.Sort,
			sale = v.Sale, -- 额外奖励获得的钻石
		}
		table.insert(self.arr, item)
	end

	table.sort(self.arr, function(a,b)
		return tonumber(a.sort) < tonumber(b.sort)
	end)

end

function RechargeData:getArray()
	return self.arr
end

return RechargeData

