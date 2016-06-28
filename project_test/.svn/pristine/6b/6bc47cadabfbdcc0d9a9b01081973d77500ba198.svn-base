--[[
table view
]]

local UIScrollView = require("framework.cc.ui.UIScrollView")
local GridView = class("GridView", UIScrollView)
local GridNode = import(".GridNode")

function GridView:ctor(params)
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
	GridView.super.ctor(self, params)

	self.itemFunc_ = nil
	self.itemSize = params.itemSize

	self.pageEnabled = params.page -- 支持分格

	self.realSize_ = nil 
	self.container = cc.Node:create()
	self:addScrollNode(self.container)
	self:onScroll(handler(self, self.scrollListener))

	-- self.isupdated = false
	-- self.isScrolling = false
	-- self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(...)
	-- 		self:update_(...)
	-- 	end)
	-- self:scheduleUpdate()

	self.sections = {}

	self.ver_ = params.ver or 1
	self.reverse_ = reverseType


end

function GridView:resetData()
	for i,v in ipairs(self.sections) do
		v:removeSelf()
	end
	self.sections = {}
	
	return self 
end 

function GridView:reload()
	self:setRealSize()
	self:layout_()
	-- self:scrollViewDidScroll()
	self:updateSectionsPosition()
	return self 
end 

function GridView:setRealSize()
	local w, h = 0, 0
	for i,v in ipairs(self.sections) do
		local nSize = v:getSize()
		w = w + nSize.width 
		h = h + nSize.height
	end
-- print("w, h:", w, h)
	if self.direction == self.DIRECTION_VERTICAL then 
		w = self.viewRect_.width
	else 
		h = self.viewRect_.height
	end 
-- print("w, h:", w, h)
	self.realSize_ = cc.size(w, h)
	self.container:setContentSize(self.realSize_)
end

function GridView:getRealSize()
	return self.realSize_
end

--[[
require param 
{
	count, -- 格子数 
	itemSize, 格子尺寸 
	getItem = function(event)
		-- event.index, 		-- 格子序号
		-- event.sectionIndex, 	-- 分区序号
		-- event.section, 		-- 分区
		-- event.target, 		-- GridView
	end,
}
options:
	head = display.newSprite("icon.png"), -- 头部图像
	root = display.newSprite("icon.png"), -- 尾部图像
	background = display.newSprite("icon.png"), -- 背景图片 
	headSize = cc.size(100, 100), -- 头部图像尺寸
	rootSize = cc.size(100, 100), -- 尾部图像尺寸
	getBackground = function(event)		 	-- 创建背景方法
		-- event.sectionIndex, 	-- 分区序号
		-- event.section, 		-- 分区
		-- event.target, 		-- GridView
		-- event.size, 			-- 所有格子的总尺寸

		local node = display.newScale9Sprite("scale9.png")
		local size = event.size 
		node:size(size)
		return node
	end,
	ver = 1,  -- 列数
	itemSize = cc.size(100, 100), -- 格子尺寸
]]
function GridView:addSection(params)
	-- if not params.count or params.count == 0 then return self end 
	local sectionIndex = #self.sections + 1

	params.itemSize = params.itemSize or self.itemSize
	params.reverse = self.reverse_
	params.ver = params.ver or self.ver_

	local section = GridNode.new(params)
	section:setCount(params.count)
	for i=1,(params.count) do
		local item = params.getItem({sectionIndex=sectionIndex, section=section, index=i, target=self})
		section:addItem(item)
		section:setIndexForItem(i, item)
	end

	section:addTo(self.container)

	if params.forced or params.count > 0 then 
		if params.head then 
			section:addHead(params.head)
		end 

		if params.root then 
			section:addRoot(params.head)
		end 

		if params.background then 
			section:addBackground(params.background)
		end 

		if params.getBackground then 
			local background = params.getBackground({
				section = section,
				sectionIndex = sectionIndex,
				gridView = self,
				size = section.gridSize:getItemsSize(),
			})
			section:addBackground(background)
		end 

	else 
		if params.headSize then 
			section:setHeadSize(cc.size(0, 0))
		end 
		if params.rootSize then 
			section:setRootSize(cc.size(0, 0))
		end 
	end 

	table.insert(self.sections, section)

	return self
end

function GridView:sectionCount()
	return #self.sections
end

function GridView:onTouch(listener)
	self.eventListener_ = listener

    return self
end

function GridView:getSectionByOffset(x, y)	
	local subX = 0
	local subY = 0
	for i,v in ipairs(self.sections) do
		if v.gridSize:isOffsetInGrid(x, y, v:getPosition()) then 
			return v, i, subX, subY
		else 
			local posX, posY = v.gridSize:getAddOffset()
			subX = subX + posX 
			subY = subY + posY
		end 
	end
	return nil 
end 

function GridView:walkItems(callback, sectionIndex)
	sectionIndex = sectionIndex or 1 
	local section = self.sections[sectionIndex]
	for i,v in ipairs(section.items_) do
		callback({item=v, index=i})
	end
end 

function GridView:getItemAtIndex(idx, sectionIndex)
	sectionIndex = sectionIndex or 1 
	local section = self.sections[sectionIndex]
	return section:getItem(idx)
end 


function GridView:indexOnOffset(offset)	
	local section, sectionIndex, subX, subY = self:getSectionByOffset(offset.x, offset.y)
	if section then 
		local idx = section.gridSize:indexOnOffset(cc.p(offset.x - subX, offset.y - subY))
		return idx, section, sectionIndex
	end 
	return 0
end

function GridView:indexFromOffset(offset)	
	local section, sectionIndex, subX, subY = self:getSectionByOffset(offset.x, offset.y)
	-- print("offset", offset.x, offset.y, subX, subY)
	if section then 
		local posX, posY = section:getPosition()
		-- print("pos:", posX, posY)
		posX = offset.x - posX
		posY = offset.y - posY
		-- print("pos:", posX, posY)
		local idx = section.gridSize:indexFromOffset(cc.p(posX, posY))
		return idx, section, sectionIndex
	end 
	return 0
end

function GridView:scrollListener(event)
	if "moved" == event.name then
		if self.bDrag_ then 
			self.isScrolling = true			
		end 

	elseif event.name == "ended" then 
		if #self.sections == 0 then return end 		

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
		if #self.sections == 0 then return end 
		-- print("clicked")
		local point = cc.p(event.x, event.y)
		point = self.container:convertToNodeSpace(point)
		local idx, section, sectionIndex = self:indexFromOffset(point)
		-- print("clicked index:", idx)
		if idx > 0 then 
			-- print("section index:", sectionIndex)
			local item = self:getItemAtIndex(idx, sectionIndex)
			if item then 				
				self:_eventListener({name="selected", index=idx, item=item, section=section, sectionIndex=sectionIndex})	
			end 
		end
	end 
	self:_eventListener(event)	
end

function GridView:onPage_(event, x, y)
	-- print("offset", x, y)
	local fy = self.viewRect_.height
	local section, sectionIndex, subX, subY = self:getSectionByOffset(-x, -y)
	if section then 
		local x0, y0 = section:getPosition()
		local realX = -x - x0
		local realY = -y - y0 + fy
		local posX, posY = section.gridSize:offsetRoundOffset(cc.p(-x, fy-y))
		-- print("posX, posY", posX, posY)
		x = -posX + x0 
		y = -posY + y0 + fy
	end 
	-- local posX, posY = self.gridNode.gridSize:offsetRoundOffset(cc.p(-x, fy-y))
	-- posY = posY - fy
	self:scrollOffset(cc.p(x, y), true)
end 

--@param offset container 正常坐标
--@param forced 是否强制刷新
function GridView:scrollOffset(offset, animate, forced)	 	
	transition.stopTarget(self.container)
	local posX, posY = self:correctScrollOffset(offset.x, offset.y)
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

function GridView:correctScrollOffset(x, y)
	-- print("pos pre:", x, y)
	local section = self.sections[1] 
	if section then 
		x, y = section.gridSize:correctScrollOffset(x, y, self.viewRect_, self:getRealSize())
	end 
	-- print("pos end:", x, y)
	-- dump(self:getRealSize(), "real size")
	return x, y
end

function GridView:scrollEnd(forced)
	if forced or self.isupdated then 
		self.isupdated = false 
		-- self:scrollViewDidScroll()
	end
	self.isScrolling = false
end 

function GridView:updateSectionsPosition()
	local posX = 0
	local posY = self:getRealSize().height
	for i,v in ipairs(self.sections) do
		local iSize = v:getSize()
		if self.direction == self.DIRECTION_VERTICAL then 			
			posY = posY - iSize.height 
			-- print("posY:", posY)
			v:pos(0, posY)
		else 
			-- print("\nposX:", posX)
			v:pos(posX, 0)
			posX = posX + iSize.width
		end 
	end
end

function GridView:layout_()
	local posX, posY = self.container:getPosition()
	if self.direction == self.DIRECTION_VERTICAL then 
		posY = self.viewRect_.height - self:getRealSize().height
	else 
		posX = 0
	end 
	self.container:setPosition(cc.p(posX, posY))
	-- print("set pos:", posX, posY)
end 

-- function GridView:update_( ... )
-- 	if self.isScrolling then 
-- 		self.isupdated = true
-- 		-- self:scrollViewDidScroll()
-- 	end 
-- end

function GridView:_eventListener(event)
	if not self.eventListener_ then
		return
	end
	event.target = self

	self.eventListener_(event)
end

--[[
显示第row行， 如果已经在窗口内则无操作

]]
function GridView:showRow(row, sectionIndex, animate)
	-- print("show row start")
	sectionIndex = sectionIndex or 1 
	local section = self.sections[sectionIndex]
	if section then 
		local x0, y0 = section:getPosition() -- section坐标
		local x, y = self.container:getPosition()
		local posX, posY = section.gridSize:correctRowOffset(-x, -y, x0, y0, row, self.viewRect_)
		self:scrollOffset(cc.p(-posX, -posY))	 
	end 
	-- print("show row end")
end 



return GridView








