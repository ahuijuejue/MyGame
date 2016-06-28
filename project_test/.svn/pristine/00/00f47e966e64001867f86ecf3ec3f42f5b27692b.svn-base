--
-- Author: zsp
-- Date: 2015-01-28 19:37:18
--
--[[
	增/减基础属性buff
	增减的属性的key对应model里的属性
	有如下:
		atk    物理攻击
		magicAtk 魔法攻击
		defense  物理防御
		magicDefense 魔法防御
		acp 
		magicAcp
		rate    攻击命中率
		dodge   闪避
		crit    暴击
		blood 	吸血
		breakValue 
		tumble 
		walkSpeed 移动速度 
--]]
local BuffBase      = import(".BuffBase")
local AttributeBuff = class("AttributeBuff",BuffBase)

function AttributeBuff:doBegin()
	self:doBuff()
	self.owner:addBuffEffect(self)
end

function AttributeBuff:doBuff()
	self.attach = 0
	if self.up_down == 0 then
		if self.method  == 0 then
			self.attach = self.owner.model[self.key] * self.data
		else
			self.attach = self.data
		end
		self.owner.model[self.key] = math.max(self.owner.model[self.key] - self.attach,0)
	else
		if self.method  == 0 then
			self.attach = self.owner.model[self.key] * self.data
		else
			self.attach = self.data
		end
		self.owner.model[self.key] = self.owner.model[self.key] + self.attach
	end

	--todo 减速可以拆分出来
	if self.key == "animSpeed" then
		--角色动画速度
		self.owner:setAnimSpeed(self.owner.model[self.key])
	end
end

function AttributeBuff:doEnd()
	--对于持续生效的，到时间后要恢复属性
	if self.time > 0 then
		if self.up_down == 0 then
			self.owner.model[self.key] = self.owner.model[self.key] + self.attach 
		else
			self.owner.model[self.key] = math.max(self.owner.model[self.key] - self.attach,0)
		end
	end

	if self.key == "animSpeed" then
		--角色动画速度
		self.owner:setAnimSpeed(1)
	end
	self.owner:removeBuffEffect(self)
end

function AttributeBuff:doUpdate(dt)
end

return AttributeBuff