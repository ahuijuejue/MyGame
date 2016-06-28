--
-- Author: zsp
-- Date: 2015-06-06 12:24:21
--
local StateBase = import(".StateBase")
local TowerNearAttackState = class("TowerNearAttackState", StateBase)

--[[
	攻击塔进程攻击
--]]
function TowerNearAttackState:enter(owner)
	-- body
	-- printInfo(owner.roleId.."进入进攻")
	owner:playAttack()
end

function TowerNearAttackState:execute(owner,dt)
	
end

function TowerNearAttackState:exit(owner)
		
end

function TowerNearAttackState:executeAnim(owner,frame,finish)

	local frameMap = owner:getAttackFrameMap()
	
	if 	table.keyof(frameMap,string.format("%d",frame)) == nil and finish == false then
		return
	end


	local hasAttack = owner:hasAttackRange()

	if finish then
		--todo
		if hasAttack then
			
			owner:doAttackDelay()
			
		else
			owner:doIdle()
		end
	else
		if hasAttac then

			--local name = owner.model.image
			local attackEffect = owner.model.atkEffect
			enemy:showEffect(attackEffect)
			
			enemy:doDamage({
					attacker    = owner,
					a_attackNum = 1,
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

return TowerNearAttackState