--
-- Author: zsp
-- Date: 2015-02-03 16:28:05
--


local StateBase = import(".StateBase")

local TrapFireState = class("TrapFireState", StateBase)

--[[
	陷阱的准备状态
--]]
function TrapFireState:enter(owner)
	--print("进入开火陷阱")
	owner:playFire()
end

function TrapFireState:execute(owner,dt,frame)
	
end

function TrapFireState:exit(owner)
	-- body
end

function TrapFireState:executeAnim(owner,frame,finish)
	
	if 	table.keyof(owner.hitFrame,string.format("%d",frame)) == nil and finish == false then
		return
	end

	if finish then
		owner:doNormal()
	else
		local enemies = BattleManager.getRolesByCamp(owner.enemyCamp)
		if enemies then
			table.walk(enemies,function(v,k)
				if not v:isActive() then

				elseif not cc.rectIntersectsRect(owner:getViewRect(),v:getNodeRect()) then

				else
					v:doTrapDamage(damageType,owner.damage, owner.buffId)
				end
			end)
		end	
	end
end

return TrapFireState

