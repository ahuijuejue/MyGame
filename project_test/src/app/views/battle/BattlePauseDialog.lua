--
-- Author: zsp
-- Date: 2015-01-14 11:24:11
--
--[[
	战斗场景暂停框
--]]
local BattlePauseDialog = class("BattlePauseDialog",function()
    return display.newColorLayer(cc.c4b(0, 0,0,200))
end)

function BattlePauseDialog:ctor()
	self:setNodeEventEnabled(true)

	self.dialog = display.newSprite("Friends_Tips.png")
	self.dialog:setPosition(display.cx,display.cy)
	self.dialog:addTo(self)

	local dialogSize = self.dialog:getContentSize()

	self.content = display.newTTFLabel({
	    text = "",
	    size = 30,
	    align = cc.TEXT_ALIGNMENT_CENTER,
	    valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER,
	    dimensions = cc.size(400, 300)
	})

	self.content:addTo(self.dialog)
	self.content:setPosition(dialogSize.width * 0.5,dialogSize.height * 0.5 + 30)


	self.resumeButton = CommonButton.green("继续")
	self.resumeButton:setPosition(dialogSize.width * 0.5 - 100,80)
	self.resumeButton:addTo(self.dialog)

    self.exitButton = CommonButton.red("退出")
    self.exitButton:setPosition(dialogSize.width * 0.5 + 100,80)
	self.exitButton:addTo(self.dialog)
end

function BattlePauseDialog:setContent(text)
	self.content:setString(text)
end

function BattlePauseDialog:getDialogSize()
	return self.dialog:getContentSize()
end

return BattlePauseDialog