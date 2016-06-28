--[[
显示第几次按钮 
]]

local FloorButtonLayer = class("FloorButtonLayer", function()
	return display.newNode()
end)

function FloorButtonLayer:ctor()		
	self:initData()
	self:initView()	
end

function FloorButtonLayer:initData()
	self.selectedIndex = 1 
end 

function FloorButtonLayer:initView()
	-- 左边buff
	self.layers = {}
	local layer = display.newNode():addTo(self):hide()

	display.newSprite("Aincrad_Stage.png"):addTo(layer)
	:flipX(true)
	:align(display.RIGHT_TOP)
	:pos(15, 15)  

	self:createRotateImage()
	:addTo(layer)
	:pos(-250, -97)

	cc.ui.UIPushButton.new({
		normal="Aincrad_Icon_Buff.png",
		pressed="Aincrad_Icon_Buff.png",
		disabled="Aincrad_Icon_Buff.png"
	})	
	:addTo(layer)
	:pos(-250, -97)
	:onButtonClicked(function()
		self:onButtonClicked_()
	end) 

	local label = base.Label.new({size=22, color=CommonView.color_white()}):addTo(layer)
	:align(display.CENTER)
	:pos(-140, -75)
	
	table.insert(self.layers, {
		label = label, 
		layer = layer, 
	})

	-- 右边宝箱 
	layer = display.newNode():addTo(self):hide()

	display.newSprite("Aincrad_Stage.png"):addTo(layer)	
	:align(display.LEFT_TOP)
	:pos(-15, 15) 

	self:createRotateImage()
	:addTo(layer)
	:pos(250, -97)

	cc.ui.UIPushButton.new({
		normal="Aincrad_Icon_Award.png",
		pressed="Aincrad_Icon_Award.png",
		disabled="Aincrad_Icon_Award.png"
	})	
	:addTo(layer)
	:pos(250, -97)
	:onButtonClicked(function()
		self:onButtonClicked_()
	end) 

	label = base.Label.new({size=22, color=CommonView.color_white()}):addTo(layer)
	:align(display.CENTER)
	:pos(140, -75)
	
	table.insert(self.layers, {
		label = label, 
		layer = layer, 
	})

end 

-- 1：左边buff 2：右边宝箱 
function FloorButtonLayer:showIndex(index, text)	
	self.selectedIndex = index 
	text = text or ""
	for i,v in ipairs(self.layers) do
		if i == index then 
			self:showLayer(v, text)			
		else 
			self:hideLayer_(v)
		end 
	end

	return self 
end 

function FloorButtonLayer:showLayer(layer, text)
	layer.layer:show()			 
	layer.label:setString(text or "")	
end 

function FloorButtonLayer:hideLayer(animated)
	local layer 
	for i,v in ipairs(self.layers) do
		if i == self.selectedIndex then 
			layer = v 
			break 
		end 
	end

	if layer then 
		self:hideLayer_(layer)
	end 
end 

function FloorButtonLayer:hideLayer_(layer)
	layer.layer:hide()
end 

function FloorButtonLayer:onButtonClicked_()	
	self:onEvent_({})
end 

function FloorButtonLayer:createRotateImage()	
	local img = display.newSprite("Anicrad_Tag.png")
	img:scale(1.5)
	local action = cc.RepeatForever:create(cc.RotateBy:create(4, 360)) 
	img:runAction(action)
	return img
end 

function FloorButtonLayer:onEvent(listener)
	self.eventListener_ = listener 
	return self 
end 

function FloorButtonLayer:onEvent_(event)
	if not self.eventListener_ then return end 
	event.target = self 
	self.eventListener_(event)
end 

return FloorButtonLayer


