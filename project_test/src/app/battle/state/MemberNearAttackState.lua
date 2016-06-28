--
-- Author: zsp
-- Date: 2014-12-21 16:33:13
--

local StateBase = import(".StateBase")

local MemberNearAttackState = class("MemberNearAttackState", StateBase)

--[[
	角色的近程攻击状态
--]]
function MemberNearAttackState:enter(owner)
	-- body
	-- printInfo(owner.roleId.."进入进攻")
	owner:playAttack()

	-- 四段重击角色前移
	if owner.attackNum == 4 then
		
		if owner.camp == GameCampType.left then
			--todo endline 暂定100 需求可能有变化 读配置

			if owner:getPositionX() < 3170 then
				-- owner:runAction(cc.Sequence:create(
				-- 	cc.DelayTime:create(0.4),
				-- 	cc.MoveBy:create(0.1,cc.p(20,0))
				-- ))
			end
		else
			if owner:getPositionX() > 100 then
				-- owner:runAction(cc.Sequence:create(
				-- 	cc.DelayTime:create(0.4),
				-- 	cc.MoveBy:create(0.1,cc.p(-20,0))
				-- ))
			end
		end
	end
end

function MemberNearAttackState:execute(owner,dt)
	
end

function MemberNearAttackState:exit(owner)

	owner:doNextAttackNum()

end

function MemberNearAttackState:executeAnim(owner,frame,finish)

	local frameMap = owner:getAttackFrameMap(owner.attackNum)
	
	if 	table.keyof(frameMap,string.format("%d",frame)) == nil and finish == false then
		return
	end

	local enemy = owner:findOneAttackRange()

	if finish then
		--有攻击目标并不是四段攻击完成时，继续下一段攻击
		if enemy ~= nil and owner.attackNum < 4 then
			owner:doNearAttack()
		else
			owner:doIdle()
		end
	else

		if enemy ~= nil then
			--攻击到敌人后增加怒气和连击
			--owner:afterAttackAppendAnger(owner.attackNum)
			owner:appendHit(1)

			local attackEffect = owner.model.atkEffect
			enemy:showEffect(attackEffect)

			enemy:doDamage({
				attacker    = owner,
				a_attackNum = owner.attackNum,
				a_damage_type  = owner.model.damageType,
				a_atk       = owner.model.atk,
				a_m_atk     = owner.model.magicAtk,
				a_acp       = owner.model.acp,
				a_m_acp     = owner.model.magicAcp,
				a_rate      = owner.model.rate,
				a_crit      = owner.model.crit,
				a_break     = owner.model.breakValue,
				a_tumble    = owner.model.tumble,
				a_lv        = owner.level
			})
			
		end
	end

end

return MemberNearAttackState