
local SliderLayer = class("SliderLayer", function()
	return display.newNode()
end)

function SliderLayer:ctor()
	self:initView()
end

function SliderLayer:initView()
	display.newSprite("Update_Slip.png")
    :addTo(self)
    
    self.slider_ = self:slider("Update_Progress.png")    
    :addTo(self)

-- 更新进度
    self.upLabel_ = cc.ui.UILabel.new({
		text = "",
		size = 20,
		color = cc.c3b(250, 250, 0)
	})
    :addTo(self)
    :pos(-350, 30)    
end

function SliderLayer:setProcess(size, sizeMax)
	local str = string.format("%.2fMB/%.2fMB", size, sizeMax)
	self.upLabel_:setString(str)

	local per = 0 
	if sizeMax ~= 0 then 
		per = size / sizeMax
	end 

	self.slider_:setPercentage(math.min(per * 100, 100))
end 



--------------
--private:
function SliderLayer:slider(img) 
	local silider = display.newProgressTimer(img, display.PROGRESS_TIMER_BAR)
    silider:setMidpoint(cc.p(0, 1))       
    silider:setBarChangeRate(cc.p(1, 0))

    return silider
end 


return SliderLayer
