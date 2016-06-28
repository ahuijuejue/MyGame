
local GameTailsSkill = class("GameTailsSkill") 

function GameTailsSkill:ctor(options) 
	
	local cfg 		= options.cfg 		-- 配置表 

	self.id 		= options.id  		-- 技能id 
	self.name 		= cfg.name 			-- 技能名 
	self.tailsId 	= cfg.pet 			-- 尾兽id 
	self.desc 		= cfg.level_info	-- 技能描述 
	self.icon 		= cfg.icon 			-- 图标


	self.baseArr = {} 	-- 基础值
	self.upArr = {} 	-- 每级加成值

	if self:haveValue(cfg.damage) then 
		table.insert(self.baseArr, checknumber(cfg.damage))
		local dict = self:parseArrayValue(cfg.level_data)
		table.insert(self.upArr, dict["damage"])
	end 

	local ids = string.split(cfg.buff_id or "", ",")

	for i,v in ipairs(ids) do
		local value, dict = self:getBuffInfo(v)
		table.insert(self.baseArr, value)
		table.insert(self.upArr, dict["data"] or dict["tower"] or 0)
	end
	

end

-- 是否含有字符串值
function GameTailsSkill:haveValue(value)
	return value and string.len(value) > 0 
end 

-- 含有字符s数量
function GameTailsSkill:haveLetterCount(str, letter)
	local strlen = string.len(str)
	local count = 0 
	for i=1,strlen do
		if string.sub(str, i, i) == letter then 
			count = count + 1
		end 
	end
	return count 
end 

-- 解析成长值
function GameTailsSkill:parseArrayValue(array)
	local dict = {}
	for i,v in ipairs(array or {}) do
		local strArr = string.split(v, ":")
		if #strArr == 2 then 
			dict[strArr[1]] = checknumber(strArr[2])
		end  
	end
	return dict
end 

-- 解析buff成长值
function GameTailsSkill:getBuffInfo(buffId)	
	local dict = {}
	local value = 0
	local cfg = GameConfig["buff"][buffId]
	if cfg then 
		if checknumber(cfg.type) == 10 then 
			local towerCfg = GameConfig["tower"][cfg.key]
			if towerCfg then 
				value = checknumber(towerCfg.hp)
				dict["tower"] = checknumber(towerCfg.hp_upgrade)
			end 
		else 
			value = checknumber(cfg.data)
			local array = cfg.level_data
			for i,v in ipairs(array or {}) do
				local valuearr = string.split(v, ":")
				if #valuearr == 2 then 
					dict[valuearr[1]] = checknumber(valuearr[2])			
				end 
			end
		end 
	end 
	return value, dict
end

local function computeValue(baseValue, upValue, level)
	return baseValue + upValue * (level-1)
end

-- 获得加成后的值
function GameTailsSkill:getDesc(level)
	local str = self.desc 
	local sCount = self:haveLetterCount(str, "s")
	local kCount = self:haveLetterCount(str, "k")

	for i=1,sCount do
		local value = computeValue(self.baseArr[i], self.upArr[i], level)
		str = string.gsub(str, "s", tostring(value), 1)
	end

	for i=1,kCount do
		local value = self.upArr[i]
		str = string.gsub(str, "k", tostring(value), 1)
	end
	return str 
end 


return GameTailsSkill
