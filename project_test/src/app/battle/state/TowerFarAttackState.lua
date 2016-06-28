--
-- Author: zsp
-- Date: 2015-06-06 12:22:26
--

local StateBase           = import(".StateBase")
local MissileNode         = import("..node.MissileNode")
local TowerFarAttackState = class("TowerFarAttackState", StateBase)

--[[
	角色的空闲状态
--]]
function TowerFarAttackState:enter(owner)
	-- body
	--printInfo(owner.roleId.."进入远攻")
	owner:playAttack()

end

function TowerFarAttackState:execute(owner,dt)

end

function TowerFarAttackState:exit(owner)
	
end

function TowerFarAttackState:executeAnim(owner,frame,finish)

	
	local frameMap = owner:getAttackFrameMap()
	
	if 	table.keyof(frameMap,string.format("%d",frame)) == nil and finish == false then
		return
	end


	local hasAttack = owner:hasAttackRange()

	if finish then
		--todo
		if hasAttack then
			--todo
			--等待下次攻击
			owner:doAttackDelay()	
		else
			owner:doIdle()
		end
	else
		if hasAttack then

			local missile = MissileNode.new({
				missileId = owner.model.missileId ,
				owner = owner,
				distance = owner.model.attackSize.width,
				launchY   = owner.model.nodeSize.height,
				attackerData = {
					attacker      = owner,
					a_attackNum   = 1,
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

			missile:setLocalZOrder(890)
			missile:addTo(owner:getParent())
		end
	end
end

return TowerFarAttackState