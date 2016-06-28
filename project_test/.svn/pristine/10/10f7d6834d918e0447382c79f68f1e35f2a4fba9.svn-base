local UnionEnterLayer = class("UnionEnterLayer",function ()
	return display.newNode()
end)
local CreateLayer = import(".UnionCreateLayer")

local TabNode = import("app.ui.TabNode")
local NodeBox = import("app.ui.NodeBox")
local UnionJoinLayer = import(".UnionJoinLayer")
local UnionCreateLayer = import(".UnionCreateLayer")
local UnionFindLayer = import(".UnionFindLayer")

local backImage = "Union_Board.png"
local tabNormalImage = "union_tab_2.png"
local tabPressedImage = "union_tab_1.png"
local unionTitleImg = "Union_Title.png"

local BUTTON_ID = {
	BUTTON_JOIN = 1,
	BUTTON_CREATE = 2,
	BUTTON_FIND = 3,
}

function UnionEnterLayer:ctor()
    self.viewTag = 1
    self.btnEvent = handler(self,self.buttonEvent)
    self:createBackgroud()
    self:createTabButton()
    self:createJoinLayer()
    self:createCreateLayer()
    self:createFindLayer()
end

function UnionEnterLayer:createBackgroud()
	self.backView = display.newSprite(backImage)
    self.backView:setPosition(display.cx-5,display.cy-30)
    self:addChild(self.backView)

    display.newSprite(unionTitleImg):pos(400,480):addTo(self.backView)
end

function UnionEnterLayer:createJoinLayer()
	self.joinLayer = UnionJoinLayer.new()
	self.backView:addChild(self.joinLayer)
end

function UnionEnterLayer:createCreateLayer()
    self.createLayer = UnionCreateLayer.new()
    self.createLayer:setVisible(false)
    self.createLayer.delegate = self
    self.createLayer.textName:setVisible(false)
    self.backView:addChild(self.createLayer)
end

function UnionEnterLayer:createFindLayer()
    self.findLayer = UnionFindLayer.new()
    self.findLayer:setVisible(false)
    self.findLayer.textName:setVisible(false)
    self.backView:addChild(self.findLayer)
end

function UnionEnterLayer:createTabButton()
    local param = {normal = tabNormalImage, pressed = tabPressedImage, event = self.btnEvent, imageLabel = true}

    local tab1 = TabNode.new(param)
    tab1:setTag(BUTTON_ID.BUTTON_JOIN)
    tab1:setTexture("Union_Enter_Btn.png")
    tab1:setOpacity(225)
    tab1:setPressedStatus()

    local tab2 = TabNode.new(param)
    tab2:setTag(BUTTON_ID.BUTTON_CREATE)
    tab2:setTexture("Union_Create_Btn.png")
    tab2:setOpacity(100)

    local tab3 = TabNode.new(param)
    tab3:setTag(BUTTON_ID.BUTTON_FIND)
    tab3:setTexture("Union_Find_Btn.png")
    tab3:setOpacity(100)

    self.tabNodes = {tab1,tab2,tab3}

    local nodeBox = NodeBox.new()
	nodeBox:setCellSize(cc.size(100,50))
	nodeBox:setSpace(120,0)
	nodeBox:setUnit(3)
	nodeBox:addElement(self.tabNodes)
	nodeBox:setPosition(406,400)
	self.backView:addChild(nodeBox)

    display.newSprite("Union_Line.png"):pos(406,375):addTo(self.backView)
end

function UnionEnterLayer:hideView()
    if self.viewTag == 1 then
        self.joinLayer:setVisible(false)
    elseif self.viewTag == 2 then
        self.createLayer:setVisible(false)
    elseif self.viewTag == 3 then
        self.findLayer:setVisible(false)
    end
end

function UnionEnterLayer:showView()
    if self.viewTag == 1 then
        self.joinLayer:setVisible(true)
        self.createLayer.textName:setVisible(false)
        self.findLayer.textName:setVisible(false)
    elseif self.viewTag == 2 then
        self.createLayer:setVisible(true)
        self.createLayer.textName:setVisible(true)
        self.findLayer.textName:setVisible(false)
    elseif self.viewTag == 3 then
        self.findLayer:setVisible(true)
        self.findLayer.textName:setVisible(true)
        self.createLayer.textName:setVisible(false)
    end
end

function UnionEnterLayer:buttonEvent(event)
    local tag = event.target:getTag()
	if self.viewTag == tag then
		return
	end
    AudioManage.playSound("Click.mp3")
	self.tabNodes[self.viewTag]:setNormalStatus()
	self.tabNodes[self.viewTag]:setOpacity(150)

	self.tabNodes[tag]:setPressedStatus()
	self.tabNodes[tag]:setOpacity(225)

    self:hideView()
    self.viewTag = tag
    self:showView()
end

return UnionEnterLayer
