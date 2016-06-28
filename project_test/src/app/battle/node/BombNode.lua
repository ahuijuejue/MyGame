--
-- Author: zsp
-- Date: 2015-04-08 18:02:46
--


--[[
	放在敌人身上的定时炸弹,试练中的自爆类型敌人用
--]]
local BombNode = class("GameNode", function()
	return display.newNode()
end)

function BombNode:ctor(owner,time,damage)
	self.owner = owner
	self.owner.bombNode = self

	self.time = time --定时时间秒数
	self.damage = damage
	self.label =  display.newTTFLabel({
		text  = string.format("%d",time),
		size  = 30,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.label:setColor(cc.c3b(255,0,0))
	self.label:addTo(self)

	self:runAction(
	cc.RepeatForever:create(
		cc.Sequence:create(
			cc.DelayTime:create(1),
			cc.CallFunc:create(function()
			self.time = self.time - 1
			if self.time < 0 then
				--todo
				self:stopAllActions()
				self:setVisible(false) 

				local table = self.owner:findAttackRange()

				for k,v in pairs(table) do
					local enemy = v
					enemy:doDamage({
						attacker      = self.owner,
						a_attackNum   = 1,
						a_damage_type = self.owner.model.damageType,
						a_atk         = self.owner.model.atk,	   --self.damage, 直接用自爆怪的atk了
						a_m_atk       = self.owner.model.magicAtk, --self.damage,
						a_acp         = self.owner.model.acp,
						a_m_acp       = self.owner.model.magicAcp,
						a_rate        = self.owner.model.rate,
						a_crit        = self.owner.model.crit,
						a_break       = self.owner.model.breakValue,
						a_tumble      = self.owner.model.tumble,
						a_lv          = self.owner.level
					})
				end
				
				self.owner.bombNode = nil
				self.owner:doDead()
				self.owner:showEffect("atk_effect_3") 

			else
				self.label:setString(string.format("%d",self.time))
			end
		end) 
	)))		
end

return BombNode