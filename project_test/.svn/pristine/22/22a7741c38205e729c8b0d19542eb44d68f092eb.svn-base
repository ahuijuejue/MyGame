local ItemNode = class("ItemNode",function ()
	return display.newNode()
end)

local bgImage = "AwakeStone%d.png"
local coinImage = "HeroStone.png"
local stuffImage = "Stuff.png"
local numImage = "Banner_Level.png"

function ItemNode:ctor(item)
	self.item = item

	self.bgSprite = self:createBg(item.configQuality)
	self:addChild(self.bgSprite)

	local posX = self.bgSprite:getContentSize().width/2
	local posY = self.bgSprite:getContentSize().height/2

	local icon = self:createIcon(item.imageName)
	icon:setPosition(posX,posY)
	self.bgSprite:addChild(icon)

	local countSprite = self:createCount(item.count)
	countSprite:setPosition(120-countSprite:getContentSize().width/2,15)
	self.bgSprite:addChild(countSprite,2)

	if self.item.type == 1 then
		local stone = display.newSprite(coinImage)
		stone:setPosition(12,100)
		self.bgSprite:addChild(stone,2)
	elseif self.item.type == 3 then
		local stuff = display.newSprite(stuffImage)
		stuff:setPosition(12,100)
		self.bgSprite:addChild(stuff,2)
	end

	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(false)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,handler(self,self.nodeOnTouch))
end

function ItemNode:createBg(quality)
	local image = string.format(bgImage,quality)
	local sprite = display.newSprite(image)
	sprite:setScale(0.75)
	sprite:setAnchorPoint(0,0)
	return sprite
end

function ItemNode:createIcon(image)
	local icon = display.newSprite(image)
	return icon
end

function ItemNode:createCount(count)
	local label = createOutlineLabel({text = count,size = 28})
	return label
end

function ItemNode:setCallBack(func)
	self.callBack = func
end

function ItemNode:setSelect(func)
	self.select = func
end

function ItemNode:touchInNode(point)
	return self.bgSprite:getCascadeBoundingBox():containsPoint(point)
end

function ItemNode:nodeOnTouch(event)
	local  point = {x = event.x, y =event.y}
	if event.name == "began" then
		self.beganX = point.x
		self.beganY = point.y
		if self:touchInNode(point) then
			self.isTouchInNode = true
		end
		return self.isTouchInNode
	elseif event.name == "moved" then
		local moveX = point.x
		local moveY = point.y
		if math.abs(self.beganX - moveX) > 10 or math.abs(self.beganY - moveY) > 10 then
			self.isTouchInNode = false
		end
	elseif event.name == "ended" then
		if self.isTouchInNode and self:touchInNode(point) then
			AudioManage.playSound("Click.mp3")
			if self.callBack then
				self.callBack(self)
			end
		end
		self.isTouchInNode = false
	end
end

return ItemNode