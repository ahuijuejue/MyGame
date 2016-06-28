
local ListView = import(".ListView")
local GridView = class("GridView", ListView)

function GridView:ctor(params)	
	GridView.super.ctor(self, params)
	self:setBounceable(false)
	self.rows = params.rows or 1
end

function GridView:removeAllItems()	
	self.container:removeAllChildren()
	if self.sections_ then 
		self.sections_ = {}
	else 		
		self.items_ = {}
	end 

	return self 
end

function GridView:layout_()
	if self.sections_ then 
		self:layoutSectionItems_()
	else 
		self:layoutItems_()
	end 
end 

function GridView:layoutSectionItems_()
	local width, height = 0, 0
	local itemW, itemH = self.itemSize.width, self.itemSize.height

	if self.DIRECTION_VERTICAL == self.direction then
		width = self.viewRect_.width		
		for i,v in ipairs(self.sections_) do
			local tmpRow = math.ceil(#v.items / self.rows)
			height = height + itemH * tmpRow 

			if v.head then 
				local w, h = v.head:getItemSize()
				height = height + h
				v.head:setItemSize(width, h)
			end 
			if v.root then 
				local w, h = v.root:getItemSize()
				height = height + h
				v.root:setItemSize(width, h)
			end 
		end			
	else
		height = self.viewRect_.height
		for i,v in ipairs(self.sections_) do
			local tmpRow = math.ceil(#v.items / self.rows)
			width = width + itemH * tmpRow 

			if v.head then 
				local w, h = v.head:getItemSize()
				width = width + w
				v.head:setItemSize(w, height)
			end 
			if v.root then 
				local w, h = v.root:getItemSize()
				width = width + w
				v.root:setItemSize(w, height)
			end 
		end					
	end

	self:setActualRect({x = self.viewRect_.x,
		y = self.viewRect_.y,
		width = width,
		height = height})
	self.size.width = width
	self.size.height = height

	local setPositionByAlignment = function(content, w, h, margin)
		local size = content:getContentSize()
		if 0 == margin.left and 0 == margin.right and 0 == margin.top and 0 == margin.bottom then
			if self.DIRECTION_VERTICAL == self.direction then
				if self.ALIGNMENT_LEFT == self.alignment then
					content:setPosition(size.width/2, h/2)
				elseif self.ALIGNMENT_RIGHT == self.alignment then
					content:setPosition(w - size.width/2, h/2)
				else
					content:setPosition(w/2, h/2)
				end
			else
				if self.ALIGNMENT_TOP == self.alignment then
					content:setPosition(w/2, h - size.height/2)
				elseif self.ALIGNMENT_RIGHT == self.alignment then
					content:setPosition(w/2, size.height/2)
				else
					content:setPosition(w/2, h/2)
				end
			end
		else
			local posX, posY
			if 0 ~= margin.right then
				posX = w - margin.right - size.width/2
			else
				posX = size.width/2 + margin.left
			end
			if 0 ~= margin.top then
				posY = h - margin.top - size.height/2
			else
				posY = size.height/2 + margin.bottom
			end
			content:setPosition(posX, posY)
		end
	end

	local posItem = function(item, x, y, w, h)
		local content = item:getContent()
		content:setAnchorPoint(0.5, 0.5)			
		setPositionByAlignment(content, w, h, item:getMargin())
		item:setPosition(x, y)	
	end

	local row = 0
	local tempWidth, tempHeight = width, height
	if self.DIRECTION_VERTICAL == self.direction then
		for i,v in ipairs(self.sections_) do
			if v.head then 
				local w, h = v.head:getItemSize()
				tempHeight = tempHeight - h
				posItem(v.head, self.viewRect_.x, self.viewRect_.y + tempHeight, v.head:getItemSize())								
			end 
			if table.nums(v.backgrounds) > 0 then 
				for j,w in ipairs(v.backgrounds) do
					posItem(w, self.viewRect_.x, self.viewRect_.y + tempHeight - itemH * j, width, itemH)	
				end
			end 
			row = 0
			for j,w in ipairs(v.items) do
				local tmpRow = math.ceil(j / self.rows)
				if tmpRow > row then
					row = tmpRow
					tempHeight = tempHeight - itemH
					tempWidth = 0
				else
					tempWidth = tempWidth + itemW
				end
				posItem(w, self.viewRect_.x + tempWidth, self.viewRect_.y + tempHeight, itemW, itemH)
			end

			if v.root then 
				local w, h = v.root:getItemSize()
				tempHeight = tempHeight - h
				posItem(v.root, self.viewRect_.x, self.viewRect_.y + tempHeight, v.root:getItemSize())								
			end
		end		
	else		
		tempWidth = 0
		tempHeight = height - itemH
		
		for i,v in ipairs(self.sections_) do
			if v.head then 
				posItem(v.head, self.viewRect_.x + tempWidth, self.viewRect_.y, v.head:getItemSize())
				local w, h = v.head:getItemSize()
				tempWidth = tempHeight + w												
			end 

			if table.nums(v.backgrounds) > 0 then 
				for j,w in ipairs(v.backgrounds) do
					posItem(w, self.viewRect_.x + tempWidth + itemW * (j-1), self.viewRect_.y, itemW, height)	
				end
			end 

			for j,w in ipairs(v.items) do
				posItem(w, self.viewRect_.x + tempWidth, self.viewRect_.y + tempHeight, itemW, itemH)
				local tmpRow = math.floor(j / self.rows)
				if tmpRow > row then
					row = tmpRow
					tempHeight = height - itemH					
					tempWidth = tempWidth + itemW
				else
					tempHeight = tempHeight - itemH
				end
				
			end

			if v.root then 
				posItem(v.root, self.viewRect_.x + tempWidth, self.viewRect_.y, v.root:getItemSize())
				local w, h = v.root:getItemSize()
				tempWidth = tempHeight + w											
			end
		end	
	end
	
	-- 计算x坐标
	local cascadeBound = self.container:getCascadeBoundingBox()	
	local posX = self.container:getPositionX()
	-- dump(cascadeBound)
	local disX, disY = 0, 0
	local viewRect = self:getViewRectInWorldSpace()
	-- dump(viewRect)

	if cascadeBound.width < viewRect.width then
		disX = viewRect.x - cascadeBound.x
	else
		if cascadeBound.x > viewRect.x then
			disX = viewRect.x - cascadeBound.x
		elseif cascadeBound.x + cascadeBound.width < viewRect.x + viewRect.width then
			disX = viewRect.x + viewRect.width - cascadeBound.x - cascadeBound.width
		end
	end	

	if cascadeBound.height < viewRect.height then
		disY = viewRect.y + viewRect.height - cascadeBound.y - cascadeBound.height
	else
		if cascadeBound.y > viewRect.y then
			disY = viewRect.y - cascadeBound.y
		elseif cascadeBound.y + cascadeBound.height < viewRect.y + viewRect.height then
			disY = viewRect.y + viewRect.height - cascadeBound.y - cascadeBound.height
		end
	end

	self.container:setPosition(posX + disX, self.viewRect_.height - self.size.height)

end 

function GridView:layoutItems_()
	local width, height = 0, 0
	local itemW, itemH = self.itemSize.width, self.itemSize.height
	local margin
	local row = 0
	print("self rows:", self.rows)
	-- calcate whole width height
	if self.DIRECTION_VERTICAL == self.direction then
		width = self.viewRect_.width
		local tmpRow = math.ceil(#self.items_ / self.rows)
		height = itemH * tmpRow 		
	else
		height = self.viewRect_.height
		local tmpRow = math.ceil(#self.items_ / self.rows)
		width = itemW * tmpRow 		
	end
	
	self:setActualRect({x = self.viewRect_.x,
		y = self.viewRect_.y,
		width = width,
		height = height})
	self.size.width = width
	self.size.height = height
	-- print("[", width, height, "]")

	local setPositionByAlignment = function(content, w, h, margin)
		local size = content:getContentSize()
		if 0 == margin.left and 0 == margin.right and 0 == margin.top and 0 == margin.bottom then
			if self.DIRECTION_VERTICAL == self.direction then
				if self.ALIGNMENT_LEFT == self.alignment then
					content:setPosition(size.width/2, h/2)
				elseif self.ALIGNMENT_RIGHT == self.alignment then
					content:setPosition(w - size.width/2, h/2)
				else
					content:setPosition(w/2, h/2)
				end
			else
				if self.ALIGNMENT_TOP == self.alignment then
					content:setPosition(w/2, h - size.height/2)
				elseif self.ALIGNMENT_RIGHT == self.alignment then
					content:setPosition(w/2, size.height/2)
				else
					content:setPosition(w/2, h/2)
				end
			end
		else
			local posX, posY
			if 0 ~= margin.right then
				posX = w - margin.right - size.width/2
			else
				posX = size.width/2 + margin.left
			end
			if 0 ~= margin.top then
				posY = h - margin.top - size.height/2
			else
				posY = size.height/2 + margin.bottom
			end
			content:setPosition(posX, posY)
		end
	end

	row = 0
	local tempWidth, tempHeight = width, height
	if self.DIRECTION_VERTICAL == self.direction then
		local content
		for i,v in ipairs(self.items_) do			
			local tmpRow = math.ceil(i / self.rows)			
			if tmpRow > row then
				row = tmpRow
				tempHeight = tempHeight - itemH
				tempWidth = 0
			else
				tempWidth = tempWidth + itemW
			end
						
			content = v:getContent()
			content:setAnchorPoint(0.5, 0.5)			
			setPositionByAlignment(content, itemW, itemH, v:getMargin())
			posX = self.viewRect_.x + tempWidth
			posY = self.viewRect_.y + tempHeight
			v:setPosition(posX, posY)			
		end
	else		
		tempWidth = 0
		tempHeight = height
		local addWidth = 0
		for i,v in ipairs(self.items_) do
			content = v:getContent()
			content:setAnchorPoint(0.5, 0.5)			
			setPositionByAlignment(content, itemW, itemH, v:getMargin())			
			
			local tmpRow = math.ceil(i / self.rows)
			if tmpRow > row then
				row = tmpRow				
				tempHeight = height - itemH
				if row > 1 then 
					addWidth = itemW 
				end 
				tempWidth = tempWidth + addWidth
			else
				tempHeight = tempHeight - itemH
			end

			v:setPosition(self.viewRect_.x + tempWidth, self.viewRect_.y + tempHeight)
		end
	end

	-- 计算x坐标
	local cascadeBound = self.container:getCascadeBoundingBox()	
	local posX = self.container:getPositionX()
	-- dump(cascadeBound)
	local disX, disY = 0, 0
	local viewRect = self:getViewRectInWorldSpace()
	-- dump(viewRect)

	if cascadeBound.width < viewRect.width then
		disX = viewRect.x - cascadeBound.x
	else
		if cascadeBound.x > viewRect.x then
			disX = viewRect.x - cascadeBound.x
		elseif cascadeBound.x + cascadeBound.width < viewRect.x + viewRect.width then
			disX = viewRect.x + viewRect.width - cascadeBound.x - cascadeBound.width
		end
	end	

	if cascadeBound.height < viewRect.height then
		disY = viewRect.y + viewRect.height - cascadeBound.y - cascadeBound.height
	else
		if cascadeBound.y > viewRect.y then
			disY = viewRect.y - cascadeBound.y
		elseif cascadeBound.y + cascadeBound.height < viewRect.y + viewRect.height then
			disY = viewRect.y + viewRect.height - cascadeBound.y - cascadeBound.height
		end
	end

	self.container:setPosition(posX + disX, self.viewRect_.height - self.size.height)
end

--[[--

在列表项中添加一项

@param node listItem 要添加的项
@param [integer pos] 要添加的位置

@return GridView

]]
function GridView:addItem(listItem, pos)	
	if pos then
		table.insert(self.items_, pos, listItem)
	else
		table.insert(self.items_, listItem)
	end
	self.container:addChild(listItem)

	return self
end

function GridView:addSectionItems(count, getItemFunc)	
	self.sections_ = self.sections_ or {}

	local items = {
		items={},
		backgrounds = {},
	}
	table.insert(self.sections_, items)	

	if not count or count <= 0 then return self end 
	
	local hang = math.ceil(count / self.rows) -- 行数 

	local grid
	
	local size = cc.size(10,10) 
	for i=1,hang do
		local background = getItemFunc({name="background", target=self, index=i})
		if background then 
			grid = self:newItem(background):zorder(2)
			grid:setItemSize(self.itemSize.width, self.itemSize.height)
			self.container:addChild(grid)
			table.insert(items.backgrounds, grid)			
		end 
	end

	local head = getItemFunc({name="head", target=self, size=size})
	if head then 
		grid = self:newItem(head):zorder(2)
		grid:setItemSize(size.width, size.height)
		self.container:addChild(grid)
		items.head = grid 
	end 

	local root = getItemFunc({name="root", target=self, size=size})
	if root then 
		grid = self:newItem(root):zorder(2)
		grid:setItemSize(size.width, size.height)
		self.container:addChild(grid)
		items.root = grid 
	end	

	for i=1,count do
		local item = getItemFunc({name="item", target=self, index=i})
		grid = self:newItem(item):zorder(2)
		grid:setItemSize(self.itemSize.width, self.itemSize.height)
		table.insert(items.items, grid)
		self.container:addChild(grid)
	end
	
	return self
end

function GridView:scrollListener(event)
	if self.sections_ then 
		self:scrollListenerSectionItems(event)
	else 
		self:scrollListenerItem(event)
	end 
end 

function GridView:scrollListenerSectionItems(event)
	if "clicked" == event.name then
		local nodePoint = self.container:convertToNodeSpace(cc.p(event.x, event.y))
		
		local getTouchedGrid = function(pos)
			for i,v in ipairs(self.sections_) do
				for j,w in ipairs(v.items) do
					local posX, posY = w:getPosition()
					local rect = cc.rect(posX, posY, self.itemSize.width, self.itemSize.height)
					if cc.rectContainsPoint(rect, pos) then
						return i, j, w						
					end	
				end
			end
		end
	

		local section, pos, item = getTouchedGrid(nodePoint)		
		
		if section and pos then 
			self:notifyListener_{name = "clicked",	listView = self, target = self,
				section=section, itemPos = pos, item = item:getContent(),	point = nodePoint}
		end 
	else
		event.scrollView = nil
		event.listView = self
		event.target = self 
		self:notifyListener_(event)
	end
end 

function GridView:scrollListenerItem(event)
	if "clicked" == event.name then
		local nodePoint = self.container:convertToNodeSpace(cc.p(event.x, event.y))
		
		local getTouchedGrid = function(pos)
			for i,v in ipairs(self.items_) do
				local posX, posY = v:getPosition()
				local rect = cc.rect(posX, posY, self.itemSize.width, self.itemSize.height)	
				if cc.rectContainsPoint(rect, pos) then
					return i, v 
				end			
			end	
		end

		local pos, item = getTouchedGrid(nodePoint)
		
		if pos then 
			self:notifyListener_{name = "clicked",
				listView = self, itemPos = pos, item = item,
				point = nodePoint}
		end 
	else
		event.scrollView = nil
		event.listView = self
		self:notifyListener_(event)
	end

end


return GridView
