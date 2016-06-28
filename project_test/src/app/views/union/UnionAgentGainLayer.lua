--[[
    公会雇佣兵所得
]]

local UnionAgentGainLayer = class("UnionAgentGainLayer", function()
	return display.newColorLayer(cc.c4f(0, 0, 0, 200))
end)
local BgImg = "union_agent_gain.png"
local iconImageName = "Gold.png"

function UnionAgentGainLayer:ctor(options)
	self:initData(options)
	self:initView()
end

function UnionAgentGainLayer:initData(options)
    self.heroId = options.heroId

    self.gainOne = UnionListData:getAgentGain( options.heroLevel, options.agentTimes)
    self.gainTwo = UnionListData:getProTectGain( options.heroLevel, options.time )
end

function UnionAgentGainLayer:initView()
	self.spriteBg = display.newSprite(BgImg):pos(display.cx-5,display.cy-20):addTo(self)

	-- 关闭按钮
	CommonButton.close()
	:addTo(self.spriteBg,3)
	:pos(440, 285)
	:scale(0.7)
	:onButtonClicked(function()
		CommonSound.close() -- 音效
		self.delegate:removeAgentGainLayer()
	end)

    createOutlineLabel({text = "雇佣收入：", size = 26}):scale(0.8):pos(105, 180):addTo(self.spriteBg)
    createOutlineLabel({text = "守营收入：", size = 26}):scale(0.8):pos(105, 130):addTo(self.spriteBg)

    display.newSprite(iconImageName):scale(0.9):pos(205, 180):addTo(self.spriteBg)
    display.newSprite(iconImageName):scale(0.9):pos(205, 130):addTo(self.spriteBg)

    createOutlineLabel({text = tostring(self.gainOne), size = 26}):scale(0.8):pos(275, 180):addTo(self.spriteBg)
    createOutlineLabel({text = tostring(self.gainTwo), size = 26}):scale(0.8):pos(275, 130):addTo(self.spriteBg)

    CommonButton.yellow("确定", {color = cc.c3b(252, 242, 181), size = 24})
    :onButtonClicked(function ()
        print("收回雇佣兵")
        NetHandler.gameRequest("CallBackMercenary", {param1 = self.heroId})
    end)
    :pos(215, 48)
    :addTo(self.spriteBg)

end

function UnionAgentGainLayer:updateData()

end

function UnionAgentGainLayer:updateView()

end

return UnionAgentGainLayer