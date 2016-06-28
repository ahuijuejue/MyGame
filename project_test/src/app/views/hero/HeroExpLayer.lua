local HeroExpLayer = class("HeroExpLayer",function ()
	return display.newNode()
end)

local ExpListView = import(".ExpListView")
local ExpItemView = import("..item.ExpItemView")

local bgImageName = "Background.png"

function HeroExpLayer:ctor()
    self.selectId = -1
    self:createListView()
    self:createExpItemView()
    self:addNodeEventListener(cc.NODE_EVENT,function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)
end

function HeroExpLayer:createListView()
    self.expListView = ExpListView.new()
    self.expListView.delegate = self
    self:addChild(self.expListView,2)
end

function HeroExpLayer:createExpItemView()
    self.expItemView = ExpItemView.new()
    self.expItemView.delegate = self
    self.expItemView:setPosition(display.cx+425,display.cy)
    self:addChild(self.expItemView)
end

function HeroExpLayer:setExpListTouchEnabled(enabled)
    self.expListView:setListTouchEnabled(enabled)
end

return HeroExpLayer