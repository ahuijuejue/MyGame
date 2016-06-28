local SummonLayer = class("SummonLayer",function()
    return display.newLayer()
end)

local MenuNode = import("..main.MenuNode")
local CashSummonNode = import(".CashSummonNode")
local DiamondSummonNode = import(".DiamondSummonNode")
local SecretSummonNode = import(".SecretSummonNode")

function SummonLayer:ctor()
	self:createCashSummon()
	self:createDiamondSummon()
    self:createVipSummon()

	self:addNodeEventListener(cc.NODE_EVENT,function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)
end

function SummonLayer:createCashSummon()
	self.cashNode = CashSummonNode.new()
	local posX = display.cx - 190
	local posY = display.cy-20
	self.cashNode:setPosition(posX,posY)
	self:addChild(self.cashNode)
end

function SummonLayer:createDiamondSummon()
	self.diamondNode = DiamondSummonNode.new()
    self.diamondNode.delegate = self
	local posX = display.cx + 170
	local posY = display.cy - 20
	self.diamondNode:setPosition(posX,posY)
	self:addChild(self.diamondNode)
end

function SummonLayer:showCardAnimation(callback)
    self.delegate:showCardAnimation(callback)
end

function SummonLayer:createVipSummon()
    self.secretNode = SecretSummonNode.new()
    local posX = display.cx + 310
    local posY = display.cy - 20
    self.secretNode:setPosition(posX,posY)
    self:addChild(self.secretNode)
end

function SummonLayer:updateView()
    if UserData:getVip() >= tonumber(GameConfig["CardSecretInfo"]["1"].AppearVipLv)  then
        self.cashNode:setPosition(display.cx-310,display.cy-20)
        self.diamondNode:setPosition(display.cx,display.cy-20)
        self.secretNode:show()
    else
        self.secretNode:hide()
    end
end

function SummonLayer:onEnter()
    self:updateView()
end

function SummonLayer:onExit()
end

return SummonLayer