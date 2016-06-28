
local UIScrollView = require("framework.cc.ui.UIScrollView")
local UIListView = require("framework.cc.ui.UIListView")
local ListView = class("ListVIew", UIListView)


--[[--

滚动控件的构建函数

可用参数有：

-   direction 滚动控件的滚动方向，默认为垂直方向可滚动
-   viewRect 列表控件的显示区域
-   scrollbarH 水平方向的滚动条
-   scrollbarV 垂直方向的滚动条
-   bgColor 背景色,nil表示无背景色
-   bgStartColor 渐变背景开始色,nil表示无背景色
-   bgEndColor 渐变背景结束色,nil表示无背景色
-   bg 背景图
-   bgScale9 背景图是否可缩放
-	capInsets 缩放区域
-	itemSize 增加的单元的尺寸
-	page 是否开启分隔功能
- 	freeMode 是否使用删除的部分保存在缓存里


@param table params 参数表


使用 
base.ListView.new({
		viewRect = cc.rect(0, 0, 350, 290),
		itemSize = cc.size(130, 130),
	})
:onTouch(function(event)
	if event.name == "clicked" then
		if event.itemPos then
			local item = event.item:getContent()
			local index = event.itemPos			
		end
	end
end)
:addItems(10, function(event)
	return display.newNode()
end)
:reload()
]]

function ListView:ctor(params)
	params = params or {}
	if params.direction == "horizontal" then 
		params.direction = UIScrollView.DIRECTION_HORIZONTAL
	elseif params.direction == "both" then 
		params.direction = UIScrollView.DIRECTION_BOTH
	else
		params.direction = UIScrollView.DIRECTION_VERTICAL
	end 	
	params.alignment = params.alignment or UIListView.ALIGNMENT_VCENTER
	params.viewRect = params.viewRect or cc.rect(0, 0, display.width, display.height)

	ListView.super.ctor(self, params)

	if params.scrollbarH then 
		self.sbH = params.scrollbarH
	end
	if params.scrollbarV then 
		self.sbV = params.scrollbarV
	end 
	
	self.itemSize = params.itemSize or cc.size(10, 10)
	-- scroll bar 是否消失
	self.scrollBarCanDisappear = false

	self.pageEnabled = params.page 
	self.freeMode = params.freeMode 

	self.touchNode_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)		
		return self:onPage_(event)
	end)
	
	self:setNodeEventEnabled(true)

end

function ListView:setItemSize(size)
	self.itemSize = size
	return self 
end 

function ListView:addItems(count, getItemFunc)	
	local grid
	for i=1,count do
		local item = getItemFunc({target=self, index=i})
		grid = self:newItem(item):zorder(2)
		grid:setItemSize(self.itemSize.width, self.itemSize.height)
		self:addItem(grid)
		-- dump(grid:getContentSize(), "size")
	end
	return self
end

function ListView:addSizeItem(size, getItemFunc)
	local item = getItemFunc({target=self})
	local grid = self:newItem(item):zorder(2)	
	grid:setItemSize(size.width, size.height)
	self:addItem(grid)
	
	return self
end

function ListView:removeAllItems()	
	self.container:removeAllChildren()
	self.items_ = {}
	
	return self
end

function ListView:itemAtIndex(index)	
	local item = self.items_[index]
	return item:getContent()
end

function ListView:setScrollBarPosition(x, y)
	pX = x or 0
	pY = y or 0
	v = self.sbV and self.sbV:setPosition(pX, pY)
	v = self.sbH and self.sbH:setPosition(pX, pY)
	return self	
end

-- function ListView:enableScrollBar()
-- 	print("enable scroll bar")
-- 	ListView.super.enableScrollBar(self)	
-- 	-- if self.sbV then
-- 	-- 	local x, y = self.sbV:getPosition()
-- 	-- 	self.sbV:setPosition(0, y)
		
-- 	-- end	
-- end
--[[
尺寸是否在视窗内，如果没有，则显示
]]
function ListView:setScrollPosition(lenth, itemLength, animated)
	itemLength = itemLength or 0

	local cascadeBound = self.container:getCascadeBoundingBox()	
	local viewRect = self:getViewRectInWorldSpace()
	local posX, posY = self.container:getPosition()	
	
	if self.DIRECTION_VERTICAL == self.direction then
		local bottomY = -posY
		local topY = bottomY + viewRect.height - itemLength 
		local itemY = cascadeBound.height - lenth 

		if itemY <= bottomY then 
			posY = -itemY
		elseif itemY > topY then 
			posY = viewRect.height - itemY - itemLength
		end 
	else 
		local bottomX = -posX
		local topX = bottomX + viewRect.width - itemLength 
		local itemX = lenth 

		if itemX <= bottomX then 
			posX = -itemX 
		elseif itemX > topX then 
			posY = viewRect.width - itemX
		end
	end 

	if animated then 
		transition.moveTo(self.container, {time=0.3, x=posX, y=posY})
	else 
		self.container:setPosition(posX, posY)
	end 

	return self 
end

function ListView:setScrollPosition2(lenth, animated)
	itemLength = itemLength or 0

	local cascadeBound = self.container:getCascadeBoundingBox()	
	local viewRect = self:getViewRectInWorldSpace()
	local posX, posY = self.container:getPosition()	
	
	if self.DIRECTION_VERTICAL == self.direction then				
		posY = lenth + viewRect.height - cascadeBound.height 		 
	else 				
		posX = -lenth 		
	end 

	if animated then 
		transition.moveTo(self.container, {time=0.3, x=posX, y=posY})
	else 
		self.container:setPosition(posX, posY)
	end 

	return self 
end

function ListView:reload()
	print("reload")
	ListView.super.reload(self)
	self:updateScrollBarSize_()
	self:updateScrollBarPosition_()
	self:updateScrollBarShow_(self.scrollBarCanDisappear)
	return self
end

function ListView:setScrollBarCanDisappear(b)
	self.scrollBarCanDisappear = b
	-- print("list dis:", b)
	if b then 
		self:disableScrollBar()
	end 
end

function ListView:enableScrollBar()
	-- print(self.container:getPosition())
	self:updateScrollBarShow_(false)
end

function ListView:disableScrollBar()
	-- print("disable bar", self.scrollBarCanDisappear)
	if self.scrollBarCanDisappear then
		-- ListView.super.disableScrollBar(self)
		-- print("disable bar")
		if self.sbV then
			transition.fadeOut(self.sbV, 
				{time = 0.5,
				onComplete = function()
					self.sbV:setOpacity(255)
					self.sbV:setVisible(false)
			end})
		end
		if self.sbH then
			transition.fadeOut(self.sbH,
				{time = 1.5,
				onComplete = function()
					self.sbH:setOpacity(255)
					self.sbH:setVisible(false)
				end})
		end
	end
end

function ListView:drawScrollBar()
	if not self.bDrag_ then
		return
	end
	if not self.sbV and not self.sbH then
		return
	end

	self:updateScrollBarPosition_()
	self:updateScrollBarShow_(true)
end

function ListView:updateScrollBarSize_()
	
	local bound = self.scrollNode:getCascadeBoundingBox()
	if self.sbV then		
		transition.stopTarget(self.sbV)		
		local size = self.sbV:getContentSize()
		if self.viewRect_.height < bound.height then
			local ratioH = self.viewRect_.height/bound.height			
			-- self.sbV:length(self.viewRect_.height)
			self.sbV:sliderSizeRatio(ratioH)
		end
	end
	if self.sbH then		
		transition.stopTarget(self.sbH)		
		local size = self.sbH:getContentSize()
		if self.viewRect_.width < bound.width then
			local ratioW = self.viewRect_.width/bound.width
			-- self.sbH:length(self.viewRect_.width)
			self.sbH:sliderSizeRatio(ratioW)			
		end
	end
end

function ListView:updateScrollBarPosition_()
	local bound = self.scrollNode:getCascadeBoundingBox()	
	if self.sbV then
		local scrollY = self.scrollNode:getPositionY()
		self.sbV:setVisible(true)
		local posY = (self.viewRect_.y - scrollY)/(bound.height - self.viewRect_.height)					
		self.sbV:sliderPositionRatio(posY)	
		
	end
	if self.sbH then
		self.sbH:setVisible(true)
		local scrollX = self.scrollNode:getPositionX()
		local posX = (self.viewRect_.x - scrollX)/(bound.width - self.viewRect_.width)		
		self.sbH:sliderPositionRatio(posX)
	end
end

function ListView:updateScrollBarShow_(show)
	if self.sbV then
		if self.scrollNode:getCascadeBoundingBox().height > self.viewRect_.height + 1 then
			if self.scrollBarCanDisappear then
				self.sbV:setOpacity(255)
				self.sbV:setVisible(show)
			end
		else
			self.sbV:setVisible(false)
		end				
	end
	if self.sbH then
		if self.scrollNode:getCascadeBoundingBox().width > self.viewRect_.width + 1 then
			if self.scrollBarCanDisappear then
				self.sbH:setOpacity(255)
				self.sbH:setVisible(show)
			end
		else
			self.sbH:setVisible(false)
		end
	end
end

------------
--page set
function ListView:setPageEnabled(enabled)
	self.pageEnabled = enabled 
	return self 
end 

function ListView:isPageEnabled()
	return self.pageEnabled 
end 

function ListView:onPage_(event)	
	if self.pageEnabled then 		
		if event.name == "began" then 
			self.pageDrag_ = false 
			self.prevX_ = event.x
			self.prevY_ = event.y
			return true 
		elseif "moved" == event.name then
			if self:isShake(event) then
				return
			end

			self.pageDrag_ = true

		elseif event.name == "ended" then 			
			if self.pageDrag_ then
				self.pageDrag_ = false 
				if #self.items_ == 0 then return end 	

				self:onPageEnd_(event)
			end 
		end 
	end 
end 

function ListView:onPageEnd_(event)
	local scrollNode = self:getScrollNode()
	local x, y = scrollNode:getPosition() -- 滚动层的坐标	
	-- dump(self.speed, "speed")
	
	y = y + self.speed.y * 6

	local itemSize = self.itemSize
	local nItems = table.nums(self.items_)
	if self.rows then 
		nItems = math.ceil(nItems / self.rows)
	end 
	
	local viewRect = self:getViewRectInWorldSpace()
	if self.DIRECTION_VERTICAL == self.direction then
		y = y + self.speed.y * 6	
		local useLen = nItems * itemSize.height - viewRect.height				
		if y < 0 then 												
			if useLen > 0 then 
				local nCount = math.round((useLen+y) / self.itemSize.height)							
				local moreLen = useLen - nCount * self.itemSize.height  
				if nCount >= 0 and (moreLen >= 0 or -moreLen < self.itemSize.height) then 
					y=-moreLen 
				else 								
					y = -useLen
				end 	
			else 
				y = -useLen								
			end 
		else 
			y = 0
			if useLen < 0 then 
				y = -useLen
			end 
		end 
		-- print("\n\n\nstop action\n\n")
		transition.stopTarget(scrollNode)
		transition.moveTo(scrollNode,
			{x=x, y=y, time = 0.3,
			easing = "sineOut",
			onComplete = function()
				self:notifyListener_{name = "page_ended", target=self}									
			end})	
	else
		x = x + self.speed.x * 6
		if x < 0 then
			local useLen = nItems * itemSize.width - viewRect.width
			if useLen > 0 then 
				local nCount = math.round(-x / self.itemSize.width)
				local moreLen = useLen - nCount * self.itemSize.width  
				if nCount >= 0 and (moreLen >= 0 or -moreLen < self.itemSize.width) then 
					x=-nCount * self.itemSize.width
				else 
					local nNum = math.round(useLen / self.itemSize.width)
					x = -nNum * self.itemSize.width
				end 	
			else 
				x = 0												
			end 
		else 
			x = 0
		end 
		-- print("\n\n\nstop action\n\n")
		transition.stopTarget(scrollNode)
		transition.moveTo(scrollNode,
			{x=x, y=y, time = 0.3,
			easing = "sineOut",
			onComplete = function()
				self:notifyListener_{name = "page_ended", target=self}									
			end}
		)	
	end 
end

-- over write
-- 是否显示到边缘
function ListView:isSideShow()
	local bound = self.scrollNode:getCascadeBoundingBox()
	local posX, posY = self.scrollNode:getPosition()
	if posY > self.viewRect_.x
		or posY > self.viewRect_.y
		or posX + bound.width < self.viewRect_.x + self.viewRect_.width
		or posY + bound.height < self.viewRect_.y + self.viewRect_.height then
		return true
	end

	return false
end

function ListView:onCleanup()
	
end

return ListView