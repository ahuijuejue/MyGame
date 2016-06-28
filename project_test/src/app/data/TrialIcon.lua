
local TrialIcon = class("TrialIcon") 

function TrialIcon:ctor()
	self.icons = {}
	local cfg = GameConfig["Trials_Icon"] 
	for k,v in pairs(cfg) do 
		local nQua = checknumber(v.Quality)
		self.icons[k] = {
			id 		= k, 					-- id
			icon 	= v.Icon, 				-- 图标
			num 	= checknumber(v.Num), 	-- 数量
			quality = nQua, 				-- 品质（用于边框）
			name 	= v.Info, 				-- 名字 
			border  = string.format("AwakeStone%d.png", nQua), 	-- 边框 
			type 	= checknumber(v.Type), 	-- 类型。1.山多拉的灯 2.精神时间屋 
		}
	end 

	self.light = {} 	-- 山多拉的灯 
	self.house = {} 	-- 精神时间屋 
	for k,v in pairs(self.icons) do
		if v.type == 1 then 
			table.insert(self.light, v)
		elseif v.type == 2 then 
			table.insert(self.house, v)
		end 
	end 
	table.sort(self.light, function(a, b)
		return checknumber(a.id) < checknumber(b.id)
	end)
	table.sort(self.house, function(a, b)
		return checknumber(a.id) < checknumber(b.id)
	end)

end

function TrialIcon:getIconData(iconId)
	return self.icons[iconId]
end 

function TrialIcon:getLight(index)
	return self.light[index]
end 

function TrialIcon:getHouse(index)
	return self.house[index]
end 

return TrialIcon 
