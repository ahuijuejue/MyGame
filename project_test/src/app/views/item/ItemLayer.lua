local ItemLayer = class("ItemLayer",function ()
	return display.newNode()
end)

local NodeBox = import("app.ui.NodeBox")
local SellLayer = import(".SellItemLayer")
local ItemDropLayer = import(".ItemDropLayer")
local EquipLayer = import(".EquipLayer")
local UseItemLayer = import(".UseItemLayer")

local itemImage = "AwakeStone%d.png"
local redImage1 = "Button_Cancel.png"
local redImage2 = "Button_Cancel_Light.png"
local greenImage1 = "Button_Enter.png"
local greenImage2 = "Button_Enter_Light.png"
local closeImage = "Close.png"
local nameImage = "backpack_name.png"
local desImage = "backpack_ins.png"

function ItemLayer:ctor()
	self:createDesLabel()
	self:createNameLabel()

	self.box = NodeBox.new()
    self.box:setCellSize(cc.size(88,60))
	self.box:setSpace(65,0)
	self.box:setPosition(215,70)
    self:addChild(self.box)
end

function ItemLayer:createItemIcon(item)
	if self.itemIcon then
		self.itemIcon:removeFromParent(true)
		self.itemIcon = nil
	end
	self.itemIcon = createItemIcon(item.itemId)
	self.itemIcon:setPosition(120,445)
	self:addChild(self.itemIcon)
end

function ItemLayer:createNameLabel()
	local nameBg = display.newSprite(nameImage)
	nameBg:setPosition(270,445)
	self:addChild(nameBg)

	self.nameLabel = createOutlineLabel({text = "",size = 24})
	self.nameLabel:setAnchorPoint(0,0.5)
    self.nameLabel:setPosition(40,28)
    nameBg:addChild(self.nameLabel)
end

function ItemLayer:createDesLabel()
	local desBg = display.newSprite(desImage)
	desBg:setPosition(215,240)
	self:addChild(desBg)

	self.desLabel = createOutlineLabel({
		text = "",
		align = cc.ui.TEXT_ALIGN_LEFT,
		dimensions = cc.size(260, 0),
		size = 20})
	self.desLabel:setAnchorPoint(0,1)
    self.desLabel:setPosition(10,250)
    desBg:addChild(self.desLabel)
end

function ItemLayer:setBtns(item)
	self.btns = {}

	if item.value > 0 then
		local param1 = {normal = redImage1, pressed = redImage2}
		local param2 = {text = GET_TEXT_DATA("TEXT_SELL")}
		local button = createButtonWithLabel(param1,param2)
        :onButtonClicked(function ()
        	AudioManage.playSound("Click.mp3")
        	if UserData:getUserLevel() >= 5 then
	        	self:showSellLayer(item)
	        else
	        	local param = {text = "5级开启",size = 30,color = display.COLOR_RED}
	            showToast(param)
        	end
        end)
        button:setTag(1)
        table.insert(self.btns,button)
	end
	if item.useType > 0 then
		local param1 = {normal = greenImage1, pressed = greenImage2}
		local param2 = {text = GET_TEXT_DATA("TEXT_USE"),size = 26}
		local button = createButtonWithLabel(param1,param2)
		:onButtonClicked(function ()
			AudioManage.playSound("Click.mp3")
			if item.type == 6 then
				if UserData:getUserLevel() >= OpenLvData.expMode.openLv then
				    app:pushToScene("HeroExpScene")
		        else
		            local param = {text = OpenLvData.expMode.openLv.."级开启",size = 30,color = display.COLOR_RED}
		            showToast(param)
		        end
			elseif item.type == 7 then
				self:showUseLayer(item)
			elseif item.type == 15 then
				self:showUseLayer(item)
			elseif item.type == 16 then
				if UserData:getUserLevel() >= OpenLvData.tails.openLv then
		            SceneData:pushScene("Tails")
		        else
		            local param = {text = OpenLvData.tails.openLv.."级开启",size = 30,color = display.COLOR_RED}
		            showToast(param)
		        end
			elseif item.type == 17 then
				self:showUseLayer(item)
			elseif item.type == 22 then
			    app:pushToScene("HeroListScene")
			elseif item.type == 23 then
				self:showUseLayer(item)
			elseif item.type == 29 then
				if UserData:getUserLevel() >= GameConfig["CoinInfo"]["1"].OpenLeve then
			        app:pushScene("CoinScene")
			    else
			        showToast({text = string.format("%d级开启！", openLevel) })
			    end
			end
        end)
		button:setTag(2)
        table.insert(self.btns,button)
	end
	if item.detailType > 0 then
		local param1 = {normal = greenImage1, pressed = greenImage2}
		local param2 = {text = GET_TEXT_DATA("TEXT_DETAIL")}
		local button = createButtonWithLabel(param1,param2)
		:onButtonClicked(function ()
			AudioManage.playSound("Click.mp3")
			if item.type == 1 then
				self:showDropLayer(item)
			elseif item.type == 2 then
				self:showEquipLayer(item)
			elseif item.type == 3 then
				self:showDropLayer(item)
			elseif item.type == 4 then
				self:showDropLayer(item)
			elseif item.type == 5 then
				self:showDropLayer(item)
			elseif item.type == 20 then
				self:showDropLayer(item)
			elseif item.type == 29 then
				self:showDropLayer(item)
			end
        end)
		button:setTag(3)
        table.insert(self.btns,button)
	end
	self.box:cleanElement()
    self.box:setUnit(#self.btns)
    self.box:addElement(self.btns)
end

function ItemLayer:showDropLayer(item)
	self.delegate:setListTouchEnabled(false)

	local colorLayer = display.newColorLayer(cc.c4b(0,0,0,100))
	display.getRunningScene():addChild(colorLayer,5)

	local dropLayer = ItemDropLayer.new(item)
    dropLayer:setPosition(display.cx,display.cy)
    colorLayer:addChild(dropLayer)
    dropLayer:setScale(0.3)
    local seq = transition.sequence({
        cc.ScaleTo:create(0.15, 1.15),
        cc.ScaleTo:create(0.05, 1)
        })
    dropLayer:runAction(seq)

    local closeBtn = cc.ui.UIPushButton.new({normal = closeImage, pressed = closeImage})
	:onButtonClicked(function ()
		self.delegate:setListTouchEnabled(true)
		AudioManage.playSound("Close.mp3")
		colorLayer:removeFromParent(true)
		colorLayer = nil
		dropLayer = nil
		closeBtn = nil
	end)
	closeBtn:setPosition(230,100)
	dropLayer:addChild(closeBtn)
end

function ItemLayer:showEquipLayer(item)
	self.delegate:setListTouchEnabled(false)
	self.equipLayer = EquipLayer.new(item)
	self.equipLayer.delegate = self
	display.getRunningScene():addChild(self.equipLayer,5)
end

function ItemLayer:removeEquipLayer()
	self.delegate:setListTouchEnabled(true)
	self.equipLayer:removeFromParent(true)
	self.equipLayer = nil
end

function ItemLayer:showSellLayer(item)
	self.delegate:setListTouchEnabled(false)
	self.sellLayer = SellLayer.new(item)
	self.sellLayer.delegate = self
	display.getRunningScene():addChild(self.sellLayer,5)
end

function ItemLayer:removeSellLayer()
	self.delegate:setListTouchEnabled(true)
	self.sellLayer:removeFromParent(true)
	self.sellLayer = nil
end

function ItemLayer:showUseLayer(item)
	self.delegate:setListTouchEnabled(false)
	self.useLayer = UseItemLayer.new(item)
	self.useLayer.delegate = self
	display.getRunningScene():addChild(self.useLayer,5)
end

function ItemLayer:removeUseLayer()
	self.delegate:setListTouchEnabled(true)
	self.useLayer:removeFromParent(true)
	self.useLayer = nil
end

function ItemLayer:useItem(count,itemID)
	NetHandler.gameRequest("UseItem",{param2 = itemID, param3 = count})
end

function ItemLayer:sellItem(count,itemID,uId)
	local param = {param1 = itemID, param2 = uId, param3 = count}
	NetHandler.gameRequest("SellGoods",param)
end

function ItemLayer:updateView(item)
	self.nameLabel:setString(item.itemName)
	self.nameLabel:setColor(COLOR_RANGE[item.quality])
	self.desLabel:setString(item.desc)
	self:createItemIcon(item)
	self:setBtns(item)
end

return ItemLayer