
--[[
计算格子排列

排列顺序：
	从左向右
	从下向上
]]

local GridSize = class("GridSize")
--[[
@param params table 参数
- ver 		列数
- width 	格子单个宽度
- height 	格子单个高度
- maxIndex 	格子个数
- reverse 	反转

-- 反转值 0 默认
排列顺序：
	从左向右
	从下向上

-- 1 上下反转
排列顺序：
	从左向右
	从上向下

-- 2 反转
排列顺序：
	从上向下
	从左向右
]]

function GridSize:ctor(params)
	params = params or {}
	self.ver_ 		= params.ver or 1		-- 列数
	self.count_ 	= params.count or 0 	-- 格子数
	self.reverse_ 	= params.reverse or 0 	-- 转换类型

	self.itemSize_ 	= params.itemSize or cc.size(0, 0) -- 格子尺寸
	self.head_ 		= params.headSize or cc.size(0, 0) -- 头尺寸
	self.root_ 		= params.rootSize or cc.size(0, 0) -- 尾尺寸

	self.rows_ 		= 0 -- 行数
	self.size_ 		= nil -- 总尺寸

	self:initReverse()
	self:doOperation()
end

function GridSize:reverseSize(size)
	local w = size.width 
	local h = size.height 
	if self.reverse_ == 2 then 
		w = size.height 
		h = size.width 
	end 
	return cc.size(w, h)
end

function GridSize:initReverse()
	self.itemSize_ = self:reverseSize(self.itemSize_)
	self.head_ = self:reverseSize(self.head_)
	self.root_ = self:reverseSize(self.root_)
end 

-- 转换成外坐标系
function GridSize:decodeOffset_(x, y)
	if self.reverse_ > 0 then 
		if self.reverse_ == 2 then 
			x = self.size_.width - x

			local tmp = x
			x = y
			y = tmp				
		else
			y = self.size_.height - y
		end 

	end 
	return x, y
end 

-- 转换成本地坐标系
function GridSize:encodeOffset(x, y)
	if self.reverse_ > 0 then 
		if self.reverse_ == 2 then 
			local tmp = x
			x = y
			y = tmp	

			x = self.size_.width - x
		else
			y = self.size_.height - y
		end 

	end 
	y = y - self.head_.height
	return x, y
end 

-- 转换成外坐标系
function GridSize:decodeOffset(x, y)
	y = y + self.head_.height
	if self.reverse_ > 0 then 
		if self.reverse_ == 2 then 
			x = self.size_.width - x

			local tmp = x
			x = y
			y = tmp				
		else
			y = self.size_.height - y
		end 

	end 
	return x, y
end 


-- 转换坐标
function GridSize:convertScrollOffset(x, y)
	if self.reverse_ > 0 then 
		if self.reverse_ == 2 then 
			local tmp = x
			x = y
			y = tmp	
		end	
	end 
	return x, y
end

-- 如果超出窗体，校正坐标
--@param winsize 窗体尺寸
function GridSize:correctScrollOffset(x, y, winsize, scrollsize)
	if scrollsize then 
		scrollsize = self:reverseSize(scrollsize)
	else 
		scrollsize = self.size_
	end 
	local wSize = self:reverseSize(winsize)
	local posX, posY = self:convertScrollOffset(x, y)
	posX = 0 
	posY = math.min(posY, 0)
	posY = math.max(posY, wSize.height - scrollsize.height)
	return self:convertScrollOffset(posX, posY)
end 

function GridSize:isScrollInGrid(x, y, winsize, scrollsize, x0, y0)
	x, y = self:convertScrollOffset(x, y)
	x0, y0 = self:convertScrollOffset(x0, y0)
	local wSize = self:reverseSize(winsize)

	if y0 > y + wSize.height then 
		return false 
	end 

	if y0 + self.size_.height < y then 
		return false 
	end

	return true 
end 

function GridSize:isOffsetInGrid(x, y, x0, y0)
	x, y = self:convertScrollOffset(x, y)
	x0, y0 = self:convertScrollOffset(x0, y0)

	if y < y0 or y >  y0 + self.size_.height then 
		return false 
	end 

	return true 
end 

function GridSize:getAddOffset()
	local x = 0
	local y = self.size_.height 
	return self:decodeOffset(x, y)
end 

--[[
	显示row行
-x, y 窗口坐标
]]
function GridSize:correctRowOffset(x, y, x0, y0, row, winsize)
	-- print("row:", row)
	local rx, ry = self:offsetFromRow(row) -- 行坐标 
	rx, ry = self:encodeOffset(rx, ry) 
	x0, y0 = self:convertScrollOffset(x0, y0) 
	local wSize = self:reverseSize(winsize)
	local posX, posY = self:encodeOffset(x, y)  -- 窗口本地坐标
	posY = posY - wSize.height

	y = math.min(posY, ry)
	y = math.max(y, ry + self.itemSize_.height - wSize.height)

	y = y + wSize.height
	x, y = self:decodeOffset(x, y)
	return x, y
end 

----------------------------------------
--[[
格子数
]]
function GridSize:setCount(count)
	self.count_ = count 
	self:doOperation()
end 

function GridSize:getCount()
	return self.count_
end 

function GridSize:setHeadSize(tSize)
	self.head_ = tSize
	self:doOperation()
end

function GridSize:setRootSize(tSize)
	self.root_ = tSize
	self:doOperation()
end

--[[
计算
每次设置完都需要调用
]]
function GridSize:doOperation()
	self.rows_ = math.ceil(self.count_ / self.ver_)
	self.size_ = cc.size(self.ver_ * self.itemSize_.width, self.rows_ * self.itemSize_.height + self.head_.height + self.root_.height)
end

--[[
拥有行数
]]
function GridSize:getRows()
	return self.rows_
end
--[[
拥有列数
]]
function GridSize:getVertical()
	return self.ver_
end
--[[
总尺寸
]]
function GridSize:getSize()
	return self:reverseSize(self.size_)
end

--[[
单元尺寸
]]
function GridSize:getItemSize()
	return self.itemSize_
end

--[[
生长尺寸
]]
function GridSize:getAddSize()
	local aSize = cc.size(0, self.size_.height)
	return self:reverseSize(self.size_)
end

--[[
格子总尺寸
]]
function GridSize:getItemsSize()
	local tSize = cc.size(self.size_.width, self.size_.height - self.head_.height - self.root_.height)
	return self:reverseSize(tSize)
end

--[[
row 行的格子 开始和结束 index
]]
function GridSize:indexFromRow(row)
	local index = self.ver_ * (row -1)
	return index + 1, index + self.ver_
end

--[[
标记index的格子在第几行
]]
function GridSize:rowFromIndex(index)
	return math.ceil(index / self.ver_)
end

--[[
在坐标 offset 上的 开始和结束 index
]]
function GridSize:indexOnOffset(offset)
	local row = self:rowFromOffset(offset)
	return self:indexFromRow(row)	
end

--[[
坐标 offset 最接近的行的坐标
]]
function GridSize:offsetRoundOffset(offset)
	local row = self:rowRoundOffset(offset)
	return self:offsetFromRow(row)
end

--[[
坐标 offset 在第几个格子上
]]
function GridSize:indexFromOffset(offset)
	local posX, posY = self:encodeOffset(offset.x, offset.y)
	local row = math.floor(posY / self.itemSize_.height)
	local ver = math.floor(posX / self.itemSize_.width)

	return row * self.ver_ + ver + 1
end

--[[
index格子的坐标
]]
function GridSize:offsetFromIndex(index)	
	local row = math.floor((index-1) / self.ver_)
	local ver = math.mod(index - 1, self.ver_)

	local posX = (ver + 0.5) * self.itemSize_.width
	local posY = (row + 0.5) * self.itemSize_.height
-- print("\nbase pos:", posX, posY)
	posX, posY = self:decodeOffset(posX, posY)
	return posX, posY
end

--[[
在 Y轴=value 上的行
]]
function GridSize:rowFromOffset(offset)
	local posX, posY = self:encodeOffset(offset.x, offset.y)
	local rows = math.floor(posY / self.itemSize_.height)	
	return rows + 1
end

--[[
最接近 Y轴=value的行
]]
function GridSize:rowRoundOffset(offset)
	local posX, posY = self:encodeOffset(offset.x, offset.y)
	local rows = math.round(posY / self.itemSize_.height)	
	-- print("posX, posY", posX, posY)
	-- print("row:", rows+1)
	return rows + 1
end

--[[
row行 的坐标
]]
function GridSize:offsetFromRow(row)
	local posX, posY = self:decodeOffset(0, (row -1) * self.itemSize_.height)
	return posX, posY
end

--[[
头的坐标
]]
function GridSize:getHeadPosition()
	local posX = self.size_.width * 0.5 
	local posY = self.head_.height * 0.5 
	return self:decodeOffset_(posX, posY)
end 

--[[
未的坐标
]]
function GridSize:getRootPosition()
	local posX = self.size_.width * 0.5 
	local posY = self.size_.height - self.root_.height * 0.5 
	return self:decodeOffset_(posX, posY)
end 

--[[
格子总体的中点
]]
function GridSize:getItemPosition()	
	local posX = self.size_.width * 0.5
	local posY = (self.size_.height + self.head_.height - self.root_.height) * 0.5
	return self:decodeOffset_(posX, posY)
end 

--[[
中点
]]
function GridSize:getMidPosition()	
	local posX = self.size_.width * 0.5
	local posY = self.size_.height * 0.5
	return self:decodeOffset_(posX, posY)
end 

return GridSize 

