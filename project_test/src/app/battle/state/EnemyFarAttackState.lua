--
-- Author: zsp
-- Date: 2014-11-26 10:26:11
--
local StateBase           = import(".StateBase")
local MissileNode         = import("..node.MissileNode")
local EnemyFarAttackState = class("EnemyFarAttackState", StateBase)

--[[
	角色的空闲状态
--]]
function EnemyFarAttackState:enter(owner)
	-- body
	--printInfo(owner.roleId.."进入远攻")
	owner:playAttack()

	if owner.attackNum == 4 then
		-- todo 四段攻击位移
	end
end

function EnemyFarAttackState:execute(owner,dt)

end

function EnemyFarAttackState:exit(owner)
	owner:doNextAttackNum()
	
end

function EnemyFarAttackState:executeAnim(owner,frame,finish)
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

			local missile = MissileNode.new({
				missileId = owner.model.missileId ,
				owner = owner,
				distance = owner.model.attackSize.width,
				attackerData = {
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
				}
			})

			missile:addTo(owner:getParent())
		end
	end
end

return EnemyFarAttackState