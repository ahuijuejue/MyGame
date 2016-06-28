--
-- Author: zsp
-- Date: 2014-11-24 14:49:58
--

local StateBase = import(".StateBase")
local BattleEvent = require("app.battle.BattleEvent")

local LeaderNearAttackState = class("LeaderNearAttackState", StateBase)

--[[
	角色的近程攻击状态
--]]
function LeaderNearAttackState:enter(owner)
	-- body
	-- printInfo(owner.roleId.."进入进攻")
	owner:playAttack()
	
end

function LeaderNearAttackState:execute(owner,dt)
	
end

function LeaderNearAttackState:exit(owner)

	owner:doNextAttackNum()

end

function LeaderNearAttackState:executeAnim(owner,frame,finish)

	--BattleSound.playAttack(owner.roleId,frame)

	BattleSound.playHit(owner.roleId,owner.attackNum,frame)

	local frameMap = owner:getAttackFrameMap(owner.attackNum)

	if table.keyof(frameMap,string.format("%d",frame)) == nil and finish == false then
		return
	end

	local enemy = owner:findOneAttackRange()

	if finish then

		--有攻击目标并不是四段攻击完成时，继续下一段攻击
		--if enemy ~= nil and owner.attackNum < 4 then
		if owner.attackNum < 4 then
			owner:doNearAttack()
		else
			owner:doIdle()
		end
	else
		BattleEvent:dispatchEvent({
	      name    = BattleEvent.CAMERA_SWAY
	    })

		if enemy ~= nil then

			--攻击到敌人后增加怒气和连击
			--owner:afterAttackAppendAnger(owner.attackNum)
			owner:appendHit(1)

			local attackEffect = owner.model.atkEffect
			enemy:showEffect(attackEffect)

			enemy:doDamage({
				attacker      = owner,
				a_attackNum   = owner.attackNum,
				a_damage_type = owner.model.damageType,
				a_atk         = owner.model.atk,
				a_m_atk       = owner.model.magicAtk,
				a_acp         = owner.model.acp,
				a_m_acp       = owner.model.magicAcp,
				a_rate        = owner.model.rate,
				a_crit        = owner.model.crit,
				a_break       = owner.model.breakValue,
				a_tumble      = owner.model.tumble,
				a_lv          = owner.level
			})
		end
	end

end

return LeaderNearAttackState