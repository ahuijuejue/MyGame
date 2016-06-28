--
-- Author: zsp
-- Date: 2014-12-05 11:51:47
--

local SkillButton = import(".SkillButton")

--[[
	技能按钮组 用于显示在界面想显示 显示队长的技能 并控制释放
--]]
local SkillButtonGroup = class("SkillButtonGroup",function()
    return display.newNode()
end)

function SkillButtonGroup:ctor(role,guide)

	--绑定角色技能管理上的回调接口
	role.skillMgr.onCooldown = handler(self, self.onCooldown)

	self.role = role
	local skills = self.role.model.skillids
	self.btnMap = {}

	local isGuide = false
	if guide and guide.skill then
		isGuide = true
	end

	--按钮的外边距
	self.margin = 30

	for k,v in pairs(skills) do
		local btn = SkillButton.new(v,role)
		if k == 1 then
			btn.guide = isGuide
		end
		btn:addTo(self,4-k)
		self.btnMap[v] = btn
	end

	self:setContentSize(340,120)
	self:updateAlign(self.margin)
end

--[[
	更新按钮对齐位置
--]]
function SkillButtonGroup:updateAlign(margin)
	local skills = self.role.model.skillids
	local btnPoint = {cc.p(270,0),cc.p(160,-10),cc.p(190,80)}
	local btnScale = {0.9,0.7,0.7}

	for i,v in ipairs(skills) do
		local btn = self.btnMap[v]
		btn:setScale(btnScale[i])
		btn:setPosition(btnPoint[i])
	end
end

--[[
	更新技能冷却
--]]
function SkillButtonGroup:onCooldown(role,skillId,dt,cooldown)
	self.btnMap[skillId]:updateCooldown(dt, cooldown)
end


return SkillButtonGroup