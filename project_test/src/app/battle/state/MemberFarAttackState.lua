--
-- Author: zsp
-- Date: 2014-12-21 16:32:24
--
local StateBase            = import(".StateBase")
local MissileNode          = import("..node.MissileNode")
local MemberFarAttackState = class("MemberFarAttackState", StateBase)

--[[
	角色的空闲状态
--]]
function MemberFarAttackState:enter(owner)
	-- printInfo(owner.roleId.."进入远攻")
	owner:playAttack()

	if owner.attackNum == 4 then
		-- todo 四段攻击位移
	end
end

function MemberFarAttackState:execute(owner,dt)
	
end

function MemberFarAttackState:exit(owner)
	owner:doNextAttackNum()
end

function MemberFarAttackState:executeAnim(owner,frame,finish)
	local frameMap = owner:getAttackFrameMap(owner.attackNum)

	if 	table.keyof(frameMap,string.format("%d",frame)) == nil and finish == false then
		return
	end

	local enemy = owner:findOneAttackRange()

	if finish then

		--有攻击目标并不是四段攻击完成时，继续下一段攻击
		if enemy ~= nil and owner.attackNum < 4 then
			owner:doFarAttack()
		else
			owner:doIdle()
		end
	else
	
		if enemy ~= nil then

			--攻击到敌人后增加怒气和连击
			--owner:afterAttackAppendAnger(owner.attackNum)
			owner:appendHit(1)

			local missile = MissileNode.new({
				missileId = owner.model.missileId ,
				owner = owner,
				distance = owner.model.attackSize.width,
				attackerData = {
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
				}
			})

			missile:addTo(owner:getParent())

		end
	end
end

return MemberFarAttackState