--
-- Author: zsp
-- Date: 2015-04-14 16:22:53
--
local BattleEvent = require("app.battle.BattleEvent")

local TailSkillButton = import(".TailSkillButton")

--[[
	 队员按钮组 控制上场和替补队员的逻辑 和队员召唤按钮
--]]
local TailSkillButtonGroup = class("TailSkillButtonGroup",function()
    return display.newNode()
end)

function TailSkillButtonGroup:ctor(owner,tailSkill)
	
    --绑定角色尾兽技能管理上的回调接口
	owner.tailSkillMgr.onCooldown = handler(self, self.onCooldown)
	owner.tailSkillMgr.onNext = handler(self,self.onNext)

	self.btnMap   = {} -- key = roleId value = 角色对象
	--self.indexMap = {} -- key = index value = roleId

	local level = tailSkill.level
	local skill = tailSkill.skill

	--local i = 0
	for k,v in pairs(skill) do

		local btn = TailSkillButton.new(v)
		btn:setButtonEnabled(false)
		btn:addTo(self)
		--btn:setPosition(0, i * 100)		
		self.btnMap[v] = btn
		--i = i + 1
		if k ~= 1 then
			btn:setVisible(false)
		end
	end

end

--[[
	更新技能冷却
--]]
function TailSkillButtonGroup:onCooldown(skillId,dt,cooldown)
	-- body
	--print("onCooldown==============="..skillId)
	self.btnMap[skillId]:updateCooldown(dt, cooldown)
end

function TailSkillButtonGroup:onNext(skillId)
	--print(skillId)
	for k,v in pairs(self.btnMap) do
		if k == skillId then
			v:setVisible(true)
		else
            v:setVisible(false)
		end
	end
end

return TailSkillButtonGroup