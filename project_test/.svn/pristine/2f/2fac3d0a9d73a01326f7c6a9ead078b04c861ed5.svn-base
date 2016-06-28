local AlertLayer = class("AlertLayer",function ()
	return display.newLayer()
end)

local NodeBox = import(".NodeBox")

local boxImage = "Friends_Tips.png"
local redImage1 = "Button_Cancel.png"
local redImage2 = "Button_Cancel_Light.png"
local greenImage1 = "Button_Enter.png"
local greenImage2 = "Button_Enter_Light.png"

function AlertLayer:ctor(title,msg,callback)
	self.status = 0
	self.touchIndex = 0
	self.callback = {}
	self.btns = {}
	self.image = {}

	self.listener = cc.EventListenerTouchOneByOne:create()
	self.listener:setSwallowTouches(true)
	self.listener:registerScriptHandler(handler(self,self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
	self.listener:registerScriptHandler(handler(self,self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
	self.listener:registerScriptHandler(handler(self,self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
	self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self.listener,self)

	self:createBox()
	self:createTitle(title)
	self:createMessage(msg)
	self:createButtons(callback)
end

function AlertLayer:onTouchBegan(touch,event)
	local point = touch:getLocation()
	for i,v in ipairs(self.btns) do
		if self.btns[i]:getCascadeBoundingBox():containsPoint(point) then
			self.touchIndex = i
			local image = self.image[i].pressed
			ResManage.loadImage(image)
			self.btns[i]:setTexture(image)
		    ResManage.removeImage(image)
		    self.status = 1
			return true
		end
	end
	return true
end

function AlertLayer:onTouchMoved(touch,event)
	local image
	local isChange = false
	local point = touch:getLocation()
	if self.touchIndex ~= 0 then
		if self.btns[self.touchIndex]:getCascadeBoundingBox():containsPoint(point) then
			image = self.image[self.touchIndex].pressed
			if self.status == 2 then
				isChange = true
				self.status = 1
			end
		else
			image = self.image[self.touchIndex].normal
			if self.status == 1 then
				isChange = true
				self.status = 2
			end
		end
		if isChange then
			ResManage.loadImage(image)
			self.btns[self.touchIndex]:setTexture(image)
		    ResManage.removeImage(image)
		end
	end
end

function AlertLayer:onTouchEnded(touch,event)
	local point = touch:getLocation()
	if self.touchIndex ~= 0 then
		if self.btns[self.touchIndex]:getCascadeBoundingBox():containsPoint(point) then
			self:getEventDispatcher():removeEventListener(self.listener)
			
			local image = self.image[self.touchIndex].normal
			ResManage.loadImage(image)
			self.btns[self.touchIndex]:setTexture(image)
		    ResManage.removeImage(image)

		    AudioManage.playSound("Click.mp3")
			self.callback[self.touchIndex](self)
		end
		self.touchIndex = 0
		self.status = 0
	end
end

function AlertLayer:createBox()
	self.box = display.newSprite(boxImage)
	self.box:setPosition(display.cx,display.cy)
	self:addChild(self.box)

	self.size = self.box:getContentSize()
	self.width = self.size.width
	self.height = self.size.height
end

function AlertLayer:createTitle(title)
	self.title = display.newTTFLabel({text = title, size = 28})
	self.title:setPosition(self.width/2,self.height-50)
	self.box:addChild(self.title)
end	

function AlertLayer:createMessage(msg)
	self.msg = display.newTTFLabel({
		text = msg, 
		size = 22, 
		align = cc.ui.TEXT_ALIGN_LEFT,
		dimensions = cc.size(420, 200)})
	self.msg:setPosition(self.width/2,210)
	self.msg:setAnchorPoint(0.5,1)
	self.box:addChild(self.msg)
end

function AlertLayer:createButtons(callback)
	if callback.cancel then
		table.insert(self.btns,self:createButton(redImage1,GET_TEXT_DATA("TEXT_CANCEL")))
		table.insert(self.callback,callback.cancel)
		table.insert(self.image,{normal = redImage1,pressed = redImage2})
	end
	if callback.sure then
		table.insert(self.btns,self:createButton(greenImage1,GET_TEXT_DATA("TEXT_SURE")))
		table.insert(self.callback,callback.sure)
		table.insert(self.image,{normal = greenImage1,pressed = greenImage2})
	end
	if #self.btns > 0 then
		local nodeBox = NodeBox.new()
	    nodeBox:setPosition(self.width/2,50)
	    nodeBox:setCellSize(cc.size(220,65))
	    nodeBox:setUnit(#self.btns)
		nodeBox:addElement(self.btns)
		self.box:addChild(nodeBox)
	end
end

function AlertLayer:createButton(image,text)
	local sprite = display.newSprite(image)
	local label = createOutlineLabel({text = text,size = 20})
	local x = sprite:getContentSize().width/2
	local y = sprite:getContentSize().height/2
	label:setPosition(x,y)
	sprite:addChild(label)
	return sprite
end

return AlertLayer