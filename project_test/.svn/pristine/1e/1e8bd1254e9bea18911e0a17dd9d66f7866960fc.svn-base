--[[
任务选择条
]]
local SealGrid = class("SealGrid", base.TableNode)

function SealGrid:ctor(params)
	params = params or {}
	SealGrid.super.ctor(self, params)
	-- print("\n\nnew flag:", params.flag)
	self:initView(params)
end

function SealGrid:initView(params)

	self.iconName = ""
	self.icon = nil

	self.borderName = ""
	self.border = nil

	self.flagName = ""
	self.flagImg = nil
	self.size = params.size or 18

	self.costLabel = base.Label.new({size = self.size})
	:align(display.RIGHT_CENTER)
	:pos(60, -33)
	:addTo(self, 5)

	self.subBtn = display.newSprite("Item_Reduce.png")
	:addTo(self, 5)
	:pos(40, 30)
	:onTouch(function(event)
        CommonSound.click() -- 音效

        self:onSubButtonEvent_({name="reduce"})
    end)


end

function SealGrid:setIcon(name)
	if self:checkName(name, "iconName", "icon") then
		self.icon = display.newSprite(name)
		:addTo(self)
		:zorder(2)
	end
	return self
end

function SealGrid:setBorder(name)
	if self:checkName(name, "borderName", "border") then
		self.border = display.newSprite(name)
		:addTo(self)
	end

	return self
end

function SealGrid:setItemFlag(name)
	if self:checkName(name, "flagName", "flagImg") then
		if name then
			self.flagImg = display.newSprite(name)
			:addTo(self)
			:zorder(3)
			:pos(-45, 40)
		end
	end
end

function SealGrid:setCount(num, numMax)
	local str = string.format("%d/%d", num, numMax)
	self.costLabel:setString(str)
	return self
end

function SealGrid:onSubButtonEvent(listener)
	self.subListener_ = listener
	return self
end

function SealGrid:showSubButton(show)
	self.subBtn:setVisible(show)
	return self
end

--------------------------------------
--------------------------------------

function SealGrid:onSubButtonEvent_(event)
	if not self.subListener_ then return end
	event.target = self
	self.subListener_(event)
end

return SealGrid
