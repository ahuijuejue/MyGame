local GrowGiftLayer = class("GrowGiftLayer",function ()
	return display.newLayer()
end)

local bgImage = "grow_plan.png"
local btnImage1 = "grow_btn_1.png"
local btnImage2 = "grow_btn_2.png"
local btnImage3 = "grow_btn_3.png"
local btnImage4 = "grow_btn_4.png"

function GrowGiftLayer:ctor()
	local backSprite = display.newSprite(bgImage)
	backSprite:setPosition(594,266)
	self:addChild(backSprite)

	local btn1 = cc.ui.UIPushButton.new({normal = btnImage3, pressed = btnImage4})
	:onButtonClicked(function ()
		local price = GameConfig.Global["1"].FundDiamond
		if UserData.diamond < price then
			showToast({text = "钻石不足",color = display.COLOR_RED, size = 28})
		elseif UserData:getVip() < 2 then
			showToast({text = "VIP等级不足",color = display.COLOR_RED, size = 28})
		else
			NetHandler.gameRequest("PurchaseFund")
		end
    end)
    btn1:setPosition(200,60)
	backSprite:addChild(btn1)

	local btn2 = cc.ui.UIPushButton.new({normal = btnImage1, pressed = btnImage2})
	:onButtonClicked(function ()
		app:pushScene("RechargeScene")
    end)
    btn2:setPosition(450,60)
	backSprite:addChild(btn2)
end

return GrowGiftLayer