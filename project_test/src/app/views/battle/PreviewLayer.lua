--
-- Author: zsp
-- Date: 2015-06-08 15:56:50
--
local BattleEvent = require("app.battle.BattleEvent")
--[[
	护送关卡 逃跑关卡预览显示层
--]]
local PreviewLayer = class("PreviewLayer",function()
    return display.newNode()
end)

function PreviewLayer:ctor(params) --(team,followNode)

	self.endPoint   = params.endPoint --终点
	BattleManager.setTargetWidth(self.endPoint)

	local bgLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
	bgLayer:ignoreAnchorPointForPosition(false)
	bgLayer:setAnchorPoint(0.5,0.5)
	bgLayer:setContentSize(220,40)
	bgLayer:addTo(self)

	self.boxLayer = cc.LayerColor:create(cc.c4b(255, 0, 0, 0))
	self.boxLayer:ignoreAnchorPointForPosition(false)
	self.boxLayer:setAnchorPoint(0.5,0.5)
	self.boxLayer:setContentSize(200,30)
	self.boxLayer:addTo(self)

	self:setContentSize(bgLayer:getContentSize())

	local flag = display.newSprite("flag.png")
	flag:setAnchorPoint(0,0)
	flag:addTo(self.boxLayer)
	flag:setPosition(self.boxLayer:getContentSize().width,0)

	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onUpdate))
    self:scheduleUpdate()

    self.label =  display.newTTFLabel({
		text  = string.format("目标距离：0/%d",self.endPoint),
		size  = 15,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.label:setAnchorPoint(0,0.5)
	self.label:setColor(cc.c3b(255, 255, 0))
	self.label:setPosition(-70,10)
	self.label:addTo(self)

    self.frame = 0
end

function PreviewLayer:onUpdate(dt)
	
	self.frame = self.frame + 1

	if self.frame%20 ~= 0 then
		return
	end

	if self.follow then

		if self.evolveFollow and self.evolveFollow:isActive() then
			self.follow = self.evolveFollow
		else
			self.follow = self.follow_
		end

		local w =  math.max(BattleManager.targetWidth - self.follow:getPositionX(),0)
		w = math.min(BattleManager.targetWidth,w)
		local x = self.boxLayer:getContentSize().width - w / BattleManager.targetWidth * self.boxLayer:getContentSize().width
		self.followIcon:setPositionX(x)

	    self.label:setString(string.format("目标距离：%d/%d",BattleManager.targetWidth - w,BattleManager.targetWidth))
		
		if x >= self.boxLayer:getContentSize().width then
			--todo
			self:unscheduleUpdate()
			--发送护送结束事件
		    BattleEvent:dispatchEvent({
		       name  = BattleEvent.ESCORT_END,
		       role  = self.follow
		    })
		end
	end

	if self.charser then
		local w =  math.max(BattleManager.targetWidth - self.charser:getPositionX(),0)
		w = math.min(BattleManager.targetWidth,w)
		local x = self.boxLayer:getContentSize().width - w / BattleManager.targetWidth * self.boxLayer:getContentSize().width
		self.charserIcon:setPositionX(x)
	end
end

--function PreviewLayer:updatePosition(node,icon)

function PreviewLayer:addFollow(follow)
	self.follow = follow
	self.followIcon = cc.LayerColor:create(cc.c4b(0, 255, 0, 255))
	self.followIcon:setContentSize(10,10)
	self.followIcon:addTo(self.boxLayer)

	self.follow_ = follow
	if self.follow.evolveNode then
		self.evolveFollow = self.follow.evolveNode
	end
end

function PreviewLayer:addCharser(charser)
	self.charser = charser
	self.charserIcon = cc.LayerColor:create(cc.c4b(255, 255, 0, 255))
	self.charserIcon:setContentSize(10,10)
	self.charserIcon:addTo(self.boxLayer)
end

return PreviewLayer