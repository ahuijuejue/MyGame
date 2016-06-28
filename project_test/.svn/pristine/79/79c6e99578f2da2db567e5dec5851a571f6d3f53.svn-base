--
-- Author: zsp
-- Date: 2015-05-08 15:56:23
--

--[[
	竞技场结算 历史最高弹层
--]]
local HistoryTopLayer = class("HistoryTopLayer",function()
     return display.newColorLayer(cc.c4b(0, 0,0,100))
end)

function HistoryTopLayer:ctor(params)
	local dialog = display.newSprite("Levelup_Board.png")
	dialog:setPosition(display.cx,display.cy + 20)
	dialog:setScale(0)
	dialog:addTo(self)

	local size = dialog:getContentSize()

	local title = display.newSprite("Word_history.png")
	title:setPosition(cc.p(size.width * 0.5,size.height))
	title:addTo(dialog)

	self.rankOldName = display.newTTFLabel({
		text  = "历史最高排名：",
		size  = 25,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.rankOldName:setAnchorPoint(1,0.5)
	self.rankOldName:setPosition(260,240)
	self.rankOldName:setColor(cc.c3b(255,255,255))
	self.rankOldName:addTo(dialog)

	self.rankOldLabel = display.newTTFLabel({
		text  = tostring(params.rankOld),
		size  = 25,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.rankOldLabel:setAnchorPoint(0,0.5)
	self.rankOldLabel:setPosition(270,240)
	self.rankOldLabel:setColor(cc.c3b(255,255,255))
	self.rankOldLabel:addTo(dialog)

	self.rankName = display.newTTFLabel({
		text  = "当前排名：",
		size  = 25,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.rankName:setAnchorPoint(1,0.5)
	self.rankName:setPosition(260,180)
	self.rankName:setColor(cc.c3b(255,255,255))
	self.rankName:addTo(dialog)

	self.rankLabel = display.newTTFLabel({
		text  = tostring(params.rank),
		size  = 25,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.rankLabel:setAnchorPoint(0,0.5)
	self.rankLabel:setPosition(270,180)
	self.rankLabel:setColor(cc.c3b(255,255,255))
	self.rankLabel:addTo(dialog)

	self.upNumLabel = display.newTTFLabel({
		text  = string.format("(↑%d)", math.abs(params.rankOld - params.rank)),
		size  = 25,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.upNumLabel:setAnchorPoint(0,0.5)
	self.upNumLabel:setPosition(360,180)
	self.upNumLabel:setColor(cc.c3b(0,255,0))
	self.upNumLabel:addTo(dialog)

	if params.diamond > 0  then

		self.gemName = display.newTTFLabel({
			text  = "可领取奖励：",
			size  = 25,
			align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
		})
		self.gemName:setAnchorPoint(1,0.5)
		self.gemName:setPosition(260,120)
		self.gemName:setColor(cc.c3b(255,255,255))
		self.gemName:addTo(dialog)

		self.gemLabel = display.newTTFLabel({
			text  = string.format("%d宝石", params.diamond),
			size  = 25,
			align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
		})
		self.gemLabel:setAnchorPoint(0,0.5)
		self.gemLabel:setPosition(270,120)
		self.gemLabel:setColor(cc.c3b(255,255,255))
		self.gemLabel:addTo(dialog)

		self.gemInfo = display.newTTFLabel({
			text  = "该奖励通过邮件发放",
			size  = 20,
			align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
		})
		self.gemInfo:setAnchorPoint(0.5,0.5)
		self.gemInfo:setPosition(size.width * 0.5,60)
		self.gemInfo:setColor(cc.c3b(255,255,0))
		self.gemInfo:addTo(dialog)
	end
	
	local closeBtn = CommonButton.close()
	closeBtn:setPosition(570,300)
	closeBtn:addTo(dialog)
	closeBtn:onButtonClicked(function(event)
		self:removeFromParent()
    end)

	dialog:runAction(cc.Sequence:create(cc.ScaleTo:create(0.3,1.5),cc.ScaleTo:create(0.2,1)))
	AudioManage.playSound("AccountLevelUp.mp3",false)
end

return HistoryTopLayer