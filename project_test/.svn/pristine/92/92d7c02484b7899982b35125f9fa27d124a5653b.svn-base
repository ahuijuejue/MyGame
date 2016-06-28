--
-- Author: zsp
-- Date: 2014-11-25 18:44:33
--

local StateBase = import(".StateBase")
local EnemyNearAttackState = class("EnemyNearAttackState", StateBase)

--[[
	角色的空闲状态
--]]
function EnemyNearAttackState:enter(owner)
	-- body
	-- printInfo(owner.roleId.."进入进攻")
	owner:playAttack()

	if owner.attackNum == 4 then
		-- todo 四段攻击位移
	end
end

function EnemyNearAttackState:execute(owner,dt)
	
end

function EnemyNearAttackState:exit(owner)
	
	owner:doNextAttackNum()
	
end

function EnemyNearAttackState:executeAnim(owner,frame,finish)

	local frameMap = owner:getAttackFrameMap(owner.attackNum)
	
	if 	table.keyof(frameMap,string.format("%d",frame)) == nil and finish == false then
		return
	end


	local enemy = owner:findOneAttackRange()

	if finish then
		--todo
		if enemy ~= nil then
			--todo
			--n段攻击结束后如还有可攻击到的人则进入攻击等待状态，等待下次攻击
			if  owner:isLastAttack() then
				
				owner:doAttackDelay()
			else
				owner:doNearAttack()
			end
			
		else
			owner:doIdle()
		end
	else
		if enemy ~= nil then

			--local name = owner.model.image
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

return EnemyNearAttackState