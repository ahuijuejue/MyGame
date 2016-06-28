--
-- Author: zsp
-- Date: 2015-07-10 17:06:32
--

--[[
 	出兵的触发点,添加到BattleLogic中
--]]
local TriggerPoint = class("TriggerPoint", function()
	return display.newNode()
end)

function TriggerPoint:ctor(params)
	-- 1 事件触发 2 碰撞触发 3 定时触发
	self.type = params.type
	self.waveNum = params.waveNum --为nil时是伏兵出发点
	self.createPoint = params.createPoint

	-- 是否触发过
	self.remove = false

	if self.type == 1 then 
		
	elseif self.type  == 2 then
		
	elseif self.type == 3 then
		
	end

	-- local node = display.newSolidCircle(30, {x = 0, y = 0, color = cc.c4f(0, 0, 1, 1)})
	-- node:addTo(self)

	if not self.waveNum then
		local label =  display.newTTFLabel({
			text  = "伏兵",
			size  = 24,
			align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
		})
		label:setColor(cc.c3b(255,255,0))
		label:addTo(self)
	end
end

--[[
	满足出兵条件后，外部调用触发出兵
--]]
function TriggerPoint:doTrigger()
	self.remove = true
	self:setVisible(false)
	self.createPoint:doCreate()
end

return TriggerPoint