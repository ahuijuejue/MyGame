--[[
状态图显示
可显示 普通，选中，不能选
]]
local StateNode = class("StateNode", function()
	return display.newNode()
end)

function StateNode:ctor(params)	
	self.isSelected_ = false
	self.isEnabled_ = true

	self.baseItems_ = {} 
	self.selectedItems_ = {}

	if params.normal then 
		self:setNormalImage(params.normal)
	end 
	if params.selected then 
		self:setSelectedImage(params.selected)
	end 
	if params.disabled then 
		self:setDisabledImage(params.disabled)
	end 
	if params.background then 
		self:setBackgroundImage(params.background)
	end 

end
--------------------------------

function StateNode:isSelected()
	return self.isSelected_
end

function StateNode:setSelected(b)
	if self.isSelected_ ~= b then
		self.isSelected_ = b

		self:update()
	end
	return self
end

function StateNode:isEnabled()
	return self.isEnabled_
end 

function StateNode:setEnabled(enabled)	
	if self.isEnabled_ ~= enabled then
		self.isEnabled_ = enabled 
		self:update()
	end 

	return self
end

function StateNode:update()
	local normalItem = self:getBase("normalImage_")
	local selectedItem = self:getBase("selectedImage_")
	local disabledItem = self:getBase("disabledImage_")

	if self.isEnabled_ then 		
		self:showItem(disabledItem, false)

		if self.isSelected_ then 
			self:showItem(normalItem, false)
			self:showItem(selectedItem, true)
		else 
			self:showItem(normalItem, true)
			self:showItem(selectedItem, false)
		end 
	else 
		self:showItem(disabledItem, true)
		
		if disabledItem then 
			self:showItem(normalItem, false)
			self:showItem(selectedItem, false)
		else 
			self:showItem(normalItem, true)
			self:showItem(selectedItem, false)
		end 
	end 
end 

--------------------------------
-- base
function StateNode:haveBase(key)
	if self.baseItems_[key] then 
		return true 
	end 
	return false 
end

function StateNode:getBase(key)
	return self.baseItems_[key] 
end

function StateNode:removeBase(key)
	if self.baseItems_[key] then 
		self.baseItems_[key]:removeSelf()
		self.baseItems_[key] = nil 
	end 	
end

function StateNode:addBase(img, zorder) 	
	if img then 
		local image = img 
		if type(img) == "string" then 
			image = display.newSprite(img)		
		end 
		image:addTo(self)
		if zorder then 	
			image:zorder(zorder)
		end 
		return image
	end  
end

function StateNode:addBaseWithKey(key, img, zorder)
	if img then 
		if type(img) == "string" then 
			self.baseItems_[key] = display.newSprite(img)
		else 
			self.baseItems_[key] = img 
		end 
		self.baseItems_[key]:addTo(self)
		if zorder then 	
			self.baseItems_[key]:zorder(zorder)
		end 
		return 	self.baseItems_[key]
	end 
	return nil
end
--------------------------------
-- change
function StateNode:setNormalImage(image, zorder) 
	self:removeBase("normalImage_")
	self:addBaseWithKey("normalImage_", image, zorder or 2)

	return self
end

function StateNode:setSelectedImage(image, zorder)
	self:removeBase("selectedImage_") 
		
	local spr = self:addBaseWithKey("selectedImage_", image, zorder or 2)
	if spr then 
		spr:setVisible(self.isSelected_)
	end 
	
	return self
end

function StateNode:setDisabledImage(image, zorder)
	self:removeBase("disabledImage_")
	local spr = self:addBaseWithKey("disabledImage_", image, zorder or 2)
	if spr then 
		spr:setVisible(not self.isEnabled_)
	end 
	
	return self	
end

function StateNode:setBackgroundImage(image)
	self:removeBase("backgroundImage_")
	self:addBaseWithKey("backgroundImage_", image)

	return self
end

function StateNode:showItem(item, b)
	if item then 
		if b then 
			item:show()
		else 
			item:hide()
		end 
	end 
end

return StateNode

