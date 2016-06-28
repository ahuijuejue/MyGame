--
-- Author: zsp
-- Date: 2015-03-24 10:58:16
--
local StateBase = import(".StateBase")

local EnemyWinState = class("EnemyWinState", StateBase)

--[[
	角色的胜利状态
--]]
function EnemyWinState:enter(owner)
	-- body
	--printInfo(owner.roleId.."进入待机")
	if owner.dead then
		return
	end

	owner.buffMgr:clean()
	owner:playIdle()

	owner:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.Hide:create()))
	
end

function EnemyWinState:execute(owner,dt,frame)
	
end

function EnemyWinState:exit(owner)
	-- body
end

function EnemyWinState:executeAnim(owner,frame,finish)
	-- body
end

return EnemyWinState