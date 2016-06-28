--
-- Author: zsp
-- Date: 2015-06-06 12:19:27
--
local StateBase = import(".StateBase")
local BattleEvent = require("app.battle.BattleEvent")
local TowerDeadState = class("TowerDeadState", StateBase)

--[[
	角色的空闲状态
--]]
function TowerDeadState:enter(owner)
	-- body
	--printInfo(owner.towerId.."进入死亡")
	

	if owner.dead then
		return
	end

	owner.dead = true
	owner:playDead()

	AudioManage.playSound("IronManSkill1.mp3",false)

    --发送死亡事件
	--if owner.camp == GameCampType.left then
 	BattleEvent:dispatchEvent({
      name  = BattleEvent.KILL_TOWER,
      dead  = owner
    })
  	--end

end

function TowerDeadState:execute(owner,dt)
	
end

function TowerDeadState:exit(owner)
	-- body
end

function TowerDeadState:executeAnim(owner,frame,finish)
	-- body
	if not finish then
		return	
	end


	owner:pauseAll()	

	-- for k,v in pairs(owner.animGroup) do
	-- 	v:unregisterScriptHandler()
	-- 	v:removeFromParent()
	-- end

	owner:setVisible(false)
	owner.remove = true


end

return TowerDeadState