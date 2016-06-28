--
-- Author: zsp
-- Date: 2015-01-16 10:49:25
--

--[[
	游戏公式
--]]
Formula = {}

--[[
	公式1:召唤cd计算公式
	@param enter_cd 英雄上场cd 按品质等级配置
	@param consume_hp 是该英雄被替换时已经被消耗掉的血量，
	@param hp   	  为英雄满血总HP量
	@return           返回召唤时间单位秒
--]]
Formula[1] = function ( enter_cd,hp_cd, consume_hp, hp )
	return enter_cd + hp_cd * consume_hp / hp
end

--[[
	公式2:怒气积攒公式
	damage_hp此次被攻击损失的血量百分比，
--]]
Formula[2] = function (damage_hp ,max_hp , ratio, power_get)
	return damage_hp / max_hp * ratio * power_get
end


--[[
	物理受伤比计算公式
	@param b:defense为防守方物理防御值，
	@param a:acp为进攻方物理破防值
--]]
Formula[4] = function ( b_defense, a_acp )
	return 1 - (b_defense - a_acp / 2 ) / (b_defense + 100)
end

--[[
	魔法受伤比计算公式
	@param b:m_defense为防守方魔法防御值
	@param a:m_acp为进攻方魔法破防值
--]]


Formula[5] = function ( b_m_defense, a_m_acp )
	--return 1 - (b_m_defense - a_m_acp) / (b_m_defense + 100)
	return Formula[4]( b_m_defense, a_m_acp)
end

--[[
	物理和魔法普通攻击伤害值计算公式
	@param a:atk为进攻方物理攻击
	@param a:lv为进攻方等级
--]]
Formula[6] = function (a_atk, a_lv,b_defense,a_acp)
	return math.max(a_atk * Formula[4](b_defense,a_acp), a_lv)
end

--[[
	技能附带伤害值
	@param data为技能附带的基础属性值，
	@param skill_lv为技能等级，
	@param skill_level_data为技能升级增加的值,
--]]
Formula[7] = function (data, skill_lv,skill_level_data)
	return data + (skill_lv - 1) *  skill_level_data
end

--[[
	魔法技能攻击伤害值计算公式
	@param a:m_atk为进攻方魔法攻击
	@param skill.damage为技能附带在总伤害值

	max((a:m_atk+skill.damage)*魔法受伤比*damage_ratio,a:lv*2）
--]]
Formula[8] = function (a_m_atk,skill_damage,skill_damage_ratio,a_lv,b_m_defense, a_m_acp)
	-- return math.max(a_m_atk * Formula[5](b_m_defense, a_m_acp) * skill_damage_ratio + skill_damage , a_lv * 2)
	 return math.max((a_m_atk + skill_damage) * Formula[5](b_m_defense, a_m_acp) * skill_damage_ratio , a_lv * 2)
end

--[[
	物理技能攻击伤害值计算公式
	a:m_atk为进攻方魔法攻击
	skill.damage为技能附带在总伤害值
--]]
Formula[9] = function (a_atk,skill_damage,skill_damage_ratio,a_lv,b_defense, a_acp)
	--return math.max( a_atk * Formula[4](b_defense, a_acp) * skill_damage_ratio + skill_damage ,a_lv * 3)
	return math.max((a_atk + skill_damage)* Formula[4](b_defense, a_acp) * skill_damage_ratio ,a_lv * 3)
end

--[[
	物理攻击命中率计算公式
	@param a_rate为进攻方命中
	@param b:dodge为防守方闪避值
--]]
Formula[10] = function (a_rate,b_dodge)
	return 1 - a_rate / (a_rate + b_dodge * 0.5)
end

--[[
	物理暴击计算公式
	@param a:crit为进攻方暴击值
	@param a:lv为进攻方等级
--]]
Formula[11] = function (a_crit,a_lv)
	return a_crit / (20 * a_lv + 200)
end

--[[
	后仰值判定公式
	@param a:break进攻方后仰值
	@param b:break防守方后仰值
	@param damage_ratio 此次攻击造成的伤害百分比 伤害/总血量
--]]
Formula[12] = function (a_break,b_break, damage_ratio)
	return a_break / (a_break + b_break * 6) + damage_ratio * (1600/(1600+b_break))
end

--[[
	后退值判定公式
	@param a:tumble进攻方击退值
	@param b:tumble防守方击退值
--]]
Formula[13] = function (a_tumble,b_tumble,damage_ratio)
	return a_tumble / (a_tumble + b_tumble * 3) + damage_ratio * (1600/(1600+b_tumble))
end

--[[
	基础属性成长公式
	@param basic_num是属性基础值
	@param up_num是属性成长值
	@param lv 是角色等级
	@param s_lv 强化等级
--]]
Formula[14] = function (basic_num,lv,up_num,s_lv,b)
	s_lv = s_lv or 0
	b = b or 0.15
	return (basic_num + ( lv-1 ) * up_num) * (s_lv * b + 1)
end

--[[
	Formula[15]
	队长在屏幕中位置公示
	屏幕中心点x=0,atk_x为队长攻击距离
	-atk_x*0.5
--]]

--[[
	Formula[16]
	队员在屏幕中初始位置
	(队员.atk_x-队长.atk_x)*0.5-80
--]]

--[[
	技能数值成长公式
	(队员.atk_x-队长.atk_x)*0.5-80

	value+(lv-1)*level_up
--]]
Formula[17] = function (value,lv,level_up)
	return value + (lv - 1) * level_up
end

--[[
	变身后血量
--]]
Formula[18] = function (model,nModel)
    local hp = math.min(1,model.hp/model.maxHp+0.25+0.05*model.awakeLevel)*nModel.maxHp
	return math.ceil(hp)
end






