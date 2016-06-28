

local ScrollBar = class("ScrollBar", function()
	return display.newNode()
end)

function ScrollBar:ctor()
	self.height = 5
end 

-- 图片为竖条
function ScrollBar:setBackground(image)
	if self.bk_ then 
		self.bk_:removeFromParent()
	end
	self.bk_ = display.newScale9Sprite(image)
	if self.bk_ then 
		self.bk_
		:addTo(self)
		:size(self.bk_:getContentSize().width, self.height)
		:align(display.CENTER_BOTTOM)
	end
	return self
end

-- 图片为竖条
function ScrollBar:setSlider(image)
	if self.slider_ then 
		self.slider_:removeFromParent()
	end
	self.slider_ = display.newScale9Sprite(image)
	if self.slider_ then 
		self.slider_
		:addTo(self)
		:zorder(1)
		:size(self.slider_:getContentSize().width, self.height)
		:align(display.CENTER_BOTTOM)
	end
	return self
end 

function ScrollBar:length(lenth)	
	self.height = lenth
    
    if self.bk_ then 
    	self.bk_:size(self.bk_:getContentSize().width, self.height)
    end 

    return self
end

function ScrollBar:sliderSizeRatio(ratio)
	if self.slider_ then 
		transition.stopTarget(self.slider_)
		local size = self.bk_:getContentSize()
		local h = self.height * ratio
		if h < size.width then 
			h = size.width 
		end 
    	self.slider_:size(size.width, h)
    end 
end

function ScrollBar:sliderPositionRatio(ratio)
	if self.slider_ then 
	 	local length = self.height - self.slider_:getContentSize().height
	 	posY = length * ratio
	 	if posY < 0 then 
	 		posY = 0
	 	elseif posY > length then 
	 		posY = length
	 	end 
	 	-- posY = posY + self.slider_:getContentSize().height * 0.5
	 	local x, y = self.slider_:getPosition()
	 	self.slider_:pos(x, posY)
	end 
end

return ScrollBar



