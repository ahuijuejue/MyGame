--[[
点击按钮
]]
local TouchNode = class("TouchNode", function()
	return display.newNode()
end)

function TouchNode:ctor(params)
	params = params or {}
	self.nShakeVal = 5
	self.isAlive = true 

	self.clickedComb = 1
	self.preclickedTime = 0
	self.combDur = 0.3

	self:initView(params)
	self.target = params.target or self

	self:setNodeEventEnabled(true)
end 

function TouchNode:initView(params)
	if params.swallowTouch ~= nil then 
		self:setTouchSwallowEnabled(params.swallowTouch)
	else 
		self:setTouchSwallowEnabled(true)
	end 
	self:setTouchEnabled(true)
	self:onTouch(function(event)
        return self:onTouch_(event)
    end)	
	self:align(display.CENTER)
	
end

----------------------------------------------
----
function TouchNode:onEvent(listener, touchSize)
	self.touchListener_ = listener
	if touchSize then 
		self:setContentSize(touchSize)
	end 
	return self
end

function TouchNode:onLongTouch(listener, time)
	self.longTouchListener_ = listener 
	self.longTouchTime_ = time or 0.8 
	return self
end

function TouchNode:onClicked(listener, touchSize)
	self.clickedListener_ = listener
	if touchSize then 
		self:setContentSize(touchSize)
	end 
	return self
end

----------------------------------------------
-----
function TouchNode:isShake(event)
	if math.abs(event.x - self.prevX_) < self.nShakeVal
		and math.abs(event.y - self.prevY_) < self.nShakeVal then
		return true
	end
end

--[[
@x y 世界坐标点  或 点击坐标点
]]
function TouchNode:hiteTest(x, y)
	local point = self:convertToNodeSpace(cc.p(x,y))	
	local nodeRect = self:getBoundingBox()
	local rect = cc.rect(0,0,0,0)
	rect.width = nodeRect.width 
	rect.height = nodeRect.height
	 	
	if cc.rectContainsPoint(rect, point) then
        return true
    end	    
	
	return false
end 

function TouchNode:onTouch_(event)
	if "began" == event.name then		
		self.bDrag_ = false
		self.prevX_ = event.x
		self.prevY_ = event.y
		self:_onEvent({name="began", x=event.x, y=event.y})
		self:beganLong()
		return true
	elseif "moved" == event.name then
		if self:isShake(event) then
			return
		end		
		self.bDrag_ = true
		self:_onEvent({name="moved", x=event.x, y=event.y, prevX=event.prevX, prevY=event.prevY})
		self:endedLong()

	elseif "ended" == event.name then				
		if not self.bDrag_ then						
			if self:hiteTest(event.x, event.y) then 
				local curTime = os.time()
	        	if curTime - self.preclickedTime > self.combDur then
	        		self.clickedComb = 1
	        	else 
	        		self.clickedComb = self.clickedComb + 1        		
	        	end  
	        	self.preclickedTime = curTime 

				self:_onEvent({name="clicked", x=event.x, y=event.y, comb=self.clickedComb})
				if self.isAlive and self.clickedListener_ then 
					self:_onClicked({name="clicked", target=self, x=event.x, y=event.y, comb=self.clickedComb})
				end 
			end 
		end	
		if self.isAlive and self._onEvent then 
			self:_onEvent({name="ended", x=event.x, y=event.y})
		end 

		if self.isAlive then 
			self:endedLong()
			self.bDrag_ = false	
		end 
	end	
end

function TouchNode:beganLong()
	if self.longTouchListener_ then 
		self.isLongTouch_ = false 
		self.longTouchEvent_ = self:performWithDelay(function()
			self.longTouchEvent_ = nil 
			self.isLongTouch_ = true  
			self:onLongTouchBegan_({name="began"})
		end, self.longTouchTime_)
	end 
end 

function TouchNode:endedLong()
	if self.longTouchListener_ then 
		if self.isLongTouch_ then 
			self.isLongTouch_ = false 
			self:onLongTouchEnded_({name="ended"}) 
		end 
		if self.longTouchEvent_ then 
			self:stopAction(self.longTouchEvent_)
			self.longTouchEvent_ = nil 
		end 
	end 
end 

function TouchNode:onLongTouchBegan_(event)
	if not self.longTouchListener_ then return end 
	event.target = self.target 
	event.touchTarget = self
	self.longTouchListener_(event)
end 

function TouchNode:onLongTouchEnded_(event)
	if not self.longTouchListener_ then return end 
	event.target = self.target 
	event.touchTarget = self
	self.longTouchListener_(event)
end 

function TouchNode:_onEvent(event)	
	if not self.touchListener_ then return end 
	event.target = self.target 
	event.touchTarget = self
	self.touchListener_(event)
end 

function TouchNode:_onClicked(event)	
	if not self.clickedListener_ then return end 
	event.target = self.target 	
	event.touchTarget = self	
	self.clickedListener_(event)	
end 

-------------------------------------------
function TouchNode:onEnter()
	self.isAlive = true     
end

function TouchNode:onExit()
	self.isAlive = false 
end
-------------------------------------------

return TouchNode
