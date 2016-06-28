local StoneMergeLayer = class("StoneMergeLayer",function ()
	return display.newNode()
end)

local NodeBox = import("app.ui.NodeBox")
local ItemDropLayer = import(".ItemDropLayer")
local GafNode = import("app.ui.GafNode")

local boxImage = "Friends_Tips.png"
local redImage1 = "Button_Cancel.png"
local redImage2 = "Button_Cancel_Light.png"
local greenImage1 = "Button_Enter.png"
local greenImage2 = "Button_Enter_Light.png"
local greenImage3 = "Button_Gray.png"
local mergeImage = "Gear_ Attribute.png"
local materialImage = "Gear_Info.png"
local arrowImage = "Right_Arrow.png"
local awakeImage = "AwakeStone%d.png"
local selectImage = "Exp_Select.png"
local titleImage = "Box_Title.png"
local coinImage = "HeroStone.png"
local stuffImage = "Stuff.png"

local BUTTON_ID = {
    BUTTON_CANCEL = 1,
    BUTTON_SURE = 2,
}

function StoneMergeLayer:ctor(targetId,hero)
    self.hero = hero
    self.materialBtns = {}
    self.selectIndex = 0
    self.targetItem = ItemData:getItemConfig(targetId)

	local colorLayer = display.newColorLayer(cc.c4b(0,0,0,100))
    self:addChild(colorLayer)

    self.boxSprite = display.newSprite(boxImage)
    self.boxSprite:setPosition(display.cx,display.cy)
    self:addChild(self.boxSprite,2)

    self.boxSprite:setScale(0.3)
    local seq = transition.sequence({
        cc.ScaleTo:create(0.15, 1.15),
        cc.ScaleTo:create(0.05, 1)
        })
    self.boxSprite:runAction(seq)

    local titleSprite = display.newSprite(titleImage)
    titleSprite:setPosition(264,385)
    self.boxSprite:addChild(titleSprite)

    local param = {text = GET_TEXT_DATA("STONE_MERGE"),size = 26}
    local titleLabel = createOutlineLabel(param)
    titleLabel:setColor(cc.c3b(255,97,0))
    titleLabel:setPosition(140,25)
    titleSprite:addChild(titleLabel)

    self:createMergeView()
    self:createMaterialView()
    self:createBtns()
end

function StoneMergeLayer:createMergeView()
    local bgSprite = display.newSprite(mergeImage)
    bgSprite:setPosition(264,280)
    self.boxSprite:addChild(bgSprite)

    local arrowSprite = display.newSprite(arrowImage)
    arrowSprite:setScale(0.8)
    arrowSprite:setPosition(215,70)
    bgSprite:addChild(arrowSprite)

    local param = {text = self.targetItem.itemName,size = 18,color = COLOR_RANGE[self.targetItem.quality]}
    local nameLabel = createOutlineLabel(param)
    nameLabel:setPosition(215,30)
    bgSprite:addChild(nameLabel)

    local _text = GET_TEXT_DATA("TEXT_MERGE")
    local mergeLabel = createOutlineLabel({text = _text,size = 18})
    mergeLabel:setPosition(215,110)
    mergeLabel:setColor(cc.c3b(255,97,0))
    bgSprite:addChild(mergeLabel)

    if not GamePoint.mergeLevel(self.hero,self.targetItem) then
        _text = string.format(GET_TEXT_DATA("NEED_LEVEL"),self.targetItem.content.NeedLevel)
        mergeLabel:setString(_text)
        mergeLabel:setColor(display.COLOR_RED)
    elseif not GamePoint.mergeQuality(self.hero,self.targetItem) then
        local _type = self.targetItem.content.NeedHeroQuality
        _text = string.format(GET_TEXT_DATA("NEED_QUALITY"),GET_TEXT_COLOR(_type))
        mergeLabel:setString(_text)
        mergeLabel:setColor(display.COLOR_RED)
    end

    --当前宝石
    local currentIcon = self:createCurrentItemIcon()
    currentIcon:setPosition(80,55)
    bgSprite:addChild(currentIcon)

    --目标宝石
    local targetIcon = self:createTargetIcon()
    targetIcon:setPosition(350,55)
    bgSprite:addChild(targetIcon)
end

function StoneMergeLayer:createCurrentItemIcon()
    local image = string.format(awakeImage,0)
    local bgSprite = display.newSprite(image)
    bgSprite:setScale(0.7)

    local offsetX = bgSprite:getContentSize().width/2
    local offsetY = bgSprite:getContentSize().height/2

    local itemSprite = display.newSprite(self.targetItem.imageName,nil,nil,{class=cc.FilteredSpriteWithOne})
    itemSprite:setPosition(offsetX,offsetY)

    local filters = filter.newFilter("GRAY",{0.2, 0.3, 0.5, 0.1})
    itemSprite:setFilter(filters)
    bgSprite:addChild(itemSprite)

    return bgSprite
end

function StoneMergeLayer:getAbilityText(_type,value)
    local text = GET_ABILITY_TEXT(_type).."+"..value
    return text
end

function StoneMergeLayer:createTargetIcon()
    local itemId = self.targetItem.itemId
    local bgSprite = createItemIcon(itemId,false,0.7)
    local offsetX = bgSprite:getContentSize().width/2
    local offsetY = bgSprite:getContentSize().height/2

    local _text = self:getAbilityText(self.targetItem.content.Type,self.targetItem.content.Value)
    local label = display.newTTFLabel({text = _text, size = 26})
    label:setPosition(offsetX,80)
    bgSprite:addChild(label)

    return bgSprite
end

function StoneMergeLayer:createMaterialView()
    local titleLabel = display.newTTFLabel({text = GET_TEXT_DATA("NEED_STONE"),color = cc.c3b(255,97,0)})
    titleLabel:setPosition(90,190)
    self.boxSprite:addChild(titleLabel)

    local bgSprite = display.newSprite(materialImage)
    bgSprite:setPosition(264,125)
    self.boxSprite:addChild(bgSprite)

    local materialNode = self:createMaterialNode()
    materialNode:setPosition(202,45)
    bgSprite:addChild(materialNode)
end

function StoneMergeLayer:createMaterialNode()
    local length = #self.targetItem.content.NeedItemID
    local btnCallBack = handler(self,self.buttonEvent)
    for i=1,length do
        local itemId = self.targetItem.content.NeedItemID[i]
        local materialItem = ItemData:getItemConfig(itemId)
        local button = createItemIcon(itemId,true,0.7)
        :onButtonClicked(btnCallBack)
        button:setTag(i+2)
        table.insert(self.materialBtns,i,button)

        local label = display.newTTFLabel({text = "",size = 26})
        button:setButtonLabel(label)
        button:setButtonLabelOffset(45,-45)
    end

    local nodeBox = NodeBox.new()
    nodeBox:setCellSize(cc.size(100,90))
    nodeBox:setUnit(length)
    nodeBox:addElement(self.materialBtns)

    return nodeBox
end

function StoneMergeLayer:updateView()
    local length = #self.targetItem.content.NeedItemID
    for i=1,length do
        local materialItem = ItemData:getItemConfig(self.targetItem.content.NeedItemID[i])
        local count = ItemData:getItemCountWithId(materialItem.itemId)
        local needCount = self.targetItem.content.NeedItemNum[i]
        local text_ = count.."/"..needCount
        self.materialBtns[i]:setButtonLabelString(text_)
        if count < needCount then
            local label = self.materialBtns[i]:getButtonLabel()
            label:setColor(display.COLOR_RED)
        else
            local label = self.materialBtns[i]:getButtonLabel()
            label:setColor(display.COLOR_WHITE)
        end
    end
    self.sureBtn:setButtonEnabled(GamePoint.stoneMerge(self.hero,self.targetItem))
    if GamePoint.stoneMerge(self.hero,self.targetItem) then
        if not self.effectNode then
            local param = {gaf = "anniu_gaf"}
            self.effectNode = GafNode.new(param)
            self.effectNode:playAction("a1",true)
            self.effectNode:setPosition(384,-5)
            self.effectNode:setScaleX(1.2)
            self.boxSprite:addChild(self.effectNode)
        end
    else
        if self.effectNode then
            self.effectNode:removeFromParent()
            self.effectNode = nil
        end
    end
end

function StoneMergeLayer:createBtns()
	local btnCallBack = handler(self,self.buttonEvent)
	local cancelBtn = cc.ui.UIPushButton.new({normal = redImage1, pressed = redImage2})
	:onButtonClicked(btnCallBack)
    cancelBtn:setTag(BUTTON_ID.BUTTON_CANCEL)
    cancelBtn:setPosition(144,45)
    self.boxSprite:addChild(cancelBtn)

    local  param = {text = GET_TEXT_DATA("TEXT_CANCEL"),color = display.COLOR_WHITE,size = 28}
    local cancelLabel = display.newTTFLabel(param)
    cancelBtn:addChild(cancelLabel)

	self.sureBtn = cc.ui.UIPushButton.new({normal = greenImage1, pressed = greenImage2, disabled = greenImage3})
	:onButtonClicked(btnCallBack)
    self.sureBtn:setTag(BUTTON_ID.BUTTON_SURE)
    self.sureBtn:setPosition(384,45)
    self.boxSprite:addChild(self.sureBtn)

    local  param = {text = GET_TEXT_DATA("TEXT_MERGE"),color = display.COLOR_WHITE,size = 28}
    local sureLabel = display.newTTFLabel(param)
    self.sureBtn:addChild(sureLabel)
end

function StoneMergeLayer:showDropLayer(item)
    self.dropLayer = ItemDropLayer.new(item)
    self.dropLayer:setPosition(display.cx,display.cy)
    self:addChild(self.dropLayer,1)

    transition.moveBy(self.dropLayer, {x = 0, y = -203 ,time = 0.3})
    transition.moveBy(self.boxSprite, {x = 0, y = 90 ,time = 0.3})
end

function StoneMergeLayer:buttonEvent(event)
	local tag = event.target:getTag()
	if tag == BUTTON_ID.BUTTON_CANCEL then
        AudioManage.playSound("Click.mp3")
        if self.delegate then
            self.delegate:removeMergeLayer()
        end
	elseif tag == BUTTON_ID.BUTTON_SURE then
        AudioManage.playSound("SetGems.mp3")
        if self.delegate then
            self.delegate:stoneMerge()
        end
    else
        AudioManage.playSound("Click.mp3")
        if self.selectIndex ~= tag then
            self.selectIndex = tag
            local isNew = true
            if self.selectSprite then
                self.selectSprite:removeFromParent(true)
                self.selectSprite = nil
            end

            if self.dropLayer then
                isNew = false
                self.dropLayer:removeFromParent(true)
                self.dropLayer = nil
            end

            self.selectSprite = display.newSprite(selectImage)
            event.target:addChild(self.selectSprite,-1000)

            for i,v in ipairs(self.materialBtns) do
                if event.target == self.materialBtns[i] then
                    local item = ItemData:getItemConfig(tonumber(self.targetItem.content.NeedItemID[i]))
                    if isNew then
                        self:showDropLayer(item)
                    else
                        self.dropLayer = ItemDropLayer.new(item)
                        self.dropLayer:setPosition(display.cx,display.cy-203)
                        self:addChild(self.dropLayer,1)
                    end
                end
            end
        end
	end
end

return StoneMergeLayer