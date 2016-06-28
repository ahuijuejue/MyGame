
local c = cc 
local UIPushButton = c.ui.UIPushButton 

function UIPushButton:getNoramlImage()
	return self.images_[self.NORMAL]
end

function UIPushButton:grayDisabled(b, color)
	self.grayDis_ = b 
	if color then 
		self.grayColor_ = color 
	end 
	return self 
end

function UIPushButton:updateButtonImage_()
	local state = self.fsm_:getState()
	if self.grayDis_ then 
		self.currentImage_ = nil 
		UIPushButton.super.updateButtonImage_(self)
		if state == UIPushButton.DISABLED then 
			for i,v in ipairs(self.sprite_) do
	            v:setColor(self.grayColor_ or cc.c3b(100, 100, 100))            
	        end
	    end 
    else 
    	UIPushButton.super.updateButtonImage_(self)
	end 	
end 