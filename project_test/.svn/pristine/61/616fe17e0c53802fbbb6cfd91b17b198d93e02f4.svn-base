

local TextField
if cc.bPlugin_ then
    TextField = ccui.TextField
else
    TextField = cc.TextField
end

function TextField:size(width, height)
	local size = width 
    if type(width) ~= "table" then       
        size = cc.size(width, height)
    end
    -- self:setTextAreaSize(size)
    self:setTouchSize(size)
	self:setTouchAreaEnabled(true)

    return self
end 