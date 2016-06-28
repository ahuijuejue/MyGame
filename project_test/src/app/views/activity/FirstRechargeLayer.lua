--[[
首充活动
]]

local FirstRechargeLayer = class("FirstRechargeLayer", function()
	return display.newNode()
end)
local GafNode = import("app.ui.GafNode")

function FirstRechargeLayer:ctor()
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

function FirstRechargeLayer:initData()
	self.itemsOne = {}
	self.itemsTwo = {}
	local cfg = GameConfig["FirstRechargeInfo"]

	for i,v in ipairs(cfg["1"]["RAwardID"]) do
		self.itemsOne[i] = {
			itemId = v,
			count = cfg["1"]["RAwardNum"][i]
		}
	end

	for i,v in ipairs(cfg["2"]["RAwardID"]) do
		self.itemsTwo[i] = {
			itemId = v,
			count = cfg["2"]["RAwardNum"][i]
		}
	end

	self.vipDiamond = UserData:getVipExp()  -- 记录已充值的钻石数量  1 or 100
	self.firstRecharge = UserData:getFirstRecharge()

end

function FirstRechargeLayer:initView()
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

	display.newSprite("firstcharge_frame.png")
	:addTo(self.layer_)
	:pos(455, 350)

    local firstcharge_gaf = GafNode.new({gaf = "gift_eff_gaf"})
    firstcharge_gaf:playAction("gift_eff_gaf",true)
    firstcharge_gaf:setGafPosition(482, 277)
    firstcharge_gaf:setFps(30)
    firstcharge_gaf:setTouchEnabled(false)
    firstcharge_gaf:addTo(self.layer_)

    createOutlineLabel({text = "最多赠送6480钻石",size = 22}):pos(682, 422):addTo(self.layer_)

	local nItem = #self.itemsOne
	local addX = 90
	local startX = 530 - (nItem + 1) * 0.5 * addX

    ----第一组奖励
    for i,v in ipairs(self.itemsOne) do
    	local tab = 0
    	if i == 1 then
    		tab = i
    	end
    	self:createItem(v.itemId, v.count,tab)
    	:addTo(self.layer_)
    	:pos(startX + i * addX, 325)
    end

    self.getRewardOne = CommonButton.button({
		normal="firstvip_btn_normal.png",
		pressed="firstvip_btn_selected.png",
		disabled = "firstvip_btn_disabled.png"
	})
	:addTo(self.layer_)
	:pos(785, 310)
	:onButtonClicked(function()
		if self.vipDiamond >= tonumber(GameConfig["FirstRechargeInfo"]["1"].Rdiamond) then
			self:netToReward(1)
		else
			self:toRechargeLayer()
		end
	end)

    ----第二组奖励
    for i,v in ipairs(self.itemsTwo) do
    	self:createItem(v.itemId, v.count,i)
    	:addTo(self.layer_)
    	:pos(startX + i * addX, 190)
    end

    self.getRewardTwo = CommonButton.button({
		normal="firstvip_btn_normal.png",
		pressed="firstvip_btn_selected.png",
		disabled = "firstvip_btn_disabled.png"
	})
	:addTo(self.layer_)
	:pos(785, 175)
	:onButtonClicked(function()
		if self.vipDiamond >= tonumber(GameConfig["FirstRechargeInfo"]["2"].Rdiamond) then
			self:netToReward(2)
		else
			self:toRechargeLayer()
		end
	end)

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

function FirstRechargeLayer:createItem(itemId, count, i)
	local grid = UserData:createItemView(itemId, {scale=0.7})

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

function FirstRechargeLayer:onEvent(listener)
	self.eventListener = listener

	return self
end

function FirstRechargeLayer:onEvent_(event)
	if not self.eventListener then return end

	event.target = self
	self.eventListener(event)
end

-- 跳转充值界面
function FirstRechargeLayer:toRechargeLayer()
	app:pushScene("RechargeScene")
end

function FirstRechargeLayer:updateData()
    self.vipDiamond = UserData:getVipExp()
    self.firstRecharge = UserData:getFirstRecharge()
end

function FirstRechargeLayer:updateView()
	if self.vipDiamond >= tonumber(GameConfig["FirstRechargeInfo"]["1"].Rdiamond) and self.firstRecharge[1] == "0" then
	    if not self.effectNode1 then
	    	local param = {gaf = "anniu_gaf"}
		    self.effectNode1 = GafNode.new(param)
		    self.effectNode1:playAction("a1",true)
		    self.effectNode1:setPosition(785, 257)
		    self.effectNode1:addTo(self.layer_)
	    end
	end
	if self.vipDiamond >= tonumber(GameConfig["FirstRechargeInfo"]["2"].Rdiamond) and self.firstRecharge[2] == "0" then
		if not self.effectNode2 then
			local param = {gaf = "anniu_gaf"}
		    self.effectNode2 = GafNode.new(param)
		    self.effectNode2:playAction("a1",true)
		    self.effectNode2:setPosition(785, 122)
		    self.effectNode2:addTo(self.layer_)
		end
	end

	if self.firstRecharge[1] == "1" then
		if self.effectNode1 then
			self.effectNode1:removeFromParent()
			self.effectNode1 = nil
		end
		self.getRewardOne:setButtonEnabled(false)
	end
	if self.firstRecharge[2] == "1" then
		if self.effectNode2 then
			self.effectNode2:removeFromParent()
			self.effectNode2 = nil
		end
		self.getRewardTwo:setButtonEnabled(false)
	end
end

function FirstRechargeLayer:netToReward(id)
	print("领取奖励..."..id)
	NetHandler.request("FirstRecharge",{
    	data = {param1 = id },
    	onsuccess = function(params)
			showToast({text="领取成功"})
			UserData:showReward(params.items)
		end,
		onerror = function()
		end

	}, self)
end

function FirstRechargeLayer:onEnter()
	self:updateData()
	self:updateView()
	self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function FirstRechargeLayer:netCallback(event)
	local data = event.data
    local order = data.order
	if order == OperationCode.FirstRechargeProcess then
		self:updateData()
		self:updateView()
	end
end

function FirstRechargeLayer:onExit()
	GameDispatcher:removeEventListener(self.netEvent)
end

return FirstRechargeLayer
