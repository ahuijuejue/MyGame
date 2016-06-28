--
-- Author: zsp
-- Date: 2014-12-30 17:09:58
--
local LoadingLayer = require("app.ui.LoadingLayer")
local scheduler  = require(cc.PACKAGE_NAME .. ".scheduler")
--[[
	战斗动画资源加载层
--]]
local BattleLoadingLayer = class("BattleLoadingLayer",function()
   return display.newLayer()
end)

function BattleLoadingLayer:ctor()

	self:setNodeEventEnabled(true)

    --随机背景图片
    newrandomseed()
	local y = math.random(1,tonumber(GameConfig.Global["1"].LoadingRandomLimit))
	local image = string.format("Loading_%d.jpg",y)
	local load_bg = display.newSprite(image)
    load_bg:pos(display.cx, display.cy)
    load_bg:addTo(self)

    --加载时不变的字符串
	self.label =  createOutlineLabel({
		text  = "加载中不消耗流量",
		size  = 25,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.label:setPosition(display.cx,display.cy - 225)
	self.label:addTo(self)

    --进度条
    self.load_slip = display.newSprite("Loading_Slip.png")
	self.load_slip:pos(display.cx, display.cy - 255)
	self:addChild(self.load_slip,5)

	self.load_progress = cc.ui.UILoadingBar.new({
        	scale9 = false,
        	image = "Loading_Progress.png",
        	percent = 0,
        	viewRect = cc.rect(0,0,690,17)
        	})
    self.load_progress:pos(9,9)
    self.load_progress:addTo(self.load_slip)

    self.load_point = display.newSprite("Loading_Point.png")
    self.load_point:pos(2,17)
    self.load_point:addTo(self.load_slip,10)
    self.load_point:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.2,2),cc.ScaleTo:create(0.2,1))))

    --加载时的Tips
    local tipBg = display.newSprite("Loading_Tips_Bar.png")
    tipBg:pos(display.cx,display.cy - 290)
    tipBg:addTo(self)

    newrandomseed()
	local x = math.random(1,table.nums(GameConfig.Tips))
	self.tips = GameConfig.Tips[tostring(x)].Info

    self.label_ =  createOutlineLabel({
		text  = self.tips,
		size  = 25,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.label_:setPosition(display.cx,display.cy - 290)
	self.label_:zorder(2)
	self.label_:addTo(self)
end

--[[
	加载动画资源
	assetNames 动画资源名
	onLoadEnd 加载后回调
--]]
function BattleLoadingLayer:load(assetNames,onLoadEnd)
	self.assetNames = assetNames or {}
	--onLoadEnd --资源加载完的回调
	self.onLoadEnd = onLoadEnd
	GafAssetCache.load(assetNames,function(num,total)
		--加载进度条
        local percent_ = num/total
        self.load_progress:setPercent(percent_*100)
		self.load_point:setPosition(percent_*693,17)
		if num == total then
			scheduler.performWithDelayGlobal(handler(self,self.loadEnd),0)
		end
	end)
end

--[[
	加载结束
--]]
function BattleLoadingLayer:loadEnd()
	self:onLoadEnd()
	self:removeFromParent()
end

return BattleLoadingLayer