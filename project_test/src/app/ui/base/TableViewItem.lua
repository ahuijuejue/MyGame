--[[
table view 的 子控件
]]

local TableViewItem = class("TableViewItem", function()
	return cc.Node:create()
end)

function TableViewItem:ctor(item)
	self.width = 0
	self.height = 0
	self.content_ = nil 
	self.index_ = 0
	self.flagStr_ = "default"
	self:setContent(item)
end

--------------------------------
-- 将要内容加到列表控件项中
-- @function [parent=#TableViewItem] addContent
-- @param node content 显示内容

-- end --

function TableViewItem:setContent(content)
	if not content then
		return self
	end

	if self.content_ then 
		self.content_:removeSelf()
	end 

	self.content_ = content 
	self:addChild(content)
	content:setPosition(cc.p(self.width/2, self.height/2))

	return self
end

function TableViewItem:getContent()
	return self.content_
end

function TableViewItem:setItemSize(w, h)
	w = w or 0
	h = h or 0
	self.width = w
	self.height = h
	self:setContentSize(w, h)

	local bg = self:getContent()
	if bg then
		bg:setContentSize(w, h)
		bg:setPosition(cc.p(w/2, h/2))
	end
	return self
end

function TableViewItem:getItemSize()
	return self.width, self.height
end

function TableViewItem:setIndex(index)
	self.index = index 
	return self 
end

function TableViewItem:getIndex()
	return self.index
end

function TableViewItem:setFlag(flag)
	if flag then 
		self.flagStr_ = flag 
	end 
end 

function TableViewItem:getFlag()
	return self.flagStr_
end

return TableViewItem
