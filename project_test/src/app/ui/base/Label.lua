
--[[
local label = Label.new({
    text = "Hello, World\n您好，世界",
    font = "Arial",
    size = 64,
    color = cc.c3b(255, 0, 0), -- 使用纯红色
    align = cc.TEXT_ALIGNMENT_LEFT,
    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
    dimensions = cc.size(400, 200)
})
]]

local UILabel = require("framework.cc.ui.UILabel")

local Label =  class("Label", function(options, size)
	options = options or {}
	if type(options) ~= "table" then
		local str = options 
		options = {}
		options.text = str		
	end
	options.text = options.text or ""
	options.size = options.size or size
    -- options.font = options.font or "Marker Felt"
    options.align = options.align or cc.TEXT_ALIGNMENT_CENTER

	return UILabel.new(options)
	
end)

function Label:ctor(options)
	if options.border ~= false then 
		options.border = options.border or 2		
		local borderColor = options.borderColor or cc.c4b(41,12,0,255)
   		self:enableOutline(borderColor, options.border)		
	else
		if options.shadow then
			if type(options.shadow) ~= "table" then options.shadow = {} end 
			local shadowColor = options.shadow.color or cc.c4b(0, 0, 0, 255)
			local shadowSize = options.shadow.size or cc.size(1,-1)
			self:enableShadow(shadowColor, shadowSize)
		end
   	end 
end

return Label