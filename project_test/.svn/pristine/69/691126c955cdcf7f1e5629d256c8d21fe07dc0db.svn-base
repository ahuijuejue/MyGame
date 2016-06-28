
--[[
	只可以进一次
]]

local AlertNode = class("AlertNode", function()
	return display.newNode()
end)

function AlertNode:ctor()
	self.btns_ = {}
	self.btnLayer_ = display.newNode():addTo(self)
	:zorder(5):pos(0, 0)

    self:addNodeEventListener(cc.NODE_EVENT, function(event)    	
    	if event.name == "enter" then   
    		print("alert node enter")
        	        	
            self:alignButtons()
        	self:alignTitleAndMessage()
        	
        	local realRect = self:getCascadeBoundingBox()
        	self:size(realRect.width, realRect.height)

        end        
    end)

    self:align(display.CENTER)
end

function AlertNode:setBackground(sprite)
    if self.background_ then 
        self.background_:removeFromParent()
        self.background_ = nil 
    end 

    if sprite then 
        self.background_ = sprite 
        :addTo(self)        
        :align(display.BOTTOM_LEFT)
        :pos(0, 0)
        :zorder(2)
    end 
    return self 
end

function AlertNode:setTitle(title)
	self.title_ = title 

	return self
end

function AlertNode:setMessage(msg)
	self.msg_ = msg 

	return self
end

function AlertNode:addButton(button, callBack)
	if callBack then 
		button:onButtonClicked(function(event)
			callBack(self)
		end)
	end 
	
	table.insert(self.btns_, button)

	return self
end 

function AlertNode:setButtonPosY(posY)
    self.btnPosY_ = posY 

    return self
end

function AlertNode:alignTitleAndMessage()
	local size
	if self.background_ then 
		local rect = self.background_:getCascadeBoundingBox()
		size = cc.size(rect.width, rect.height)        
	else 
		local rect = self:getCascadeBoundingBox()
		size = cc.size(rect.width, rect.height)       
	end 
	local top = size.height 
	local right = size.width 
	local c_w = size.width * 0.5
   
	if self.title_ then 		
        local s = self.title_:getContentSize()
        self.title_:pos(c_w, top - s.height * 0.5 - 5)
		if not self.title_:getParent() then             
			self.title_:addTo(self)
			:zorder(3)        		
			:align(display.CENTER)
		end 
		top = top - s.height - 5
	end 
	if self.msg_ then
        local btnRect = self.btnLayer_:getCascadeBoundingBox()
        local btnH = 0
        if #self.btns_ > 0 then 
            if self.btnPosY_ then 
                btnH = self.btnPosY_ + btnRect.height * 0.5
            else 
                btnH = btnRect.height * 1.2
            end 
        end 
        local h = top - btnH 
		self.msg_:pos(c_w, h * 0.5 + btnH)
        
		if not self.msg_:getParent() then 
			self.msg_:addTo(self)
			:zorder(4)        		
			:align(display.CENTER)	
		end 
	end

	return self 
end 

function AlertNode:alignButtons()
    local len = #self.btns_ 
    if len == 0 then 
        return 
    end
    local rect = self:getCascadeBoundingBox()
    
    local maxWidth = 0
    local maxHeight = 0
    for i,v in ipairs(self.btns_) do
        local width, height = v:getLayoutSize()        
        maxWidth = maxWidth + width        
        if maxHeight < height then 
            maxHeight = height            
        end 
        v:addTo(self.btnLayer_)
    end
    local paccing = rect.width - maxWidth     
    local perPaccing = paccing / len 
    local posX = 0 
    local posY = self.btnPosY_ or maxHeight * 0.7
    for i,v in ipairs(self.btns_) do
        local width, height = v:getLayoutSize()
        local realWidth = perPaccing + width        
        v:pos(posX + realWidth * 0.5, posY)
        posX = posX + realWidth
    end

    return self 
end

return AlertNode 