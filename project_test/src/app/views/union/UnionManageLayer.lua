local UnionManageLayer = class("UnionManageLayer",function ()
	return display.newColorLayer(cc.c4b(0, 0, 0, 200))
end)

local image_ = {
	    normal = "Union_Master_Btn.png",
	    pressed = "Union_Master_Btn.png",
	    disabled = "Union_Master_Btn.png",
	}
local pointImage = "Point_Red.png"

function UnionManageLayer:ctor()
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		if event.name == "began" then
			return true
		elseif event.name == "ended" then
			self.delegate:removeUnionManageLayer()
		end
    end)

	local spriteBg = display.newSprite("Union_Master_Bg.png"):pos(display.cx-5,display.cy-20):addTo(self)

    local posX = 135
    CommonButton.yellow3("入会申请",{image = image_})
    :onButtonClicked(function ()
    	self.delegate:createUnionApplyLayer()
	end)
	:pos(posX,390)
	:addTo(spriteBg)

	self.hallRedPoint = display.newSprite(pointImage):pos(posX+85,410):zorder(11)
    self.hallRedPoint:setVisible(false)
    spriteBg:addChild(self.hallRedPoint)

	CommonButton.yellow3("申请设置",{image = image_})
    :onButtonClicked(function ()
    	self.delegate:createUnionSetLayer()
	end)
	:pos(posX,310)
	:addTo(spriteBg)

	CommonButton.yellow3("全员邮件",{image = image_})
    :onButtonClicked(function ()
    	self.delegate:createUnionMailLayer()
	end)
	:pos(posX,230)
	:addTo(spriteBg)

    local string_ = "确定退出公会？"
    if UnionListData:getUnionDuty() == "1" and #UnionListData.unionMemberData == 1 then
    	string_ = "确定退出公会？(公会解散)"
    end
	CommonButton.yellow3("退出公会",{image = image_})
    :onButtonClicked(function ()
	    	AlertShow.show2("提示", string_, "确定", function(event)
				NetHandler.gameRequest("SecedeUnion")
			end, function()
		end)
	end)
	:pos(posX,150)
	:addTo(spriteBg)

	CommonButton.yellow3("其他",{image = image_})
    :onButtonClicked(function ()
    	showToast({text = "暂未开放！"})
	end)
	:pos(posX,70)
	:addTo(spriteBg)

end

function UnionManageLayer:updateView()
	if #UnionListData.applyData > 0 then
        self.hallRedPoint:setVisible(true)
    else
        self.hallRedPoint:setVisible(false)
    end
end

return UnionManageLayer