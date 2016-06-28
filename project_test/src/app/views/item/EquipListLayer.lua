local EquipListLayer = class("EquipListLayer",function ()
	return display.newNode()
end)

local UIListView = import("framework.cc.ui.UIListView")

local boxImage = "Friends_Tips.png"
local closeImage = "Close.png"
local titleImage = "Box_Title.png"
local pointImage = "Point_Red.png"
local nameBg = "Gear_Name.png"

local unit = 3

function EquipListLayer:ctor(equips)
	self.equips = equips
    self:createBackView()
    if #equips > 0 then
        self:createListItem()
    else
        local param = {text = GET_TEXT_DATA("NO_REPLACE_EQUIP"), color = display.COLOR_RED}
        local emptyLabel = createOutlineLabel(param)
        emptyLabel:setPosition(260,200)
        self.listView:addChild(emptyLabel,1)
    end
end

function EquipListLayer:createBackView()
    local colorLayer = display.newColorLayer(cc.c4b(0,0,0,100))
    self:addChild(colorLayer)

    local backSprite = display.newSprite(boxImage)
    backSprite:setPosition(display.cx,display.cy)
    colorLayer:addChild(backSprite)

    backSprite:setScale(0.3)
    local seq = transition.sequence({
        cc.ScaleTo:create(0.15, 1.15),
        cc.ScaleTo:create(0.05, 1)
        })
    backSprite:runAction(seq)

    local titleSprite = display.newSprite(titleImage)
    titleSprite:setPosition(264,385)
    backSprite:addChild(titleSprite,2)

    local titleLabel = createOutlineLabel({text = GET_TEXT_DATA("TEXT_EQUIP"),size = 26})
    titleLabel:setPosition(140,25)
    titleLabel:setColor(cc.c3b(255,97,0))
    titleSprite:addChild(titleLabel)

    self.listView = self:createListView()
    backSprite:addChild(self.listView)

    local closeBtn = cc.ui.UIPushButton.new({normal = closeImage, pressed = closeImage})
    :onButtonClicked(function ()
        AudioManage.playSound("Close.mp3")
        self:removeFromParent(true)
    end)
    closeBtn:setPosition(500,390)
    backSprite:addChild(closeBtn)
end

function EquipListLayer:createListView()
	local params = {viewRect = cc.rect(5,17,520,350),direction = cc.ui.UIScrollView.DIRECTION_VERTICAL}
	listView = UIListView.new(params)
    return listView
end

function EquipListLayer:createListItem()
	local itemCount = math.ceil(#self.equips/unit)
	for i=1,itemCount do
        local item = self.listView:newItem()
        local content = display.newNode()
        for count = 1,unit do
            local index = (i-1)*unit + count
            if index <= #self.equips then
                local equip = self.equips[index]
            	local equipNode = createItemIcon(equip.itemId,true)
                equipNode:onButtonClicked(function ()
                    if self.delegate then
                        AudioManage.playSound("SetGear.mp3")
                        self.delegate:updateHeroEquip(self.equips[index])
                        self.delegate:removeEquipListLayer()
                    end
                end)

                local nameBackSprite = display.newSprite(nameBg)
                nameBackSprite:setPosition(0,-80)
                equipNode:addChild(nameBackSprite)

                local nameLabel = createOutlineLabel({text = equip.itemName,size = 20})
                nameLabel:setPosition(81,19)
                nameBackSprite:addChild(nameLabel)

                if index == 1 then
                    local point = display.newSprite(pointImage)
                    point:setPosition(42,42)
                    equipNode:addChild(point)
                end

                local posX = (count-1)*165+37
                equipNode:setPosition(posX,65)
                content:addChild(equipNode)
            end    
        end
        content:setContentSize(405,100)
        item:addContent(content)
        item:setItemSize(430,165)
        self.listView:addItem(item)
    end
    self.listView:reload()
end

return EquipListLayer