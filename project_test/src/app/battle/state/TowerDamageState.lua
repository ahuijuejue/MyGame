--
-- Author: zsp
-- Date: 2015-06-06 12:17:43
--
local StateBase = import(".StateBase")
local TowerDamageState = class("TowerDamageState", StateBase)

--[[
	角色的空闲状态
--]]
function TowerDamageState:enter(owner)
	-- body
	-- printInfo(owner.roleId.."进入受伤1")
	owner:playDamage()

	AudioManage.playSound("hit.mp3")
end

function TowerDamageState:execute(owner,dt)
	
end

function TowerDamageState:exit(owner)
	-- body
end

function TowerDamageState:executeAnim(owner,frame,finish)
	-- body
	if not finish then
		return	
	end

	owner:doIdle()
end

return TowerDamageState