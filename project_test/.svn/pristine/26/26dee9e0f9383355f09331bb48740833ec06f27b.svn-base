

local TouchNode = import(".TouchNode")
local StateNode = import(".StateNode")
local Grid = class("Grid", function()
	return display.newNode()
end)

--[[
元
普通层默认层级5

type 默认为2:即选中和普通替换
	为1:即选中覆盖所有
	
]]

function Grid:ctor(params)
	params = params or {} 

	self.idx_ = 0
	self.data_ = {}

	self.size_ = cc.size(130, 130)
	self.autoSize_ = true	
	self.swallowTouch = not (params.swallowTouch == false)	

	self.items_ = {}
	self.itemLayer_ = display.newNode()	
	:zorder(5)

	self.baseLayer_ = StateNode.new(params)
	:addTo(self, 5)
	
	self.baseLayer_:addBaseWithKey("itemLayer", self.itemLayer_)

	if params.items then 
		self:addItems(params.items)			
	end 

	self:setNodeEventEnabled(true)
end

function Grid:setData(key, value)
	self.data_[key] = value 
	return self
end 

function Grid:getData(key)
	return self.data_[key]
end 

function Grid:getSize()
	local rect = self:getCascadeBoundingBox()
	return rect.width, rect.height
end 

function Grid:setIndex(index)
	self.idx_ = index
	return self
end

function Grid:getIndex()
	return self.idx_
end

---------------------------------------------
---------------------------------------------

function Grid:getBase(key)
	return self.baseLayer_:getBase(key)
end

function Grid:removeBase(key)
	self.baseLayer_:removeBase(key)
end

function Grid:addBaseWithKey(key, img, zorder)
	self.baseLayer_:addBaseWithKey(key, img, zorder)
end

function Grid:addBase(img, zorder) 	
	self.baseLayer_:addBase(img, zorder) 
end

----------------------------------------------
-- public
function Grid:setNormalImage(image, zorder) 
	self.baseLayer_:setNormalImage(image, zorder) 
	
	return self
end

function Grid:setSelectedImage(image, zorder)
	self.baseLayer_:setSelectedImage(image, zorder) 
	
	return self
end

function Grid:setBackgroundImage(image)
	self.baseLayer_:setBackgroundImage(image) 

	return self
end

function Grid:setDisabledImage(image, zorder)
	self.baseLayer_:setDisabledImage(image, zorder) 
	
	return self	
end

function Grid:addLabel(label, zorder)
	if type(label) == "table" then 
		label = base.Label.new(label):align(display.CENTER):zorder(10)
	end 
	if zorder then 
		label:zorder(zorder)	
	end 
	self:addBase(label)

	return self
end

---------------------------------------
--[[
--@param items table 数组
]]
function Grid:addItems(items)
	assert(type(items) == "table", "is should be table")
	for i,v in ipairs(items) do
		self:addItem(v)		
	end
	
	return self
end 

function Grid:addItem(item)	
	if type(item) == "string" then 
		item = display.newSprite(item)
	end		
	item:addTo(self.itemLayer_)		
	
	return self
end 
--[[	
{
	background_ = "background.png",
	node_ = display.newNode()
}	
]]
function Grid:addItemsWithKey(items)
	assert(type(items) == "table", "is should be table")

	for k,v in pairs(items) do
		self:addItemWithKey(k, v)
	end
	
	return self
end 

function Grid:addItemWithKey(key, item)	
	if self.items_[key] then
		self.items_[key]:removeSelf()
		self.items_[key] = nil 
	end	
	
	if item then 
		if type(item) == "string" then 
			if string.len(item) == 0 then 
				item = nil 
			end 
			self.items_[key] = display.newSprite(item)		
		else 
			self.items_[key] = item
		end 
		self.items_[key]:addTo(self.itemLayer_)
	end 
	
	return self
end 
--[[
添加不存在的元素
@param items table 键值对
]]
function Grid:addItemsIf(items)
	assert(type(items) == "table", "is should be table")

	for k,v in pairs(items) do
		if not self.items_[k] then	
			self:addItemWithKey(k, v)			
		end 
	end
	
	return self
end 

function Grid:getItem(key)
	 return self.items_[key]
end

function Grid:removeItem(key)
	if self.items_[key] then 
	 	self.items_[key]:removeFromParent()
		self.items_[key] = nil
	end 
end

function Grid:removeItems()
	self.itemLayer_:removeAllChildren()
	self.items_ = {}
	return self
end 
-----------------------------------------------------------
-----------------------------------------------------------

function Grid:isSelected()
	return self.baseLayer_:isSelected()
end

function Grid:setSelected(b)
	self.baseLayer_:setSelected(b)
	return self
end

function Grid:setEnabled(enabled)
	self.baseLayer_:setEnabled(enabled)

	return self
end

function Grid:isEnabled()
	return self.baseLayer_:isEnabled()
end 

function Grid:reset()	
	self.baseLayer_:setEnabled(true)
	:setSelected(false)

	self.idx_ = 0

	return self
end
---------------------------------------------------------
---------------------------------------------------------
-- began touch
function Grid:setTouchSize(touchSize)
	if touchSize then
		self.size_ = touchSize 
		self.autoSize_ = false
	end	
end 

function Grid:onTouch(listener, touchSize)	
	self:addTouchNode()
	self.touchNode_:onEvent(listener, touchSize)
	
	return self
end

function Grid:onLongTouch(listener, time, touchSize)	
	self:setTouchSize(touchSize)
	self:addTouchNode()
	self.touchNode_:onLongTouch(listener, time)

	return self
end

function Grid:onClicked(listener, touchSize)	
	self:addTouchNode()
	self.touchNode_:onClicked(listener, touchSize)
	return self
end

--[[
@x y 世界坐标点  或 点击坐标点
]]
function Grid:hiteTest(x, y)	
	if self.touchNode_ then 
		return self.touchNode_:hiteTest(x, y)
	end 
	return false
end 


function Grid:autoSize(b)
	if b == nil then 
		self.autoSize_ = true
	else 
		self.autoSize_ = b
	end
	self:addTouchNode() 
	return self
end 

function Grid:getTouchNode()
	return self.touchNode_
end 

function Grid:addTouchNode()
	local node

	if self.touchNode_ then
		node = self.touchNode_
	else
		node = TouchNode.new({
			target=self,
			swallowTouch = self.swallowTouch,
		})
		self.touchNode_ = node
		
		node:zorder(10)
		:addTo(self)
	end
	
	local size
	if self.autoSize_ then 
		size = self:getCascadeBoundingBox().size
	else 
		size = self.size_
	end 

	self.touchNode_:size(size.width, size.height)	
	
    return self
end

function Grid:showLimitLayer(b)
	if b == nil then b = true end 
	if not self.limitLayer_ then 
		self.limitLayer_ = TouchNode.new({target=self})
		:addTo(self)
		:size(display.width*2, display.height*2)
		:onEvent(function(event)
			
		end)
	end 
	if b then 
		self.limitLayer_:show()
	else 
		self.limitLayer_:hide()
	end 
	return self
end 

-- end touch
-----------------------------------

return Grid