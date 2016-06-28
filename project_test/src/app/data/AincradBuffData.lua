
local AincradBuffData = class("AincradBuffData")
local GameAincradBuff = import(".GameAincradBuff")

function AincradBuffData:ctor()
	self.dict = {}
	local cfg = GameConfig["AincradBuff"] 
	for k,v in pairs(cfg) do
		local buff = GameAincradBuff.new({
			id = k,
			cfg = v,
		})
		self.dict[k] = buff 
	end
end 

function AincradBuffData:createBuff(buffId, process) 
	local cfgs = GameConfig["AincradBuff"] 
	local cfg = cfgs[buffId]
	local buff = GameAincradBuff.new({
			id = buffId,
			cfg = cfg,
			process = process,
		})

	return buff 
end 

function AincradBuffData:getBuff(buffId)
	return self.dict[buffId]
end 

function AincradBuffData:resetBuffProcess()
	for k,v in pairs(self.dict) do
		v.process = 0  	
	end 
end 

-- 拥有的buff， 数组格式
function AincradBuffData:getHaveBuff()
	local arr = {}
	for k,v in pairs(self.dict) do
		-- if v.process > 0 then 
			table.insert(arr, v)
		-- end 
	end 
	return arr
end 

-- 拥有的buff, 字典格式
function AincradBuffData:getHaveBuff2()
	local arr = {}
	for k,v in pairs(self.dict) do
		if v.process > 0 then 
			arr[k] = v 
		end 
	end 
	return arr
end 

return AincradBuffData
