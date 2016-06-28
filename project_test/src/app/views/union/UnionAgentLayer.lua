--[[
    公会雇佣兵
]]

local UnionAgentLayer = class("UnionAgentLayer", function()
	return display.newColorLayer(cc.c4f(0, 0, 0, 200))
end)

local TabNode = import("app.ui.TabNode")
local UnionAgentOwnLayer = import(".UnionAgentOwnLayer")
local UnionAgentAllLayer = import(".UnionAgentAllLayer")

local tabPressImage = "Label_Select.png"
local tabNormalImage = "Label_Normal.png"
local BgImg = "Union_Mail_Bg.png"
local title = "union_agent_title.png"
local word = "union_agent_word.png"
local list = "union_agent_list.png"

local BUTTON_ID = {
    BUTTON_OWN = 1,
    BUTTON_ALL = 2,
}

function UnionAgentLayer:ctor()
    self.viewTag = 1
	self:createBackgroud()
    self:createTabButton()
    self:createOwnLayer()
    self:createAllLayer()
end

function UnionAgentLayer:createBackgroud()
	self.spriteBg = display.newSprite(BgImg):pos(display.cx-5,display.cy-20):addTo(self)
	display.newSprite(title):pos(390, 440):addTo(self.spriteBg)
	display.newSprite(word):pos(390, 447):addTo(self.spriteBg)

	-- 关闭按钮
	CommonButton.close()
	:addTo(self.spriteBg,3)
	:pos(760, 445)
	:scale(0.7)
	:onButtonClicked(function()
		CommonSound.close() -- 音效
		self.delegate:removeAgentLayer()
	end)
end

function UnionAgentLayer:createOwnLayer()
    self.ownLayer = UnionAgentOwnLayer.new()
    self.ownLayer.delegate = self
    self.spriteBg:addChild(self.ownLayer)
end

function UnionAgentLayer:createAllLayer()
    self.allLayer = UnionAgentAllLayer.new()
    self.allLayer:setVisible(false)
    self.allLayer.delegate = self
    self.spriteBg:addChild(self.allLayer)
end

function UnionAgentLayer:createTabButton()
    local btnEvent = handler(self,self.buttonEvent)
    local param = {normal = tabNormalImage, pressed = tabPressImage, size = 18,event = btnEvent}
    local allTab = TabNode.new(param)
    allTab:setPosition(805,360)
    allTab:setTag(BUTTON_ID.BUTTON_OWN)
    allTab:setString("我的佣兵")
    self.spriteBg:addChild(allTab)

    allTab:setLocalZOrder(3)
    allTab:setPressedStatus()

    local tankTab = TabNode.new(param)
    tankTab:setTag(BUTTON_ID.BUTTON_ALL)
    tankTab:setPosition(805,290)
    tankTab:setString("所有佣兵")
    self.spriteBg:addChild(tankTab)

    self.tabNodes = {allTab,tankTab}

end

function UnionAgentLayer:resetTabStatus()
    for k in pairs(self.tabNodes) do
        self.tabNodes[k]:setNormalStatus()
        self.tabNodes[k]:setLocalZOrder(1)
    end
end

function UnionAgentLayer:hideView()
    if self.viewTag == 1 then
        self.ownLayer:setVisible(false)
    elseif self.viewTag == 2 then
        self.allLayer:setVisible(false)
    end
end

function UnionAgentLayer:showView()
    if self.viewTag == 1 then
        self.ownLayer:setVisible(true)
        self.ownLayer:updateData()
        self.ownLayer:updateView()
    elseif self.viewTag == 2 then
        self.allLayer:setVisible(true)
        self.allLayer:updateData()
        self.allLayer:updateView()
    end
end

function UnionAgentLayer:buttonEvent(event)
    AudioManage.playSound("Click.mp3")

    local tag = event.target:getTag()
    self:resetTabStatus()
    event.target:setLocalZOrder(3)
    event.target:setPressedStatus()

    self.tabNodes[self.viewTag]:setNormalStatus()
    self.tabNodes[self.viewTag]:setLocalZOrder(1)

    self:hideView()
    self.viewTag = tag
    self:showView()
end

function UnionAgentLayer:updateData()
    if self.ownLayer then
        self.ownLayer:updateData()
    end
    if self.allLayer then
        self.allLayer:updateData()
    end
end

function UnionAgentLayer:updateView()
    if self.ownLayer then
        self.ownLayer:updateView()
    end
    if self.allLayer then
        self.allLayer:updateView()
    end
end

return UnionAgentLayer
