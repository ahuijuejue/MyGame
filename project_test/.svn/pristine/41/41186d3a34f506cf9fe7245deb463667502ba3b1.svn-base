--
-- Author: zsp
-- Date: 2014-12-09 18:35:48
--

local BuffManager = class("BuffManager")

local buffMap = {}
buffMap[1] = "AttributeBuff" 		-- 修改基础属性
buffMap[2] = "MaxHpBuff" 			-- 血上限类型
buffMap[3] = "HpBuff" 				-- 当前血量类型
buffMap[4] = "UnbeatableBuff" 		-- 无敌
buffMap[5] = "ShieldBuff" 			-- 护盾
buffMap[6] = "DizzinessBuff" 		-- 眩晕
buffMap[7] = "SuperBodyBuff" 		-- 霸体
buffMap[8] = "BackBuff" 				-- 击退
buffMap[9] = "ReboundBuff" 			-- 反伤
buffMap[10] = "CallTowerBuff" 		-- 召唤塔
buffMap[11] = "AngerBuff" 			-- 怒气
buffMap[12] = "SuckBuff" 				-- 吸血
buffMap[13] = "SilentBuff"			-- 沉默
buffMap[14] = "NotAttackBuff"         -- 无法普攻
buffMap[15]	= "ImmuneDeBuff"			-- 无法被施加减益buff
buffMap[16]	= "DelShieldBuff"			-- 破盾
buffMap[17] = "CleanDeBuff" --净化	
buffMap[18] = "CleanEffectBuff" --虚无	
buffMap[19] = "CurseBuff" --诅咒
buffMap[20] = "CureDecreaseBuff" --回血量降低
buffMap[21] = "DamageIncreaseBuff" --收到的伤害增加

--[[
	管理角色身上中的buff，控制已角色中buff的生命周期，和执行buff
--]]
function BuffManager:ctor(owner)
	
	self.owner         = owner
	
	self.buffs         = {}
	
	self.isPaused      = false
	
	self.__removed = {}
end

--[[
	添加buff
	buff的等级
	释放这个buff的角色或？
--]]
function BuffManager:addBuff(buffId,level,attacker)
	
	if buffId == "" then
		return
	end
	
	if self.owner:isActive() == false then 
		return
	end

	local tb = string.split(buffId, ",")
	for k,v in pairs(tb) do
		local cfg      = GameConfig.buff[v]
		if not cfg then
			printInfo("buffId = %s 没找到 ",v)
		end
		local bufftype = checkint(cfg["type"])
		local way      = checkint(cfg["way"])

		--无敌状态免疫敌人的伤害buff和控制buff
		if (self.owner.unbeatable and self.owner.magicUnbeatable and way ~= 1) then
		elseif self.owner.superBody and way == 3 then
		elseif table.nums(self:getBuffByType(15)) > 0 and way == 2 then
		elseif table.nums(self:getBuffByType(19)) > 0 and way == 1 then
		else
			local buff = self.buffs[v]
			if buff ~= nil then
				buff:reset()
			else
				buff = require("app.battle.buff."..buffMap[bufftype]).new(v,level,self,attacker)
				self.buffs[v] = buff
				buff:doBegin()
			end
		end
	end
end

--[[
	获取全部反伤的buff
--]]
function BuffManager:getReBoundBuff()
	return self:getBuffByType(9)
end

--[[
	获取全部吸血的buff
--]]
function BuffManager:getSuckBuff()
	return self:getBuffByType(12)
end

--[[
	获取全部沉默buff
--]]
function BuffManager:getSilentBuff()
	return self:getBuffByType(13)
end

--[[
	获取某类型的buff
--]]
function BuffManager:getBuffByType(buffType)
	local tb = {}
	for k,v in pairs(self.buffs) do
		if v.type == buffType then
			table.insert(tb,v)
		end
	end
	return tb
end

--[[
	清除全部的buff
--]]
function BuffManager:clean()
	-- body
	for key, value in pairs(self.buffs) do  
    	value.remove = true
	end 
end

--[[
	删除debuff
--]]
function BuffManager:removeDeBuff()
	for key, value in pairs(self.buffs) do  
    	if value.way == 2 then
    		value.remove = true
    	end
	end 
end

--[[
	虚无
--]]
function BuffManager:removeEffectBuff()
	for key,value in pairs(self.buffs) do
		if value.way == 1 then
			if value.type ~= 4 and value.type ~= 5 and value.type ~= 7 and value.type ~= 15 then
				value.remove = true
			end
		end
	end
end

--[[
	删除某些类型的buff
--]]
function BuffManager:removeBuffByType(bType)
	for k,v in pairs(self.buffs) do
		if v.type == bType then
			v.remove = true
		end
	end
end

--[[
	更新buff逻辑
--]]
function BuffManager:update(dt)
	if self.isPaused then
		return
	end

	for key, value in pairs(self.buffs) do
    	if value.remove == true then
    		table.insert(self.__removed,key)
    	else
    		value:update(dt)
    	end
	end 

	for i = table.nums(self.__removed), 1, -1 do
		local buff = self.buffs[self.__removed[i]]
		buff:doEnd()
		self.buffs[self.__removed[i]] = nil
   		self.__removed[i] = nil
    end
end

return BuffManager
