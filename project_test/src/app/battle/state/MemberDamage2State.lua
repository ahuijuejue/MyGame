--
-- Author: zsp
-- Date: 2014-12-21 15:25:36
--
local StateBase = import(".StateBase")

local MemberDamage2State = class("MemberDamage2State", StateBase)

--[[
	角色的空闲状态
--]]
function MemberDamage2State:enter(owner)
	-- body
	-- printInfo(owner.roleId.."进入受伤2")
	owner:playDamage2()

	if owner.camp == GameCampType.right  then
		if owner:getPositionX() + owner.tumbleDistance < BattleManager.sceneWidth then
			owner:runAction(cc.Sequence:create(
				cc.MoveBy:create(0.1,cc.p(owner.tumbleDistance,0))
			))
		end
	else
		if owner:getPositionX() - owner.tumbleDistance > 0 then
			owner:runAction(cc.Sequence:create(
				cc.MoveBy:create(0.1,cc.p(-owner.tumbleDistance,0))
			))
		end
	end
end

function MemberDamage2State:execute(owner,dt)
	
end

function MemberDamage2State:exit(owner)
	-- body
end

function MemberDamage2State:executeAnim(owner,frame,finish)
	-- body
	if not finish then
		return	
	end

	owner:doIdle()
end

return MemberDamage2State