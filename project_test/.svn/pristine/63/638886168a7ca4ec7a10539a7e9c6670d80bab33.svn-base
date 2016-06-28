local GafNode = class("GafNode",function()
    return display.newNode()
end)

function GafNode:ctor(param)
	self.isTouchInNode = false
	self.gafX = 0
	self.gafY = 0
	self.gafWidth = param.width or 0
	self.gafHeight = param.height or 0
	self.callback = param.callback

	local zipPath = param.gaf..".zip"
	local gafPath = param.gaf.."/"..param.gaf..".gaf"
	local asset = gaf.GAFAsset:createWithBundle(zipPath,gafPath)
	self.gafNode = asset:createObject()
	local posX = asset:getSceneWidth()*-0.5
	local posY = asset:getSceneHeight()-440
	self.gafNode:setPosition(posX,posY)
	self.gafNode:start()
	self:addChild(self.gafNode)

	self:setTouchEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,handler(self,self.onTouch))
	self:addNodeEventListener(cc.NODE_EVENT,function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)
end

function GafNode:setGafPosition(x,y)
	self.gafX = x - self.gafWidth/2
	self.gafY = y - self.gafHeight/2
	self:setPosition(x,y)
end

function GafNode:setGafScaleX(scale)
	self.gafNode:setPosition(self.gafX*scale,self.gafY)
	self.gafNode:setScaleX(scale)
end

function GafNode:playAction(action,isLoop)
	self.gafNode:playSequence(action,isLoop)
end

function GafNode:actFinish(name)
	if self.actCallback then
		self.actCallback(name)
	end
end

function GafNode:setFps(fps)
	self.gafNode:setFps(fps)
end

function GafNode:setActCallback(callback)
	self.actCallback = callback
end

function GafNode:onTouch(event)
	local  point = {x = event.x, y =event.y}
	if event.name == "began" then
		if self:touchInNode(point) then
			self.isTouchInNode = true
			self:setTouchSwallowEnabled(true)
		else
			self:setTouchSwallowEnabled(false) 
		end
		return self.isTouchInNode
	elseif event.name == "ended" then
		if self.isTouchInNode and self:touchInNode(point) then
			AudioManage.playSound("Click.mp3")
			if self.callback then
				self.callback()
			end
		end
		self.isTouchInNode = false
	end
end

function GafNode:touchInNode(point)
	local rect = {x = self.gafX,y = self.gafY,width = self.gafWidth,height = self.gafHeight}
	return cc.rectContainsPoint(rect,point)
end

function GafNode:onEnter()
	self.gafNode:enableTick(true)
	self.gafNode:setSequenceDelegate(handler(self,self.actFinish))
end

function GafNode:onExit()
	self.gafNode:enableTick(false)
	self.gafNode:setSequenceDelegate(nil)
end

return GafNode