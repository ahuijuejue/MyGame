local ExpItemView = class("ExpItemView",function ()
	return display.newNode()
end)

local NodeBox = import("app.ui.NodeBox")
local BuyExpItemLayer = import(".BuyExpItemLayer")

local bgImage = "Exp_Board.png"
local itemImage = "ExpDrug%d.png"
local selectImage = "Exp_Select.png"

function ExpItemView:ctor()
	self.selectIndex = 0
	self.buyIndex = 0
	local bgBoard = display.newSprite(bgImage)
	self:addChild(bgBoard)

	self.btnTab = {}
	self.counts = {}
	self.itemSprite = {}
	self.labels = {}
	local btnCallBack = handler(self,self.buttonEvent)
	for i=1,4 do
		local button = cc.ui.UIPushButton.new()
		:onButtonClicked(btnCallBack)
   		button:setScale(0.7)
	    button:setTag(i)
		table.insert(self.btnTab,i,button)

		local item = ItemData:getItemConfig(EXP_ITEM[i])
		local sprite = display.newSprite(item.imageName,nil,nil,{class=cc.FilteredSpriteWithOne})			
   		button:addChild(sprite)
   		table.insert(self.itemSprite,sprite)

		local  param = {text = "", size = 30, color = display.COLOR_WHITE}
	    local label = display.newTTFLabel(param)
	    button:addChild(label,2)
	    table.insert(self.labels,label)

		local expItem = ItemData:getItemWithId(EXP_ITEM[i])
		if expItem then
			self.counts[i] = expItem.count

			local itemBox = string.format("AwakeStone%d.png",item.configQuality)
			button:setButtonImage("normal",itemBox)
			button:setButtonImage("pressed",itemBox)
		    label:setString(tostring(expItem.count))
		    label:setPosition(40,-45)
		else
			self.counts[i] = 0

			local filters = filter.newFilter("GRAY",{0.2, 0.3, 0.5, 0.1})
	   		sprite:setFilter(filters)

	   		button:setButtonImage("normal","AwakeStone0.png")
			button:setButtonImage("pressed","AwakeStone0.png")

			label:setString(GET_TEXT_DATA("TEXT_BUY"))
		    label:setPosition(0,0)
		end
	end

	local posX = bgBoard:getContentSize().width/2
	local posY = bgBoard:getContentSize().height/2

	local nodeBox = NodeBox.new()
	nodeBox:setCellSize(cc.size(90,100))
	nodeBox:addElement(self.btnTab)
	nodeBox:setPosition(posX,posY)
	bgBoard:addChild(nodeBox)
end

function ExpItemView:reduceExpItem()
	self.counts[self.selectIndex] = self.counts[self.selectIndex] - 1
	local button = self.btnTab[self.selectIndex]
	local label = self.labels[self.selectIndex]
	if self.counts[self.selectIndex] > 0 then
		label:setString(tostring(self.counts[self.selectIndex]))
		label:setPosition(40,-45)
	else
		local sprite = self.itemSprite[self.selectIndex]
		local filters = filter.newFilter("GRAY",{0.2, 0.3, 0.5, 0.1})
   		sprite:setFilter(filters)
		
		button:setButtonImage("normal","AwakeStone0.png")
		button:setButtonImage("pressed","AwakeStone0.png")

		label:setString(GET_TEXT_DATA("TEXT_BUY"))
	    label:setPosition(0,0)

		if self.selectSprite then
    		self.selectSprite:removeFromParent(true)
    		self.selectSprite = nil
    	end

    	self.selectIndex = 0
    	self:setSelectId(-1)
	end
end

function ExpItemView:addExpItem(count)
	self.counts[self.buyIndex] = self.counts[self.buyIndex] + count

	local button = self.btnTab[self.buyIndex]
	local label = self.labels[self.buyIndex]
	local sprite = self.itemSprite[self.buyIndex]

	local item = ItemData:getItemConfig(EXP_ITEM[self.buyIndex])
	local itemBox = string.format("AwakeStone%d.png",item.configQuality)

	button:setButtonImage("normal",itemBox)
	button:setButtonImage("pressed",itemBox)

	label:setString(tostring(self.counts[self.buyIndex]))
    label:setPosition(40,-45)

	sprite:clearFilter()
	self.buyIndex = 0
end

function ExpItemView:setSelectId(id)
	if self.delegate then
		self.delegate.selectId = id
	end
end

function ExpItemView:selectExpItem(index)
	self.selectIndex = index
	self:setSelectId(EXP_ITEM[index])
	self.selectSprite = display.newSprite(selectImage)
	self.btnTab[index]:addChild(self.selectSprite,-1000)
end

function ExpItemView:buttonEvent(event)
	AudioManage.playSound("Click.mp3")
    local tag = event.target:getTag()
    local count = self.counts[tag]

    if count>0 then
    	if self.selectSprite then
			self.selectSprite:removeFromParent(true)
			self.selectSprite = nil
		end

    	if self.selectIndex == tag then
    		self.selectIndex = 0
    		self:setSelectId(-1)
    	else
    		self:selectExpItem(tag)
    	end
   	else
		self.buyIndex = tag
		self.delegate:setExpListTouchEnabled(false)
   		self.buyLayer = BuyExpItemLayer.new(EXP_ITEM[tag])
   		self.buyLayer.delegate = self
    	display.getRunningScene():addChild(self.buyLayer,6)
    end
end

function ExpItemView:removeBuyLayer()
	self.delegate:setExpListTouchEnabled(true)
	self.buyLayer:removeFromParent(true)
	self.buyLayer = nil
end

return ExpItemView