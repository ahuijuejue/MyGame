--[[
旋转体
]]
local RotateItem = import(".RotateItem")
local RotateGrid = class("RotateGrid", function()
	return display.newNode()
end)

function RotateGrid:ctor(options)
	-- body
	self.radius_ = options.radius or 1
	self.items_ = {}
	self.itemsLayer_ = display.newNode():addTo(self):zorder(5)
	self.angle_ = 0.01
	self.canMove_ = true 
	self.idx_ = 0

	base.Grid.new():addTo(self)		
	:onTouch(function(event)		
		if event.name == "moved" then 
			self:onEvent({name="move"})
			local offY = event.x - event.prevX
			self:addAngle(offY / display.width * 360)
			self:updateItems()

		elseif event.name == "ended" then 
			if event.touchTarget.bDrag_ then 
				self:homeItems()
			else 
				local item = self.items_[self.idx_]
				if item then 
					local box = item:getCascadeBoundingBox()
					local rect = cc.rect(box.x, box.y, box.width, box.height)
					local pos = cc.p(event.x, event.y)
					
					if cc.rectContainsPoint(rect, pos) then 
						self:onEvent({name="clicked", index=self.idx_})			
					end 
				end 
			end
		end 
	end, cc.size(display.width * 2, display.height * 2))
end

-- 更新单元坐标
function RotateGrid:homeItems(animate)	
	if animate == nil then 
		animate = true 
	end 
	local angle, index = self:getNear()
	if animate then 
		self.canMove_ = false 
		self:onEvent({name="move"})
		local offAngle = angle - self.angle_ 
		local aOff = offAngle / 10
		self:scheduleTimes(function()
			self:addAngle(aOff)
			self:updateItems()
		end, 0.03, 10, function()
			self:setAngle(angle)
			self:updateItems()
			self.canMove_ = true 
			self.idx_ = index 
			self:onEvent({name="moveEnd", index=index})			
		end)
	else 
		self:setAngle(angle)
		self:updateItems()
		self.idx_ = index 
		self:onEvent({name="moveEnd", index=index})
	end 

	return self 
end 

function RotateGrid:getCurrentIndex()
	return self.idx_
end 

function RotateGrid:toAngle(angle, animate, completedFunc)	
	if animate then 
		self:onEvent({name="move"})
		self.canMove_ = false 	
		local offAngle = angle - self.angle_ 
		local aOff = offAngle / 10
		self:scheduleTimes(function()
			self:addAngle(aOff)
			self:updateItems()
		end, 0.03, 10, function()
			self:setAngle(angle)
			self:updateItems()
			self.canMove_ = true 
			if completedFunc then 
				completedFunc()			
			end 
		end)
	else 
		self:setAngle(angle)
		self:updateItems()		
		if completedFunc then 
			completedFunc()			
		end 
	end 

	return self 
end 

function RotateGrid:showPrevious(animate)
	if not self.canMove_ then return self end 

	local aAngle = math.round(360 / #self.items_)
	local angle = self.angle_ + aAngle 
	self:toAngle(angle, animate, function()		
		self:homeItems(false)
	end)

	return self 
end

function RotateGrid:showNext(animate)
	if not self.canMove_ then return self end 

	local aAngle = math.round(360 / #self.items_)
	local angle = self.angle_ - aAngle 
	self:toAngle(angle, animate, function()
		self:homeItems(false)
	end)

	return self 
end

function RotateGrid:showIndex(index, animate)
	if not self.canMove_ then return self end 

	local aAngle = math.round(360 / #self.items_)
	local angle = 360 - aAngle * (index - 1)
	self:toAngle(angle, animate, function()
		self:homeItems(false)
	end)

	return self 
end

function RotateGrid:setRadius(radius)
	self.radius_ = radius
	return self 
end

function RotateGrid:getNear()
	local aAngle = math.round(360 / #self.items_)
	local index = math.round(self.angle_ / aAngle)
	local angle = index * aAngle
	if index <= 0 then 
		index = index + #self.items_	
	end 
	index = #self.items_ - index + 1
	return angle, index
end

function RotateGrid:setAngle(angle)
	self.angle_ = angle 
	if self.angle_ >= 360 then 
		self.angle_ = self.angle_ - 360
	elseif self.angle_ < 0 then 
		self.angle_ = self.angle_ + 360
	end 
	return self 
end

function RotateGrid:addAngle(angle)
	self:setAngle(self.angle_ + angle)
	
	return self 
end

--@param item 是 RotateItem
function RotateGrid:addItem(itemFunc)
	local item = RotateItem.new()
	itemFunc(item)

	item:addTo(self.itemsLayer_)
	table.insert(self.items_, item)
	
	return self 
end
--[[
	:addItems(5, function(item, index)
		item:addSprite(display.newSprite(string.format("s_%d.png", index)))
	end)
]]
function RotateGrid:addItems(count, itemFunc)
	local item 
	for i=1,count do
		item = RotateItem.new()
		itemFunc(item, i)
		
		item:addTo(self.itemsLayer_)
		table.insert(self.items_, item)
	end
		
	return self 
end

function RotateGrid:removeAllItems()
	self.itemsLayer_:removeAllChildren()
	self.items_ = {}

	return self 
end

function RotateGrid:updateItems()
	local count = #self.items_ 
	local aAngle = math.round(360 / count)
	for i=1,count do
		self:setItemWithAngle(self.items_[i], aAngle * (i - 1) + self.angle_)
	end

	return self 
end 

function RotateGrid:setItemWithAngle(item, angle)	
	local pos = cc.pForAngle(math.angle2radian(angle))
	pos = cc.pRotate({x=0, y= -self.radius_}, pos)
	self:setItemWithPos(item, pos)
	
	return self 
end

function RotateGrid:setItemWithPos(item, pos)
	local y = self.radius_ - pos.y
	local scale = y / (self.radius_ * 2) * 0.6 + 0.4 -- 0.5 到 1
	local color = scale * 255

	item:pos(pos.x, 0)
	:zorder(math.round(y))	
	:scale(scale)	
	item:setColor(cc.c3b(color, color, color))
end

function RotateGrid:onTouch(listener)
	self.eventListener_ = listener 
	return self
end 

function RotateGrid:onEvent(event)
	if not self.eventListener_ then return end 
	event.target = self 
	self.eventListener_(event)	
end 

return RotateGrid 







