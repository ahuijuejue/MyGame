local Label = import(".Label")
local UICheckBoxButton = require("framework.cc.ui.UICheckBoxButton")
local CheckBoxButton = class("CheckBoxButton", UICheckBoxButton)


--[[--

CheckBoxButton构建函数

@param table images 
{
	off,
	on,
}

@param table options 参数表

]]

function CheckBoxButton:ctor(images, options)
	CheckBoxButton.super.ctor(self, images, options)	
end 

function CheckBoxButton:addLabel(params)
	local label = base.Label.new(params) 	 
	label:align(display.CENTER)
	self:setButtonLabel(label)	
	self:setButtonLabelAlignment(display.CENTER)	

	return self 
end 

return CheckBoxButton








