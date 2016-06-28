
local ButtonGroup = class("ButtonGroup")

function ButtonGroup:ctor(params)
	params = params or {}	
	self.normalZorder = params.zorder1 or 1 
	self.selectedZorder = params.zorder2 or 1 
	-- self.offset_ = params.offset or cc.p(0, 0)

	self.buttons_ = {}
    self.currentSelectedIndex_ = 0 
end

function ButtonGroup:reset()
    self.buttons_ = {}
    self.currentSelectedIndex_ = 0 

    return self
end 

----------------------------------------------------------
-- public:
function ButtonGroup:addButton(button, index)
    if index then 
        table.insert(self.buttons_, index, button)
    else 
        table.insert(self.buttons_, button)
    end
    button:onClicked(handler(self, self.onButtonStateChanged_))
    
    button:zorder(self.normalZorder)
    return self
end

function ButtonGroup:addButtons(buttons)    
	for i,v in ipairs(buttons) do
		self:addButton(v)
	end
    
    return self
end

function ButtonGroup:getButtonAtIndex(index)
    return self.buttons_[index]
end

function ButtonGroup:getButtonsCount()
    return #self.buttons_
end

function ButtonGroup:getSelectedIndex()
    return self.currentSelectedIndex_
end

function ButtonGroup:selectedButtonAtIndex(index, selected)
	if selected == nil then 
		selected = true 
	end 
	local btn = self:getButtonAtIndex(index)
    self:onButtonStateChanged_({name="clicked", target=btn})

	return self 
end

function ButtonGroup:selectedButtonAtIndex_(index)
    local btn = self:getButtonAtIndex(index)
    self:updateButtonState_(btn, false)
    
    return self 
end 

function ButtonGroup:walk(callback)
	for i,v in ipairs(self.buttons_) do
		callback(i, v)
	end

    return self
end

--------------------------------------------------------

function ButtonGroup:onEvent(callback)
    self.eventListener_ = callback 
    return self
end

function ButtonGroup:onEvent_(event)
    if not self.eventListener_ then return end 
    event.target = self 
    self.eventListener_(event)
end

----------------------------------------------------------
function ButtonGroup:onButtonStateChanged_(event)     
    if event.name == "clicked" and event.target:isSelected() then
        return
    end
    if not event.target:isEnabled() then
        return
    end

    self:updateButtonState_(event.target, true)
end

function ButtonGroup:updateButtonState_(clickedButton, eventChange)	
    local currentSelectedIndex = 0
    for index, button in ipairs(self.buttons_) do
        if button == clickedButton then
            currentSelectedIndex = index
            if not button:isSelected() then
                button:setSelected(true)                
            end
            button:zorder(self.selectedZorder)           
        else
            if button:isSelected() then
                button:setSelected(false)                               
            end
            button:zorder(self.normalZorder)
        end
    end
    if self.currentSelectedIndex_ ~= currentSelectedIndex then     	
        local last = self.currentSelectedIndex_
        self.currentSelectedIndex_ = currentSelectedIndex
        if eventChange then 
            self:onEvent_({name="change", selected=currentSelectedIndex, last=last})
        end 
    end
end


return ButtonGroup 
