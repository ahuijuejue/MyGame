--
-- Author: zsp
-- Date: 2014-12-25 13:12:18
--

local BattleEvent = require("app.battle.BattleEvent")

local MemberButton = import(".MemberButton")
local NodeBox = import("app.ui.NodeBox")

--[[
	 队员按钮组 控制上场和替补队员的逻辑 和队员召唤按钮
--]]
local MemberButtonGroup = class("MemberButtonGroup",function()
    return display.newNode()
end)

function MemberButtonGroup:ctor(params,guide)
	self.btnMap   = {} -- key = roleId value = 角色对象
	self.indexMap = {}  -- key = index value = roleId
	self.firBtn = {} --队伍1
	self.secBtn = {} --替补队员按钮
	self.inTeam = params.inTeam
	for i=2,#params.team do
		local btn = MemberButton.new(params.team,i)
		if i == 5 then
			btn.guide = guide.member
		end
		btn:setScale(0.7)
		btn:setButtonEnabled(false)
		btn:onButtonClicked(function(event)
			btn:setGuideEnd()
			btn:setVisible(false)
			if i > self.inTeam then
				if self.firBtn[i-self.inTeam] then
					self.firBtn[i-self.inTeam]:startCooldown()
					self.firBtn[i-self.inTeam]:setVisible(true)
					self.firBtn[i-self.inTeam]:setButtonEnabled(false)
				end
			else
				if self.secBtn[i-1] then
					self.secBtn[i-1]:startCooldown()
					self.secBtn[i-1]:setVisible(true)
					self.secBtn[i-1]:setButtonEnabled(false)
				end
			end
		    BattleEvent:dispatchEvent({
				name        = BattleEvent.CALL_MEMBER,
				index = i
		    })
		end)

		if i > self.inTeam then
			self.secBtn[i-self.inTeam] = btn
			btn:startCooldown()
		else
			self.firBtn[i-1] = btn
			btn:setVisible(false)
		end
		self.btnMap[i-1] = btn
	end
	self:createBtnBox()
end

function MemberButtonGroup:createBtnBox()
	self.btn1Box = NodeBox.new()
	self.btn1Box:setCellSize(cc.size(95,95))
	self.btn1Box:setSpace(10,0)
	self.btn1Box:setPosition(display.cx,60)
	self.btn1Box:setUnit(3)
	self.btn1Box:addElement(self.firBtn)
	self:addChild(self.btn1Box)

	self.btn2Box = NodeBox.new()
	self.btn2Box:setCellSize(cc.size(95,95))
	self.btn2Box:setSpace(10,0)
	self.btn2Box:setPosition(display.cx,60)
	self.btn2Box:setUnit(3)
	self.btn2Box:addElement(self.secBtn)
	self:addChild(self.btn2Box)
end

--当战场上有队员时调用
function MemberButtonGroup:onMemderDead(index)
	if index > self.inTeam then
		local btn = self.firBtn[index-self.inTeam]
		if btn then
			if btn:isCooldownEnd() then
				btn:doClick()
			end
		else
			self.secBtn[index-self.inTeam]:setButtonEnabled(false)
			self.secBtn[index-self.inTeam]:setVisible(true)
			self.secBtn[index-self.inTeam]:startCooldown()
		end
	else
		local btn = self.secBtn[index-1]
		if btn then
			if btn:isCooldownEnd() then
				btn:doClick()
			end
		else
			self.firBtn[index-1]:setButtonEnabled(false)
			self.firBtn[index-1]:setVisible(true)
			self.firBtn[index-1]:startCooldown()
		end
	end
end

--[[
	暂停主内按钮冷却记时
--]]
function MemberButtonGroup:pauseCooldown()
	for i,v in ipairs(self.btnMap) do
		v:pauseCooldown()
	end
end

--[[
	恢复主内按钮冷却记时
--]]
function MemberButtonGroup:resumeCooldown()
	for i,v in ipairs(self.btnMap) do
		v:resumeCooldown()
	end
end

return MemberButtonGroup