--[[
    活动banner显示
]]

local BannerLayer = class("BannerLayer", function()
    return display.newColorLayer(cc.c4f(0, 0, 0, 150))
end)

function BannerLayer:ctor()
	self:initData()
    self:initView()
end

function BannerLayer:initData()
	self.isClose = 1
	self.bannerImage = UserData:getBannerImage()
end

function BannerLayer:initView()
    self.layer_ = display.newNode():size(960, 640):align(display.CENTER)
    :addTo(self)
    :center()
    :zorder(1)

    local image_ = {normal = "check_bottom_1.png", pressed = "check_bottom_2.png"}
    -- 关闭按钮
	CommonButton.yellow3("",{image = image_})
	:addTo(self.layer_, 1)
	:pos(480, 60)
	:onButtonClicked(function()
        self:btnEvent()
	end)

	self.bannerShow = display.newSprite(self.bannerImage[1])
	:pos(480,350)
	:addTo(self.layer_)

end

function BannerLayer:btnEvent()
	if self.isClose == #self.bannerImage then
	    self.delegate:removeBannerLayer()
	else
		self.bannerShow:setTexture(self.bannerImage[self.isClose+1])
		self.isClose = self.isClose + 1
	end
end

function BannerLayer:onEnter()
end

function BannerLayer:onExit()
end

return BannerLayer