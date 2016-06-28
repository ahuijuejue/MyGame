--[[
体力信息
]]

local PowerInfoLayer = class("PowerInfoLayer", function()
	return display.newNode()
end)

function PowerInfoLayer:ctor()
	self:initView()

	self:schedule(function()
        self:updateShow()
    end, 0.2)

    self:setNodeEventEnabled(true)
end

function PowerInfoLayer:initView()
	-- 背景框
	display.newSprite("Item_Tips.png"):addTo(self)
	
	-- 已购买体力次数
	base.Label.new({text="已购买体力次数", size=18})
	:addTo(self)
	:pos(-150, 45)

	base.Label.new({
		text=string.format("%d/%d", UserData.powerData.buyTimes, VipData:getPowerMax()), 
		size=18, 
		color=CommonView.color_green(),
	})
	:addTo(self)
	:pos(30, 45)

	-- 恢复下一点体力
	base.Label.new({text="恢复下一点体力", size=18})
	:addTo(self)
	:pos(-150, 15)

	self.nextLabel = base.Label.new({
		text="", 
		size=18, 
		color=CommonView.color_green(),
	})
	:addTo(self)
	:pos(30, 15)

	-- 恢复全部体力
	base.Label.new({text="恢复全部体力", size=18})
	:addTo(self)
	:pos(-150, -15)

	self.allLabel = base.Label.new({
		text="", 
		size=18, 
		color=CommonView.color_green(),
	})
	:addTo(self)
	:pos(30, -15)

	-- 恢复体力时间
	base.Label.new({text="恢复体力时间", size=18})
	:addTo(self)
	:pos(-150, -45)

	base.Label.new({
		text=string.format("%d分钟", GlobalData.powerRecover / 60), -- 每一点恢复时间（分钟）
		size=18, 
		color=CommonView.color_green(),
	})
	:addTo(self)
	:pos(30, -45)

---------------
	-- 冒号
	for i=1,4 do
		base.Label.new({text="：", size=18})
		:addTo(self)
		:pos(10, -45 + (i - 1) * 30)
	end

end

function PowerInfoLayer:updateShow()
	self.nextLabel:setString(formatTime2(UserData.powerData.next))
	self.allLabel:setString(formatTime2(UserData.powerData.all))
end

function PowerInfoLayer:onEvent(listener)
	self.eventListener_ = listener 
    return self 
end

function PowerInfoLayer:onEvent_(event)
	if not self.eventListener_ then return end 
	event.target = self 
    self.eventListener_(event)
end

function PowerInfoLayer:onEnter()
	
    
end

function PowerInfoLayer:onExit()
	self:onEvent_({name="exit"})
end

return PowerInfoLayer

