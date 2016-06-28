--[[
    V5活动
]]

local V5GiftLayer = class("V5GiftLayer", function()
	return display.newNode()
end)
local GafNode = import("app.ui.GafNode")

function V5GiftLayer:ctor()
	self:addNodeEventListener(cc.NODE_EVENT,function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)

	self:initData()
	self:initView()

end

function V5GiftLayer:initData()
	self.itemsOne = {}
	local cfg = GameConfig["Vip"]

	for i,v in ipairs(cfg["5"]["GiftItemID"]) do
		self.itemsOne[i] = {
			itemId = v,
			count = cfg["5"]["GiftItemNum"][i]
		}
	end

end

function V5GiftLayer:initView()
	CommonView.blackLayer2()
    :addTo(self)

    self.layer_ = display.newNode():size(960, 640):align(display.CENTER)
    :addTo(self)
    :center()
    :zorder(1)

    -- 关闭按钮
	CommonButton.close()
	:scale(0.8)
	:addTo(self.layer_, 1)
	:pos(850, 520)
	:onButtonClicked(function()
		CommonSound.close() -- 音效

		self:onEvent_{name="close"}
	end)

	display.newSprite("V5_back.png")
	:addTo(self.layer_)
	:pos(455, 350)

    local firstcharge_gaf = GafNode.new({gaf = "gift_eff_gaf"})
    firstcharge_gaf:playAction("gift_eff_gaf",true)
    firstcharge_gaf:setGafPosition(482, 277)
    firstcharge_gaf:setFps(30)
    firstcharge_gaf:setTouchEnabled(false)
    firstcharge_gaf:addTo(self.layer_)

	local nItem = #self.itemsOne
	local addX = 120
	local startX = 630 - (nItem + 1) * 0.5 * addX

    ----第一组奖励
    for i,v in ipairs(self.itemsOne) do
    	local tab = 0
    	if i == 1 then
    		tab = i
    	end
    	self:createItem(v.itemId, v.count,tab)
    	:addTo(self.layer_)
    	:pos(startX + i * addX, 210)
    end

    ----充值
	local rechargeBtn =  CommonButton.button({
		normal="firstcharge_btn_normal.png",
		pressed="firstcharge_btn_selected.png",
	})
	rechargeBtn:addTo(self.layer_)
	rechargeBtn:pos(716, 97)
	rechargeBtn:onButtonClicked(function()
		self:toRechargeLayer()
	end)
	rechargeBtn:setScale(0.8)

    local function cudic(pos)
        pos = pos/0.5
        if (pos < 1) then return 0.5*math.pow(pos,3) end
        return 0.5 * (math.pow((pos-2),3) + 2);
    end

    local seq = cc.Sequence:create({cc.ScaleTo:create(cudic(0.5), 1),cc.DelayTime:create(0.2),cc.ScaleTo:create(cudic(0.5), 0.8)})
    rechargeBtn:runAction(cc.RepeatForever:create(seq))

	CommonView.animation_show_out(self.layer_)
end

function V5GiftLayer:createItem(itemId, count, i)
	local grid = UserData:createItemView(itemId, {scale=0.8})

	local label = base.Label.new({
		text = tostring(count),
		size = 18,
		color = CommonView.color_white(),
	})
	:align(display.BOTTOM_RIGHT)
	:pos(50, -50)

	grid:addItem(label)

	if i == 1 or i == 2 then
		local aniSprite = display.newSprite()
		aniSprite:setScale(0.7)
		grid:addItem(aniSprite:zorder(2))
    	local animation = createAnimation("coin%d.png",6,0.05)
    	transition.playAnimationForever(aniSprite,animation)
	end
	return grid
end

function V5GiftLayer:onEvent(listener)
	self.eventListener = listener

	return self
end

function V5GiftLayer:onEvent_(event)
	if not self.eventListener then return end

	event.target = self
	self.eventListener(event)
end

-- 跳转充值界面
function V5GiftLayer:toRechargeLayer()
	app:pushScene("RechargeScene")
end

function V5GiftLayer:updateData()
end

function V5GiftLayer:updateView()
end

function V5GiftLayer:onEnter()
	self:updateData()
	self:updateView()
	self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function V5GiftLayer:onExit()
	GameDispatcher:removeEventListener(self.netEvent)
end

return V5GiftLayer
