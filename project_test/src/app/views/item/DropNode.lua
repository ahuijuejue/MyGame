local DropNode = class("DropNode",function ()
	return display.newNode()
end)

local boardImage = "DropWay_Banner.png"

function DropNode:ctor(stage)
	self._stage = stage
	self:createBoardView()
	self:stageInfo()
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(false)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,handler(self,self.nodeOnTouch))
end

function DropNode:createBoardView()
	self.boardSprite = display.newSprite(boardImage)
	self.boardSprite:setAnchorPoint(0,0)
	local size = self.boardSprite:getContentSize()
	self:addChild(self.boardSprite)
	self:setContentSize(size)
end

function DropNode:stageInfo()
	local text_ = {}
	if self._stage.chapterInfo.Type == 1 then 
		text_ = GET_TEXT_DATA("TEXT_NORMAL")..self._stage.chapterInfo.Sort.."-"..self._stage.sort
		if self._stage.sort2 ~= 0 then
			text_ = text_.."-"..self._stage.sort2
		end
	elseif self._stage.chapterInfo.Type == 2 then
		text_ = GET_TEXT_DATA("TEXT_ELITE")..self._stage.chapterInfo.Sort.."-"..self._stage.sort
		if self._stage.sort2 ~= 0 then
			text_ = text_.."-"..self._stage.sort2
		end
	end

	local titleLabel = createOutlineLabel({text = text_, size = 24})
	titleLabel:setPosition(72,100)
	titleLabel:setColor(display.COLOR_GREEN)
	self.boardSprite:addChild(titleLabel)

	local nameLabel = createOutlineLabel({text = self._stage.name, size = 22})
	nameLabel:setPosition(72,60)
	self.boardSprite:addChild(nameLabel)

	local textParam = {}
	local openLv = self._stage.chapterInfo.NeedLevel
	if ChapterData:isStageOpen(self._stage.id) then
		textParam = {
			text = string.format(GET_TEXT_DATA("DROP_GOTO"),openLv),
			size = 20, 
			color = display.COLOR_GREEN
		}
	else
		textParam = {
			text = string.format(GET_TEXT_DATA("DROP_NOT_OPEN"),openLv),
			size = 20, 
			color = display.COLOR_RED
		}
	end
	local openLabel = createOutlineLabel(textParam)
	openLabel:setPosition(72,20)
	self.boardSprite:addChild(openLabel)
end

function DropNode:nodeOnTouch(event)
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
			if ChapterData:isStageOpen(self._stage.id) then
			 	app:pushToScene("MissionScene",true,{{chapterId = self._stage.chapterId,stageId = self._stage.id}})
			else
				local param = {text = GET_TEXT_DATA("DROP_NOT_OPEN"),size = 30,color = display.COLOR_RED}
	            showToast(param)
			end
		end
		self.isTouchInNode = false
	end
end

function DropNode:touchInNode(point)
	return cc.rectContainsPoint(self.boardSprite:getCascadeBoundingBox(),point)
end

return DropNode