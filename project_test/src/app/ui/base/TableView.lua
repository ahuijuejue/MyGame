--[[
table view
]]

local UIScrollView = require("framework.cc.ui.UIScrollView")
local TableView = class("TableView", UIScrollView)
local TableViewItem = import(".TableViewItem")
local GridNode = import(".GridNode")

function TableView:ctor(params)
	params = params or {}

	local reverseType = 0

	if params.direction == nil then 
		params.direction = "vertical"
	end 
	if params.direction == "vertical" then 
		params.direction = self.DIRECTION_VERTICAL
		reverseType = 1
	else	
		params.direction = self.DIRECTION_HORIZONTAL
		reverseType = 2
	end 
	params.viewRect = params.viewRect or cc.rect(0, 0, display.width, display.height)
	TableView.super.ctor(self, params)

	self.itemFunc_ = nil
	self.freeItems = {}

	self.pageEnabled = params.page -- 支持分格

	self.realSize_ = nil 
	self.container = cc.Node:create()
	self:addScrollNode(self.container)
	self:onScroll(handler(self, self.scrollListener))

	self.isupdated = false
	self.isScrolling = false
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(...)
			self:update_(...)
		end)
	self:scheduleUpdate()


	self.gridNode = GridNode.new({
		ver = params.rows or 1,
		itemSize = params.itemSize,
		reverse = reverseType,
	})
	:onEvent(function(event)
		if event.name == "removeItem" then 
			self:addFreeItem(event.item)
		end 
	end)
	:addTo(self.container)

	self:setNodeEventEnabled(true)

end

function TableView:resetData()	
	self.gridNode:resetData()	
	
	return self 
end 

function TableView:reload()		
	self:layout_()
	self:scrollViewDidScroll()
	return self 
end 

function TableView:getRealSize()
	return self.realSize_
end

function TableView:setRealSize(size)
	self.realSize_ = size 
	self.container:setContentSize(size)
end

function TableView:addItems(count, getItemFunc)	
	self.gridNode:setCount(count)
	self.itemFunc_ = getItemFunc

	self:setRealSize(self.gridNode:getSize())
	-- dump(self:getRealSize(), "real size")

	return self
end

function TableView:addFreeItem(item)
	local flag = item:getFreeFlag()
	if not self.freeItems[flag] then 
		self.freeItems[flag] = {}
	end 
	item:retain()
	table.insert(self.freeItems[flag], item)
end 

function TableView:getFreeItem(flag)
	if flag == nil then flag = "default" end
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

function TableView:removeFreeItems()
	for k,v in pairs(self.freeItems) do
		for i,w in ipairs(v) do
			w:release()
		end
	end
	self.freeItems = {}
end 

function TableView:onTouch(listener)
	self.eventListener_ = listener

    return self
end

function TableView:haveItem(idx)	
	return self:getItemAtIndex(idx) ~= nil 
end 

function TableView:getItemAtIndex(idx)
	return self.gridNode:getItemIf(function(event)
		return idx == event.item:getIndex()
	end)
end 

function TableView:updateItemAtIndex(idx)
	-- print("update:", idx)
	self.gridNode:removeItemIf(function(item)
		if item:getIndex() == idx then 
			return true
		end 
	end)

	local item = self.itemFunc_({target=self, index=idx})
	self.gridNode:addItem(item)
	item:setIndex(idx)
	self.gridNode:setIndexForItem(idx, item)
end

function TableView:indexOnOffset(offset)	
	return self.gridNode.gridSize:indexOnOffset(offset)	
end

function TableView:indexFromOffset(offset)	
	return self.gridNode.gridSize:indexFromOffset(offset)	
end

function TableView:scrollListener(event)
	if "moved" == event.name then
		if self.bDrag_ then 
			self.isScrolling = true			
		end 

	elseif event.name == "ended" then 
		if #self.gridNode.items_ == 0 then return end 		

		local x, y = self.container:getPosition() -- 滚动层的坐标		
		-- print(self.speed.x)
		x = x + self.speed.x * 6
		y = y + self.speed.y * 6

		if self.pageEnabled then 
			self:onPage_(event, x, y)
		else 
			self:scrollOffset(cc.p(x, y), true)
		end 

	elseif event.name == "clicked" then
		if #self.gridNode.items_ == 0 then return end 
		-- print("clicked")
		local point = cc.p(event.x, event.y)
		point = self.container:convertToNodeSpace(point)
		local idx = self:indexFromOffset(point)
		if idx > 0 and idx <= self.gridNode:getCount() then 
			local item = self:getItemAtIndex(idx)
			if item then 				
				self:_eventListener({name="selected", index=idx, item=item})	
			end 
		end
	end 
	self:_eventListener(event)	
end

function TableView:onPage_(event, x, y)
	local fy = self.viewRect_.height
	local posX, posY = self.gridNode.gridSize:offsetRoundOffset(cc.p(-x, fy-y))
	posY = posY - fy
	self:scrollOffset(cc.p(-posX, -posY), true)
end 

--@param offset container 正常坐标
--@param forced 是否强制刷新
function TableView:scrollOffset(offset, animate, forced)	 	
	transition.stopTarget(self.container)

	local posX, posY = self.gridNode.gridSize:correctScrollOffset(offset.x, offset.y, self.viewRect_)

	transition.stopTarget(self.container)
	if animate then 		
		transition.moveTo(self.container,
		{x = posX, y = posY, time = 0.3,
		easing = "sineOut",
		onComplete = function()
			self:scrollEnd(forced)
		end,
		})
	else 
		self.container:pos(posX, posY)
		self:scrollEnd(forced)
	end 

	return self
end

function TableView:scrollEnd(forced)
	if forced or self.isupdated then 
		self.isupdated = false 
		self:scrollViewDidScroll()
	end
	self.isScrolling = false
end 

function TableView:scrollViewDidScroll()
	if self.gridNode:getCount() == 0 then return end 

	local posX1, posY1 = self.container:getPosition()
	posX1 = -posX1 - 10
	posY1 = -posY1 - 10
	local posX2 = posX1 + self.viewRect_.width + 10
	local posY2 = posY1 + self.viewRect_.height + 10
	local startIdx = self:indexOnOffset(cc.p(posX1, posY1))
	local _, endIdx = self:indexOnOffset(cc.p(posX2, posY2))
	if endIdx < startIdx then 
		local tmpI = startIdx 
		startIdx = endIdx 
		endIdx = tmpI
		tmpI = nil
	end 

	if startIdx < 1 then 
		startIdx = 1 
	end 

	if endIdx >= self.gridNode:getCount() then 
		endIdx = self.gridNode:getCount()
	end 

	self.gridNode:removeItemsIf(function(item, idx)
		if item:getIndex() < startIdx - self.gridNode:getVertical() or item:getIndex() > endIdx + self.gridNode:getVertical() then 
			return true 
		end 
		return false
	end)

	for i=startIdx, endIdx do
		if not self:haveItem(i) then 
			self:updateItemAtIndex(i)
		end 
	end
end

function TableView:layout_()
	local posX, posY = self.container:getPosition()
	if self.direction == self.DIRECTION_VERTICAL then 
		posY = self.viewRect_.height - self:getRealSize().height
	else 
		posX = 0
	end 
	self.container:setPosition(cc.p(posX, posY))
	-- print("set pos:", posX, posY)
end 

function TableView:update_( ... )
	if self.isScrolling then 
		self.isupdated = true
		self:scrollViewDidScroll()
	end 
end

function TableView:_eventListener(event)
	if not self.eventListener_ then
		return
	end
	event.target = self

	self.eventListener_(event)
end

function TableView:onCleanup()
	self:removeFreeItems()
end

return TableView








