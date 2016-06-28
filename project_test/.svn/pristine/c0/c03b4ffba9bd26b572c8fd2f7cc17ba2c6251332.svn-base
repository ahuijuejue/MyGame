--
-- Author: zsp
-- Date: 2015-07-30 16:10:34
--
--[[
	战斗剧情对话
--]]
local BattlePlotTalkLayer = class("BattlePlotTalkLayer",function()
    return display.newNode()
end)
function BattlePlotTalkLayer:ctor(customId)
	--按类型构造剧情的对话结构
	self.keys = {}
	for k,v in pairs(GameConfig.Plot_Talk) do
		if v.StageID == customId  then
			if self.keys[v.Type] == nil then
				self.keys[v.Type] = {}
			end
			table.insert(self.keys[v.Type],k)
		end
	end

	--关卡有剧情
	if table.nums(self.keys) > 0 then
		--安剧情顺第一句放在队列尾部的顺序 方便移除
		function comps(a,b)
			return GameConfig.Plot_Talk[a].Order > GameConfig.Plot_Talk[b].Order
		end

		for k,v in pairs(self.keys) do
			table.sort(self.keys[k],comps)
		end
	end
	self.isTalk = false
end

--[[
	战斗开始对话
--]]
function BattlePlotTalkLayer:onBattleStart(callback)
	self:onBattleTalk("1",callback)
end

--[[
	boss出现时的对话
--]]
function BattlePlotTalkLayer:onBoss(callback)
	self:onBattleTalk("2",callback)
end

--[[
	战斗结束对话
--]]
function BattlePlotTalkLayer:onBattleEnd(callback)
	self:onBattleTalk("3",callback)
end

--[[
	按类型显示剧情对话
--]]
function BattlePlotTalkLayer:onBattleTalk(type,callback)
	local tb = self.keys[type]
	if tb == nil or table.nums(tb) == 0 then
		self.isTalk = false
		if callback then
			callback()
			return
		end
		return
	end
	self.isTalk = true
	local key = tb[table.nums(tb)]
	local talk = GameConfig.Plot_Talk[key]
	table.remove(tb)
	self:showTalk(checkint(talk.Sort),talk.Image,talk.Expression,talk.Name,talk.Info,function()
		self:onBattleTalk(type,callback)
	end)
end

--[[
	显示剧情对话
--]]
function BattlePlotTalkLayer:showTalk(camp,image,expression,name,info,callback)
	local layer =  display.newColorLayer(cc.c4b(0, 0,0,200))
    layer:addTo(self)
	layer:setTouchSwallowEnabled(true)
    layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	    if event.name == "began" then
	        return true
	    elseif event.name == "ended" then
	    	if callback then
		    	callback()
		    end
	    	layer:removeFromParent(true)
	    end
	end)

	local shading = display.newSprite("Plot_Shading.png")
	shading:setPosition(display.cx,0)
	shading:setAnchorPoint(0.5,0)
	shading:addTo(layer)

	if camp == 1 then
		local imageSprite = display.newSprite(image)
		imageSprite:setAnchorPoint(0,0)
		imageSprite:setPosition(0,0)
		imageSprite:addTo(layer)

		if expression then
			local expressionSprite = display.newSprite(expression)
			expressionSprite:setPosition(imageSprite:getContentSize().width,400)
			expressionSprite:addTo(layer)
		end

        local nameLabel = base.TalkLabel.new({
	    		text  = name,
				size  = 30,
	    	})

		nameLabel:setAnchorPoint(0,0.5)
		nameLabel:setPosition(450,187)
		nameLabel:setColor(cc.c3b(255,255,255))
		nameLabel:addTo(layer)

	    local infoLabel = base.TalkLabel.new({
	    		text  = info,
				size  = 24,
				dimensions = cc.size(400, 0),
	    	})
		infoLabel:setAnchorPoint(0,1)
		infoLabel:setPosition(490,158-32*infoLabel:getLines())
		infoLabel:setColor(cc.c3b(255,255,255))
		infoLabel:addTo(layer)
	else
		local imageSprite = display.newSprite(image)
		imageSprite:setFlippedX(true)
		imageSprite:setAnchorPoint(1,0)
		imageSprite:setPosition(display.width,0)
		imageSprite:addTo(layer)

		if expression then
			local expressionSprite = display.newSprite(expression)
			expressionSprite:setPosition(display.width-imageSprite:getContentSize().width,400)
			expressionSprite:addTo(layer)
		end

		local nameLabel = base.TalkLabel.new({
	    		text  = name,
				size  = 30,
	    	})

		nameLabel:setAnchorPoint(0,0.5)
		nameLabel:setPosition(30,187)
		nameLabel:setColor(cc.c3b(255,255,255))
		nameLabel:addTo(layer)

		local infoLabel = base.TalkLabel.new({
	    		text  = info,
				size  = 24,
				dimensions = cc.size(400, 0),
	    	})
		infoLabel:setAnchorPoint(0,1)
		infoLabel:setPosition(70,158-32*infoLabel:getLines())
		infoLabel:setColor(cc.c3b(255,255,255))
		infoLabel:addTo(layer)
	end
end

return BattlePlotTalkLayer