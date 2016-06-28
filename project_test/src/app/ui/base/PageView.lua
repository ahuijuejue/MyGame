--[[
分页table
]]
local UIScrollView = require("framework.cc.ui.UIScrollView")

local PageView = class("PageView", UIScrollView)
--[[
@params table 参数表
-scale number 最大部位放大比例
-baseScale float 初始缩放 (只针对 添加的item)
-itemSize cc.size 单个单元尺寸
-offsetX number 放大位置，相对于viewRect, 默认中间
-anchorY number 单元上下偏移比例

]]

function PageView:ctor(params)
	params.direction = UIScrollView.DIRECTION_HORIZONTAL
	PageView.super.ctor(self, params)

	self.items_ = {}

	self.selectedIndex_ = 0
	self.maxIndex_ = 0

	self.scale = params.scale or 1.3
	self.baseScale = params.baseScale or 1
	self.itemSize = params.itemSize 
	self.offsetX = params.offsetX
	self.anchorY = params.anchorY or 0.5
	self.container = cc.Node:create()
	self:addScrollNode(self.container)
	self:onScroll(handler(self, self.scrollListener))

	self.isScrolling = false

	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(...)
			self:update_(...)
		end)
	self:scheduleUpdate()

	self.freeItems = {}

	self:setNodeEventEnabled(true)
end 

function PageView:reloadData()	
	self:removeItems_(function( ... )
		return true
	end)
	self.selectedIndex_ = 0
	
	return self 
end 

function PageView:getFreeItem(flag)
	flag = flag or "default"
	local items = self.freeItems[flag]
	if items and #items > 0 then 
		local item = table.remove(items)
		self:performWithDelay(function()
			item:release()
		end, 0)		
		return item
	end 
	return nil 
end


function PageView:addItems(count, itemFunc)
	if count <= 0 then return self end 
	self.maxIndex_ = count
	self.getItemFunc = itemFunc
	
	local w = (count - 1) * self.itemSize.width + self.viewRect_.width 
	self.container:size(w, self.viewRect_.height)

	return self 
end

--[[
	重置位置 和 清空本地信息
]]
function PageView:reset()	
	local x, y = self.container:getPosition()
	self.container:pos(0, y)

	return self 
end 

function PageView:removeItem(item)
	local idx = table.indexof(self.items_, item)
	if idx then 
		self:removeItem_(idx)
	end 
end 

--@param idx 位于数组第几个
function PageView:removeItem_(idx)
	local item = table.remove(self.items_, idx)
	local freeName = item:getFreeFlag()
	if not self.freeItems[freeName] then 
		self.freeItems[freeName] = {}
	end 
	table.insert(self.freeItems[freeName], item)
	item:retain()
    item:removeFromParent(false)
end 

function PageView:removeItems_(func)
	local idx = #self.items_
	while (idx > 0) do 
		if func(self.items_[idx], idx) then 
			self:removeItem_(idx)
		end
		idx = idx - 1		
	end 
end 

function PageView:haveItem(idx)	
	return self:getItemAtIndex(idx) ~= nil 
end 

function PageView:getItemAtIndex(idx)
	for i,v in ipairs(self.items_) do
		if v:getIndex() == idx then 
			return v 
		end 
	end
	return nil 
end 

function PageView:updateCellAtIndex(idx)
	local item = self:getItemAtIndex(idx)
	if item then 
		self:removeItem(item)
	end 

	item = self.getItemFunc(self, idx)
	item:setIndex(idx)
	item:addTo(self.container)
	table.insert(self.items_, item)	
end 

function PageView:onTouch(listener)
	self.eventListener_ = listener

    return self
end

function PageView:scrollIndex(index, animate)
	if animate == nil then 
		animate = true 
	end 	
	transition.stopTarget(self.container)
	local y = self.container:getPositionY()
	local x = self:lenByIndex(index) * (-1)
	if animate then 
		transition.moveTo(self.container,
		{x = x, y = y, time = 0.3,
		easing = "sineOut",
		onComplete = function()
			self:scrollEnd()
		end,
		})
	else 
		self.container:pos(x, y)
		self:scrollEnd()
	end 

	return self
end

function PageView:scrollEnd()
	self:updateItemSize()
	self:updateSelectedChange()
	self.isScrolling = false
end 

function PageView:updateToSelected()
	local index = self:currentIndex()	
	self:scrollIndex(index, false)

	return self 
end 

function PageView:update_( ... )
	if self.isScrolling then 
		self:updateItemSize()
		self:updateSelectedChange()
	end 
end

function PageView:updateItemSize()
	local c_x = self.viewRect_.width * 0.5 

	local i_w = self.itemSize.width -- 单个物品宽度
	local i_h = self.itemSize.height -- 单个物品宽度
	local a_w = (self.scale - 1) * i_w * 0.5 -- 单个物品最大时 增加的宽度
	local x = self.container:getPositionX() -- 滚动层的坐标
	
	local index = 0
	if x >= 0 then 
		if x < i_w * 0.5 + a_w then 
			index = 1
		end  
	else 
		local pX = -x 
		index = pX / i_w + 1
	end 

	local posX = 0
	local posY = self.viewRect_.height * 0.5 
	local offset = 0
	local absOff = 0
	local addX = 0	
	local addScale = self.scale - 1
	local offY = (self.anchorY - 0.5) * i_h
	local offX = self.offsetX or c_x
	local scale = 0

	local startIdx = self:getStartIndex()
	local endIdx = self:getEndIndex()

	if startIdx < 1 then 
		startIdx = 1 
	end 

	if endIdx >= self.maxIndex_ then 
		endIdx = self.maxIndex_
	end 

	self:removeItems_(function(item, idx)
		if item:getIndex() < startIdx or item:getIndex() > endIdx then 
			return true 
		end 
		return false
	end)

	for i=startIdx, endIdx do
		if not self:haveItem(i) then 
			self:updateCellAtIndex(i)
		end 
	end


	for i,v in ipairs(self.items_) do
		local idx = v:getIndex()
		posX = (idx-1) * i_w + offX
		offset = idx - index 
		absOff = math.abs(offset)
		if offset == 0 then 
			addX = 0
		else 
			addX = offset / absOff * a_w 
		end 

		if absOff < 1 then 
			scale = (1 - absOff) * addScale + 1
			v:pos(posX + offset * a_w, posY + (1 - scale) * offY)
			v:scale(scale * self.baseScale)
		else 
			v:pos(posX + addX, posY)
			v:scale(self.baseScale)
		end 		
	end

end

function PageView:updateSelectedChange() 
	local index = self:currentIndex()
	if self.selectedIndex_ ~= index and #self.items_ > 0 then 
		self:_eventListener({name="change", 
			preIndex=self.selectedIndex_, 
			preItem=self:getItemAtIndex(self.selectedIndex_),
			index=index, 			
			item=self:getItemAtIndex(index),
		})	
		self.selectedIndex_ = index
	end 
end 

function PageView:scrollListener(event)
	if "moved" == event.name then
		if self.bDrag_ then 
			self.isScrolling = true
		end 
	elseif event.name == "ended" then 
		if #self.items_ == 0 then return end 		

		local x, y = self.container:getPosition() -- 滚动层的坐标		
		-- print(self.speed.x)
		x = x + self.speed.x * 6
		local index = 1
		if x < 0 then 
			index = self:indexByLen(-x)			
		end 
		self:scrollIndex(index)

	elseif event.name == "clicked" then
		if #self.items_ == 0 then return end 
		-- print("clicked")
		local index = self:currentIndex()		
		local item = self:getItemAtIndex(index)
		if item then 			
			local box = item:getCascadeBoundingBox()
			local rect = cc.rect(box.x, box.y, box.width, box.height)
			local pos = cc.p(event.x, event.y)
			
			if cc.rectContainsPoint(rect, pos) then 
				self:_eventListener({name="selected", index=index})			
			end 
		end 
	end 
	self:_eventListener(event)	
end

function PageView:indexByLen(len)
	local index = self:_indexByLen(len)
	index = math.min(index, self.maxIndex_)
	return index
end

function PageView:_indexByLen(len)
	local index = math.round(len / self.itemSize.width) + 1	
	return index
end

function PageView:currentIndex()
	local index = 1 
	local x, y = self.container:getPosition()
	if x < 0 then 
		index = self:indexByLen(-x)
	end 
	return index
end

function PageView:currentItem()
	local index = self:currentIndex()
	local item = self:getItemAtIndex(index)
	return item
end

function PageView:getStartIndex()
	local x, y = self.container:getPosition()
	local width = self.viewRect_.width

	return self:_indexByLen(-x-width*0.5)
end

function PageView:getEndIndex()
	local x, y = self.container:getPosition()
	local width = self.viewRect_.width

	return self:_indexByLen(width*0.5 - x)
end

function PageView:lenByIndex(index)
	if index == nil then index = 1 end 
	return (index - 1) * self.itemSize.width
end

function PageView:_eventListener(event)
	if not self.eventListener_ then
		return
	end
	event.target = self

	self.eventListener_(event)
end

function PageView:onCleanup()
	for i,v in ipairs(self.freeItems) do
		v:release()
	end	
end

return PageView





