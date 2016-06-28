
local ShopItemLayer = class("ShopItemLayer", function()
	return display.newNode()
end)
local GafNode = import("app.ui.GafNode")

function ShopItemLayer:ctor()
	self:initView()

	self.idx_ = 0
end

function ShopItemLayer:setIndex(index)
	self.idx_ = index
	return self
end

function ShopItemLayer:getIndex()
	return self.idx_
end

function ShopItemLayer:initView()

	CommonView.blackLayer2()
	:addTo(self)
	:onTouch(function(event)
		if event.name == "began" then
			return true
		end
	end)

---------------------------------------------------------
	local back = CommonView.mFrame1()
	:addTo(self)
	:pos(display.cx, display.cy)

	display.newSprite("Pay_Shading_UP.png")
	:addTo(back)
	:pos(270, 270)

	display.newSprite("Pay_Shading_Down.png")
	:addTo(back)
	:pos(260, 150)

	local layer_ = display.newNode():addTo(back)

	self.title_ = base.Label.new({size=20})
	:addTo(layer_)
	:pos(170, 282)


	self.subTitle_ = base.Label.new({size=18, color=cc.c3b(250, 250, 0)}):align(display.CENTER_RIGHT)
	:addTo(layer_)
	:pos(400, 258)


	base.Label.new({text="说明：", size=22, color=cc.c3b(250,250,0)}):addTo(layer_)
	:pos(80, 190)

	self.description_ = base.Label.new({
		size = 20,
		align = cc.TEXT_ALIGNMENT_LEFT,
		dimensions = cc.size(320, 60),
	})
	:addTo(layer_)
	:pos(100, 170)
	:align(display.TOP_LEFT)

	self.priceLabel_ = base.Label.new({size=20})
	:addTo(layer_)
	:pos(300, 105)


	-- 物品数量
	self.itemNum_ = base.Label.new({size=20})
	:addTo(layer_)
	:pos(100, 105)

	-- 按钮
	self.cancelBtn_ = CommonButton.red("取消")
	:addTo(layer_)
	:pos(120, 45)

	self.okBtn_ = CommonButton.green("确定")
	:addTo(layer_)
	:pos(400, 45)
	if not self.effectNode then
		local param = {gaf = "anniu_gaf"}
	    self.effectNode = GafNode.new(param)
	    self.effectNode:playAction("a1",true)
	    self.effectNode:setPosition(400,-5)
	    self.effectNode:setScaleX(1.2)
	    layer_:addChild(self.effectNode,2)
	end

	self.layer_ = layer_
end

function ShopItemLayer:setTitle(title, color)
	self.title_:setString(title)
	if color then
		self.title_:setColor(color)
	end
	return self
end

function ShopItemLayer:setHave(num)
	local str = string.format("拥有%d件", num)
	self.subTitle_:setString(str)
	return self
end

function ShopItemLayer:setDescription(txt)
	if txt then
		self.description_:setString(txt)
	end
	return self
end

function ShopItemLayer:setIcon(image)
	if self.itemIcon_ then
		self.itemIcon_:removeFromParent()
		self.itemIcon_ = nil
	end

	if image then
		if type(image) == "string" then
			image = display.newSprite(image)
		end
		self.itemIcon_ = image:addTo(self.layer_)
		:zorder(2)
		:pos(95, 290)
	end
	return self
end
-- 边框
function ShopItemLayer:setBorder(image)
	if self.itemBorder_ then
		self.itemBorder_:removeFromParent()
		self.itemBorder_ = nil
	end

	if image then
		self.itemBorder_ = display.newSprite(image):addTo(self.layer_):zorder(1)
		:pos(95, 290)
	end
	return self
end

function ShopItemLayer:setItemNum(num)
	self.itemNum_:setString(string.format("购买%d件", num))

	return self
end

function ShopItemLayer:setPrice(value)
	if type(value) == "number" then
		local num = value
		value = string.format("%d", num)
	end
	self.priceLabel_:setString(value)

	return self
end

function ShopItemLayer:setPriceUnit(unit)
	if self.unitImg_ then
		self.unitImg_:removeSelf()
		self.unitImg_=nil
	end

	if unit then
		self.unitImg_ = display.newSprite(unit):addTo(self.layer_)
		:pos(280, 105)
		:scale(0.8)
	end

	return self
end

function ShopItemLayer:onOk(listener)
	self.okBtn_:onButtonClicked(function(event)
		CommonSound.click() -- 音效

		listener(self)
	end)

	return self
end

function ShopItemLayer:onCancel(listener)
	self.cancelBtn_:onButtonClicked(function(event)
		CommonSound.click() -- 音效

		listener(self)
	end)

	return self
end

return ShopItemLayer
