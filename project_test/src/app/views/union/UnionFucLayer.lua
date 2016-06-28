local UnionFucLayer = class("UnionFucLayer",function ()
	return display.newColorLayer(cc.c4b(0, 0, 0, 200))
end)

local image_ = {
	    normal = "Union_Master_Btn.png",
	    pressed = "Union_Master_Btn.png",
	    disabled = "Union_Master_Btn.png",
	}

function UnionFucLayer:ctor(data)
    self.arr = data

	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		if event.name == "began" then
			return true
		elseif event.name == "ended" then
			self.delegate:removeUnionFucLayer()
		end
    end)

	local spriteBg = display.newSprite("Union_Master_Bg.png"):pos(display.cx-5,display.cy-20):addTo(self)

    -- 职能
    local posX = 135
    local btn1 = CommonButton.yellow3("转移会长",{image = image_})
    :onButtonClicked(function ()
    	AlertShow.show2("提示", string.format("转移会长给%s？", self.arr.name) , "确定", function(event)
            NetHandler.gameRequest("AppointUnion", {param1 = self.arr.id, param2 = 1})
        end, function()
        end)
	end)
	:addTo(spriteBg)
	:show()

	local btn2 = CommonButton.yellow3("任命副会长",{image = image_})
    :onButtonClicked(function ()
    	AlertShow.show2("提示", string.format("将%s任命为副会长？", self.arr.name), "确定", function(event)
            NetHandler.gameRequest("AppointUnion", {param1 = self.arr.id, param2 = 2})
        end, function()
        end)
	end)
	:addTo(spriteBg)
	:show()

	local btn3 = CommonButton.yellow3("任命管理员",{image = image_})
    :onButtonClicked(function ()
    	AlertShow.show2("提示", string.format("将%s任命为管理员？", self.arr.name), "确定", function(event)
            NetHandler.gameRequest("AppointUnion", {param1 = self.arr.id, param2 = 3})
        end, function()
        end)
	end)
	:addTo(spriteBg)
	:show()

	local btn4 = CommonButton.yellow3("取消任命",{image = image_})
    :onButtonClicked(function ()
    	AlertShow.show2("提示", "确定取消任命？", "确定", function(event)
            NetHandler.gameRequest("AppointUnion", {param1 = self.arr.id, param2 = 4})
        end, function()
        end)
	end)
	:addTo(spriteBg)
	:show()

	local btn5 = CommonButton.yellow3("踢出公会",{image = image_})
    :onButtonClicked(function ()
    	AlertShow.show2("提示", "确定踢出公会？", "确定", function(event)
                NetHandler.gameRequest("UnionEliminate", {param1 = self.arr.id})
            end, function()
            end)
	end)
	:addTo(spriteBg)
	:show()

    if UnionListData:getUnionDuty() == "1" then
    	if self.arr.duty == "2" then
    		btn1:pos(posX,390)
    		btn2:hide()
    		btn3:pos(posX,310)
    		btn4:pos(posX,230)
    		btn5:pos(posX,150)
	    elseif self.arr.duty == "3" then
	    	btn1:hide()
    		btn2:pos(posX,390)
    		btn3:hide()
    		btn4:pos(posX,310)
    		btn5:pos(posX,230)
	    elseif self.arr.duty == "4" then
	    	btn1:hide()
    		btn2:pos(posX,390)
    		btn3:pos(posX,310)
    		btn4:hide()
    		btn5:pos(posX,230)
	    end
    elseif UnionListData:getUnionDuty() == "2" then
    	 if self.arr.duty == "3" then
    	 	btn1:hide()
    		btn2:hide()
    		btn3:hide()
    		btn4:pos(posX,390)
    		btn5:pos(posX,310)
	    elseif self.arr.duty == "4" then
	    	btn1:hide()
    		btn2:hide()
    		btn3:pos(posX,390)
    		btn4:hide()
    		btn5:pos(posX,310)
	    end
    elseif UnionListData:getUnionDuty() == "3" then
	    if self.arr.duty == "4" then
	    	btn1:hide()
    		btn2:hide()
    		btn3:hide()
    		btn4:hide()
    		btn5:pos(posX,390)
	    end
    end
end

return UnionFucLayer