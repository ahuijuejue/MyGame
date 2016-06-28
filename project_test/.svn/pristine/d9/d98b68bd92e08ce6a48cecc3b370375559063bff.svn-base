--
-- Author: zsp
-- Date: 2015-05-11 11:37:00
--

local GuideLayer = class("GuideLayer", function()
	return display.newNode()
end)

--[[
	新手引导效果层 
--]]
function GuideLayer:ctor()
	self:setNodeEventEnabled(true)
end

function GuideLayer:onExit()
end

--[[
	w,h 设置矩形区域 
	x,y 屏幕绝对坐标
	trigger 设置要出发的按钮 trigger要有doClick方法
--]]
function GuideLayer:showRect(w,h,x,y,trigger, autoRemove)
	local area = display.newSprite("guide_rect.png")
	local sx = w / area:getContentSize().width
	local sy = h / area:getContentSize().height
	area:setScale(sx,sy)
	self:showGuideArea(area,x,y,trigger, autoRemove)

	return self
end

--[[
	d 设置圆形区域直径 
	x,y 屏幕绝对坐标
	trigger 设置要出发的按钮 trigger要有doClick方法
--]]
function GuideLayer:showCicle(d,x,y,trigger, autoRemove)
	local area = display.newSprite("guide_cicle.png")
	local s = d / area:getContentSize().width
	area:setScale(s)
	self:showGuideArea(area,x,y,trigger, autoRemove)

	return self
end

--[[
	设置显示区域
--]]
function GuideLayer:showGuideArea(area,x,y,trigger, autoRemove)
	if autoRemove == nil then autoRemove = true end  
	local maskLayer =  cc.LayerColor:create(cc.c4b(0, 0, 0, 180))
	maskLayer:setContentSize(display.width,display.height)
	area:setPosition(x, y)
	area:setBlendFunc(gl.ZERO,gl.ONE_MINUS_SRC_ALPHA)

 	local render = cc.RenderTexture:create(display.width,display.height);
	render:begin();
	maskLayer:visit();
	area:visit();
	render:endToLua();
	render:setTouchEnabled(true)
	render:setPosition(display.cx,display.cy)
	render:addTo(self)
	

	local node = display.newNode()
    local layer = cc.LayerColor:create(cc.c4b(255, 255, 0, 0))
    layer:ignoreAnchorPointForPosition(false)
    layer:setContentSize(area:getCascadeBoundingBox().size)    
   -- layer:setVisible(false)
    layer:addTo(node)
    node:addTo(self)
    node:setPosition(x,y)
    node:setTouchEnabled(true)
    node:setTouchSwallowEnabled(true)   
	node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	    if event.name == "began" then
	    	print("点击执行了引导~")
	    	if autoRemove then 
	    		self:removeFromParent() 
	    	end 
	    	if trigger then 
	    		if type(trigger) == "function" then 
	    			trigger({target=self})
	    		elseif trigger.doClick then  
	    			trigger:doClick()
	    		end 
	    	end 	    	
	        return true
	    end
	end)
	--end

	return self
end

--[[
	设置指示的手
--]]
function GuideLayer:showFinger(x,y, ani)
	local sp = display.newSprite("guide_finger.png")
	sp:setPosition(x,y)
	sp:setAnchorPoint(cc.p(0,1))
	sp:addTo(self)

	if ani then 
		sp:runAction(ani)
	end 

	return self
end

--[[
	战斗向左移动提示剪头 
	fn 点击后回调
--]]
function GuideLayer:showLeftArrow(fn)
	local node2 = display.newNode()
    local layer2 = cc.LayerColor:create(cc.c4b(0, 0, 0, 100))
    layer2:setContentSize(display.width * 0.5 ,display.height)
   -- layer:setVisible(false)
    layer2:addTo(node2)
    node2:addTo(self)
    node2:setPosition(display.width * 0.5,0)
    node2:setTouchEnabled(true)
	node2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	    if event.name == "began" then
	        return false
	    end
	end)

	local node = display.newNode()
    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 0))
    layer:setContentSize(display.width * 0.5 ,display.height)
   -- layer:setVisible(false)
    layer:addTo(node)
    node:addTo(self)
    node:setPosition(0, 0)
    node:setTouchEnabled(true)
    node:setTouchSwallowEnabled(false)

    local sp = display.newSprite("guide_arrow.png")
	sp:setPosition(200, display.cy)
	sp:setScale(-1)
	sp:addTo(node)
	sp:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeOut:create(0.5),cc.FadeIn:create(0.5))))

	node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	    if event.name == "began" then
	    	print("点击执行了引导~")
	    
	    	self:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.CallFunc:create(function()
	    		sp:stopAllActions()
	    		node:setVisible(false)
	    		node2:setVisible(false)

	    		if fn then
		    		fn()
		    	end
	    	end)))
	    	
	        return true
	    end

	    if event.name == "ended" then
	    	self:stopAllActions()
	    end
	end)


	return self
end

--[[
	战斗向右移动提示剪头 
	fn 点击后回调
--]]
function GuideLayer:showRightArrow(fn)
	local node2 = display.newNode()
    local layer2 = cc.LayerColor:create(cc.c4b(0, 0, 0, 100))
    layer2:setContentSize(display.width * 0.5 ,display.height)
   -- layer:setVisible(false)
    layer2:addTo(node2)
    node2:addTo(self)
    node2:setPosition(0,0)
    node2:setTouchEnabled(true)
	node2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	    if event.name == "began" then
	        return false
	    end
	end)


	local node = display.newNode()
    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 0))
    layer:setContentSize(display.width * 0.5 ,display.height)
    layer:addTo(node)
    node:addTo(self)
    node:setPosition(display.width * 0.5,0)
    node:setTouchEnabled(true)
   	node:setTouchSwallowEnabled(false)   

	local sp = display.newSprite("guide_arrow.png")
	sp:setPosition(display.width * 0.5 - 200,display.cy)
	sp:addTo(node)
	sp:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeOut:create(0.5),cc.FadeIn:create(0.5))))

	node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	    if event.name == "began" then
	    	print("点击执行了引导~")
	    		    	
	    	self:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.CallFunc:create(function()
	    		sp:stopAllActions()
	    		node:setVisible(false)
	    		node2:setVisible(false)

	    		if fn then
		    		fn()
		    	end
	    	end)))

	        return true
	    end

	    if event.name == "ended" then
	    	self:stopAllActions()
	    end

	end)

	return self

end

--[[
	go 提示
--]]
function GuideLayer:showGo()
	local sp = display.newSprite("guide_go.png")
	sp:setPosition(display.width - 200, display.cy)
	sp:addTo(self)
	sp:setVisible(false)
	sp:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.Show:create(),
		cc.FadeOut:create(0.5),
		cc.FadeIn:create(0.5),
		cc.FadeOut:create(0.5),
		cc.RemoveSelf:create(),
		cc.CallFunc:create(function()
			self:removeFromParent()
		end)
	))
	return self
end

--[[
 todo 提示文字 
--]]
function GuideLayer:showTip(text,x,y)
	local param = {text = text, x = x, y = y}
	local guideNode = showBattleGuide(param):addTo(self)

	return self
end

--[[
	todo 显示对话 精简代码
--]]
function GuideLayer:showTalk(camp,head,text,x,y,fn)
	
	local node = display.newNode()
    local layer = cc.LayerColor:create(cc.c4b(255, 0, 0, 0))
    layer:setContentSize(display.width,display.height)
    layer:addTo(node)
    node:addTo(self)
    node:setTouchEnabled(true)

    node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	    if event.name == "began" then
	    	print("点击执行了引导~")
	    		    	
	    	if fn then
		    	fn()
		    end
		    self:removeFromParent()
	        return true
	    end
	end)


	local size = cc.size(400, 100)
    local sprite = display.newScale9Sprite("guide_tip.png",0,0,size)
	sprite:setPosition(x,y)
	sprite:addTo(self)
	sprite:setLocalZOrder(1)

	local label =  display.newTTFLabel({
			  text  = text,
			  size  = 18,
			  align = cc.TEXT_ALIGNMENT_LEFT,
		      valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER,
		      dimensions = cc.size(size.width - 150, size.height - 20)
		})
		label:setColor(cc.c3b(255, 255, 255))
		label:setAnchorPoint(0,0.5)
		label:addTo(sprite)


	local border = display.newSprite("HeroCircle5.png")
	border:setAnchorPoint(0.5,0)
	border:addTo(sprite)

	local icon = display.newSprite(head)
	icon:setPosition(border:getContentSize().width * 0.5,border:getContentSize().height * 0.5)
	icon:addTo(border)

	if camp == 1 then
		
		label:setPosition(100,size.height * 0.5)
	else
		label:setPosition(20,size.height * 0.5)
		border:setPosition(size.width,0)
		icon:setFlippedX(true)
		
	end

	return self

end

--[[
	遮罩层
--]]
function GuideLayer:showMask()
	display.pause()

	local node = display.newNode()
    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 100))
    layer:addTo(node)
    node:addTo(self)
    node:setTouchEnabled(true)
    node:setTouchSwallowEnabled(true)   
	node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	    if event.name == "began" then
	    	print("点击执行了引导~")
	    	display.resume()
	    	self:removeFromParent()
	        return true
	    end
	end)

	return self
end

--[[
	添加某节点
--]]
function GuideLayer:showNode(node)
	node:addTo(self)
	return self
end

--[[
	清除全部
--]]
function GuideLayer:clear()
	self:removeAllChildren()
	return self
end


return GuideLayer