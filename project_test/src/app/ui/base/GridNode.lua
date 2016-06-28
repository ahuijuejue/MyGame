
--[[
	格子排列层
]]

local GridNode = class("GridNode", function()
	return display.newNode()
end)

function GridNode:ctor(params)
	self.viewRect_ = params.viewRect 	-- 窗口尺寸
	self.ver = params.ver or 1 			-- 一排子单元个数
-- print("new grid node .............................................")
	-- self.colorLayer_ = cc.LayerColor:create(cc.c4f(randInt(10, 200), randInt(10, 200), randInt(10, 200), 100))
	-- :addTo(self)
	-- :pos(0,0)
	-- :zorder(5)
	-- :hide()

	-- self.colorLayer_:setTouchEnabled(false)

	self.headSize = params.headSize or cc.size(0, 0)
	self.rootSize = params.rootSize or cc.size(0, 0)
	self.itemSize = params.itemSize 

	self.backgroundLayer = display.newNode()
	:addTo(self)
	:align(display.CENTER)

	self.headLayer = display.newNode()
	:addTo(self)
	:align(display.CENTER)
	-- :size(self.headSize.width, self.headSize.height)

	self.rootLayer = display.newNode()
	:addTo(self)
	:align(display.CENTER)
	-- :size(self.rootSize.width, self.rootSize.height)	

	self.itemLayer = display.newNode()
	:addTo(self)
	:align(display.CENTER)


	self.items_ = {}

	self.gridSize = base.GridSize.new({
		ver = self.ver,
		itemSize = self.itemSize,
		headSize = self.headSize,
		rootSize = self.rootSize,
		reverse = params.reverse,
	})
	
end

--[[
重置所有添加数据

]]
function GridNode:resetData()
	self.headLayer:removeAllChildren()
	self.rootLayer:removeAllChildren()
	self.backgroundLayer:removeAllChildren()
	self:removeItems()

	return self 
end 

--[[
-- 格子数
]]
function GridNode:setCount(count)
	self.gridSize:setCount(count)
	self:updatePosition()
	self.itemLayer:size(self.gridSize:getSize())
	-- local rSize = self.gridSize:getSize()
	-- dump(rSize, "grid size")
	-- self.colorLayer_:setContentSize(rSize.width-3, rSize.height)
	return self
end

function GridNode:getCount()
	return self.gridSize:getCount()
end

function GridNode:setHeadSize(tSize)
	self.gridSize:setHeadSize(tSize)
end

function GridNode:setRootSize(tSize)
	self.gridSize:setRootSize(tSize)
end

--[[
-- 列数
]]

function GridNode:getVertical()
	return self.gridSize.ver_
end
-- 总尺寸
function GridNode:getSize()
	return self.gridSize:getSize()
end

--[[
添加头
]]
function GridNode:addHead(item)
	item:addTo(self.headLayer)	
	return self
end

--[[
添加尾
]]
function GridNode:addRoot(item)
	item:addTo(self.rootLayer)	
	return self
end

--[[
添加尾
]]
function GridNode:addBackground(img)
	img:addTo(self.backgroundLayer)	
	return self
end

--[[
添加格子物品
]]
function GridNode:addItem(item)	
	item:addTo(self.itemLayer)		
	table.insert(self.items_, item)
	return self
end 

--[[
获取符合条件的格子
]]
function GridNode:getItemIf(func)
	for i,v in ipairs(self.items_) do
		if func({index=i, item=v}) then 
			return v 
		end 
	end
	return nil
end 

--[[
获取第idx个格子
]]
function GridNode:getItem(idx)
	return self.items_[idx]
end

--[[
根据排号 设置格子坐标
]]
function GridNode:setIndexForItem(idx, item)
	local posX, posY = self.gridSize:offsetFromIndex(idx)
-- print("index:", idx)
-- print("pos:", posX, posY)
	item:setAnchorPoint(cc.p(0.5, 0.5))
	item:setPosition(cc.p(posX, posY))
	return self
end 

--[[
删除所有格子
]]
function GridNode:removeItems()
	self:removeItemsIf(function()
		return true
	end)

	return self 
end 

--[[
删除所有符合条件的格子

-- 删除格子 如果func返回 真值
]]

function GridNode:removeItemsIf(func)
	local idx = #self.items_
	while (idx > 0) do 
		if func(self.items_[idx], idx) then 
			self:removeItem(idx)
		end
		idx = idx - 1		
	end 
	return self 
end 
--[[
删除一个符合条件的格子
]]

-- 删除格子 如果func返回真值 最多删除一个
function GridNode:removeItemIf(func)
	local idx = #self.items_
	while (idx > 0) do 
		if func(self.items_[idx], idx) then 
			self:removeItem(idx)
			break 
		end
		idx = idx - 1		
	end 
	return self 
end 

--[[
删除当前存储的第idx个格子
]]
function GridNode:removeItem(idx)
	local item = table.remove(self.items_, idx)
	self:onEvent_({name="removeItem", item=item})
    item:removeFromParent(false)
end 

--[[
重新设置 子层的坐标
用于：当格子数 或 头尾的尺寸变动时
]]
function GridNode:updatePosition()
	self.headLayer:pos(self.gridSize:getHeadPosition())
	self.itemLayer:pos(self.gridSize:getMidPosition())
	self.rootLayer:pos(self.gridSize:getRootPosition())
	self.backgroundLayer:pos(self.gridSize:getItemPosition())
	
	-- print("head pos", self.gridSize:getHeadPosition())
	-- print("item pos", self.gridSize:getItemPosition())
	-- print("root pos", self.gridSize:getRootPosition())

	return self
end 


--------------------------------------------
--[[
事件回调
-removeItem 删除格子
{
	name="removeItem",
	item=nil, -- 格子
}

]]
function GridNode:onEvent(listener)
	self.eventListener_ = listener 
	return self
end

function GridNode:onEvent_(event)
	if not self.eventListener_ then return end 
	event.target = self 
	self.eventListener_(event)
end

--------------------------------------------


return GridNode


