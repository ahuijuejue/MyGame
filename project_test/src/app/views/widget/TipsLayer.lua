--[[
显示物品信息 
]]

local TipsLayer = class("TipsLayer", function()	
	return display.newNode()
end)

function TipsLayer:ctor(params)
	params = params or {}
	
	self:initView()

	self:setTitle(params.title)
	self:setDesc(params.desc)
	self:setPrice(params.price)

	self:setNodeEventEnabled(true)
end

function TipsLayer:initView()	
	-- 背景框
	local back = display.newSprite("Item_Tips.png"):addTo(self)
	:pos(190, 85)

	self:size(382, 167)
	-- 标题
	self.title = base.Label.new({
		size=20,
		x = 20,
		y = 130,
	}):addTo(back)
	-- 描述
	self.desc =  base.Label.new({		
		size = 20,
		dimensions = cc.size(340, 180), 
		align 	= 	cc.TEXT_ALIGNMENT_LEFT,
		x = 20,
		y = 110,
	}):align(display.TOP_LEFT)
	:addTo(back)
	
	-- 金币图标
	self.flagIcon = display.newSprite("Gold.png"):addTo(self)
	:pos(50, 40)
	:scale(1)
	:hide()

	-- 价格 
	self.price = base.Label.new({
		size=20,
		x = 90,
		y = 30,
	}):addTo(back)
	
end

function TipsLayer:setTitle(text)	
	if text then 
		self.title:setString(text)
	end 
	return self 
end

function TipsLayer:setDesc(text)	
	if text then 
		self.desc:setString("说明："..text)
	end 
	return self 
end

function TipsLayer:setPrice(value)	
	if value and value > 0 then 
		local text = tostring(value)
		self.flagIcon:show()
		self.price:setString(text)
	end 
	return self 
end 

function TipsLayer:onEvent(listener)
	self.eventListener_ = listener 
    return self 
end

function TipsLayer:onEvent_(event)
	if not self.eventListener_ then return end 
	event.target = self 
    self.eventListener_(event)
end

function TipsLayer:onEnter()
	
    
end

function TipsLayer:onExit()
	self:onEvent_({name="exit"})
end

return TipsLayer 


