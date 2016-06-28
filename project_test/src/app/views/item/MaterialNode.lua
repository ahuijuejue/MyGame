local MaterialNode = class("MaterialNode",function ()
	return display.newNode()
end)

local NodeBox = import("app.ui.NodeBox")

local selectImage = "Exp_Select.png"

function MaterialNode:ctor(ids,nums)
	self.materialBtns = {}
    self.ids = ids
    self.nums = nums
    for i=1,#ids do
        local button = createItemIcon(ids[i],true,0.7)
        :onButtonClicked(handler(self,self.buttonEvent))
        button:setTag(i)
        table.insert(self.materialBtns,i,button)

        local count = ItemData:getItemCountWithId(ids[i])
        local needCount = nums[i]
        local text_ = count.."/"..needCount
        local label = display.newTTFLabel({text = text_,size = 24})
        if count < needCount then
            label:setColor(display.COLOR_RED)
        else
            label:setColor(display.COLOR_WHITE)
        end
        button:setButtonLabel(label)
        button:setButtonLabelOffset(40,-45)
    end

    local nodeBox = NodeBox.new()
    nodeBox:setCellSize(cc.size(100,90))
    nodeBox:setUnit(#ids)
    nodeBox:addElement(self.materialBtns)
    self:addChild(nodeBox)

    self.selectIndex = 0
end

function MaterialNode:updateMat()
    for i=1,#self.materialBtns do
        local label = self.materialBtns[i]:getButtonLabel()
        local count = ItemData:getItemCountWithId(self.ids[i])
        local needCount = self.nums[i]
        local text_ = count.."/"..needCount
        self.materialBtns[i]:setButtonLabelString(text_)
        if count < needCount then
            label:setColor(display.COLOR_RED)
        else
            label:setColor(display.COLOR_WHITE)
        end
    end
end

function MaterialNode:setNodeCallback(call)
        self.callback = call
end

function MaterialNode:resetNode()
    self.selectIndex = 0
    if self.selectSprite then
        self.selectSprite:removeFromParent(true)
        self.selectSprite = nil
    end
end

function MaterialNode:buttonEvent(event)
    AudioManage.playSound("Click.mp3")
	local tag = event.target:getTag()

	if self.selectIndex == tag then
		return
	end

	self.selectIndex = tag

	if self.selectSprite then
        self.selectSprite:removeFromParent(true)
        self.selectSprite = nil
    end

    self.selectSprite = display.newSprite(selectImage)
    event.target:addChild(self.selectSprite,-1000)

	if self.callback then
        local item = ItemData:getItemConfig(self.ids[tag])
		self.callback(item)
	end
end

return MaterialNode