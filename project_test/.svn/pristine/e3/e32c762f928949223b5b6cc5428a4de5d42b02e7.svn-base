--
-- Author: zsp
-- Date: 2015-04-15 11:49:31
--
local TailSkill = class("TailSkill")

--[[
	尾兽技能类
--]]
function TailSkill:ctor(skillId,level)
	self.isPaused   = false
	self.skillId    = skillId
	self.dtCooldown = 0
	self.level      = level or 1 --以后读数据

	local cfg       = GameConfig.skill_tails[skillId]
	self.image        = cfg["image"]
	self.rate         = checknumber(cfg["rate"])
	self.crit_rate    = checknumber(cfg["crit_rate"])
	self.crit_num     = checkint(cfg["crit_num"])
	self.damage       = checkint(cfg["damage"])
	self.damage_ratio = checknumber(cfg["damage_ratio"])
	self.damage_real  = checkint(cfg["damage_real"])
	self.cd_time      = checknumber(cfg["cd_time"])
	self.recover      = checkint(cfg["recover"])
	self.buff_rate    = checknumber(cfg["buff_rate"])
	
	--==================================================================

	self.typeOpen          = checkint(cfg["type_open"])
	self.damage_type       = checkint(cfg["damage_type"])
	self.level_max         = checkint(cfg["level_max"])
	self.target            = checkint(cfg["target"])
	self.buffId            = cfg["buff_id"] or ""
	self.myBuffId          = cfg["my_buff"] or ""
	self.attackEffect      = cfg["atk_effect"] or ""
	self.nodeOffset        = cc.p(checkint(cfg["skill_box"][1]),checkint(cfg["skill_box"][2]))
	self.nodeSize          = cc.size(checkint(cfg["skill_box"][3]), checkint(cfg["skill_box"][4]))

	local frame = "20,40,60"
	self.frameMap = string.split(frame, ",")

	local ratio = cfg["skill_ratio"]
	self.ratioMap = string.split(ratio, ",")

	--属性升级
	local levelData = cfg["level_data"]
	if levelData ~= nil then
		for i=1,#levelData do
			local data = levelData[i]
			local tb = string.split(data,":")
			local k = tb[1]
			local v = checknumber(tb[2])
			self[k] = Formula[7](self[k], self.level,checknumber(v))
		end
	end
end

function TailSkill:isCooldown()
	-- body
	if self.dtCooldown < self.cd_time then
		--todo
		return false
	end

	return true
end

function TailSkill:resetCooldown()
	-- body
	--if self.dtCooldown >= self.cooldown then
		--todo
		self.dtCooldown = 0
	--end
end

function TailSkill:update(dt)
		-- body
	if self.isPaused then
		return
	end

	self.dtCooldown = math.min(self.dtCooldown + dt, self.cd_time)

end

--[[
	设置技能冷却时间立即完成
--]]
function TailSkill:setCooldownFinish()
	-- body
	self.dtCooldown = self.cd_time

end

function TailSkill:setPause(pause)
	self.isPaused = pause
end



return TailSkill