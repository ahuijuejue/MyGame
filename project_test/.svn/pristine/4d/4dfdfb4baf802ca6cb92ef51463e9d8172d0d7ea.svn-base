--
-- Author: zsp
-- Date: 2015-05-07 16:40:01
--

--[[
	战斗场景警告特效提示层 用在主角低血量提示
--]]
local BattleWarnLayer = class("BattleWarnLayer",function()
     return display.newNode()
end)

function BattleWarnLayer:ctor() 
    self.sp = display.newScale9Sprite("dangerous.png",0,0,cc.size(display.width,display.height))
   	self.sp:addTo(self)
   	self.isStart = false
   	self:setVisible(false)
end

--[[
	开始运行动画
--]]
function BattleWarnLayer:startRun()
	if self.isStart then
		return
	end

	self.isStart = true
	self:setVisible(true)
	self.sp:stopAllActions()
	self.sp:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeTo:create(1,50),cc.FadeTo:create(1,255))))
end

--[[
	停止运行动画
--]]
function BattleWarnLayer:stopRun()
	self.isStart = false
	self.sp:stopAllActions()
	self:setVisible(false)
end

return BattleWarnLayer