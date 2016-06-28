
--[[
奖励物品弹出界面 
]]

local RewardLayer = class("RewardLayer", function()
	return display.newNode()
end)
local GafNode = import("app.ui.GafNode")

function RewardLayer:ctor(params)
	self:initData(params)
	self:initView()
end

function RewardLayer:initData(params)
	self.items = params.items or {} 	
end

function RewardLayer:initView()

	-- 灰层背景	
	CommonView.blackLayer2()
    :addTo(self)
    :onTouch(function()
    	-- body
    end)

    local layer_ = display.newNode():size(960, 640):align(display.CENTER):addTo(self):center()
	self.layer_ = layer_
-- 主层
	local param = {gaf = "get_item"}
	self.effectNode = GafNode.new(param)
	self.effectNode:playAction("idle1",false)
	self.effectNode:setPosition(display.cx,display.cy-180)
	self:addChild(self.effectNode)
	self:setGlobalZOrder(10)
	self.effectNode:setActCallback(function (name)
		if name == "idle1" then
			self:showItems(function()
				self.closeBtn:show()
			end)
			self.effectNode:playAction("idle2",false)
		end
    end)
    ------------------------------------
 	-- 关闭按钮
	self.closeBtn = CommonButton.yellow("确定")
	:addTo(self.layer_)
	:pos(480, 100)
	:onButtonClicked(function()		
		self:onEvent_{name="close"}			

		CommonSound.click() -- 音效 
	end)
	:hide()
end 

-- function RewardLayer:showFlayTo(target, time, posX, posY, callback)
-- 	target:setOpacity(0)
-- 	local actions = {
-- 		transition.create(cc.MoveTo:create(time, cc.p(posX, posY)), {easing = "backout",}),
-- 		cc.FadeTo:create(time, 255),
-- 	}

-- 	local action = cc.Spawn:create(actions)
-- 	if callback then 
-- 		action = transition.sequence({
-- 			action,
-- 			cc.CallFunc:create(callback)
-- 		})		
-- 	end 
-- 	target:runAction(action)
-- end 

function RewardLayer:showItems(callback)
	local nItem = table.nums(self.items) 
	local nVert = 5
	local nRow = 1

    if nItem > nVert then 
	    self.listView_ = base.GridView.new({
	    	rows = nVert,
	    	viewRect = cc.rect(0, 0, 750, 300),
	    	itemSize = cc.size(150, 150),
	    }):addTo(self.layer_, 3)
	    :setBounceable(false)
	    :pos(100, 70)
	    :addItems(nItem, function(event)
			local index = event.index 
	    	local data = self.items[index] 
	    	local grid = base.Grid.new()

	    	self:performWithDelay(function()
	    		self:showGrid(grid, data)
	    		grid:scale(0.0)
	    		transition.scaleTo(grid, {
	    			scale = 1,
	    			time = 0.2,
	    			easing = "backout",
	    		})
	    		if nItem == index then 
	    			self:showItemsEnd(callback)
	    		end 
	    		local tIndex = math.floor((index-1)/nVert)

	    		if tIndex > nRow then 
	    			nRow = tIndex
	    			self.listView_:setScrollPosition2((nRow-1)*150+50, true)
	    		end 

	    	end, (index-1) * 0.1)

	    	return grid 
	    end)
	    :reload()

	    self.closeBtn:pos(480, 35)
	else 
		local addX = 180 
		local posX = 480 - (nItem - 1) * addX / 2 
		local posY = 260 
		for i,v in ipairs(self.items) do
			local grid = base.Grid.new():addTo(self.layer_)
			:pos(posX + (i-1) * addX, posY)
			:zorder(3)

			self:performWithDelay(function()
	    		self:showGrid(grid, v)
	    		grid:scale(0.0)
	    		transition.scaleTo(grid, {
	    			scale = 1,
	    			time = 0.2,
	    			easing = "backout",
	    		})
	    		if nItem == i then 
	    			self:showItemsEnd(callback)
	    		end 
	    	end, (i-1) * 0.3)			
		end
	end 
end 

function RewardLayer:showItemsEnd(callback)
	if callback then 
		callback()
	end 
end 

function RewardLayer:showGrid(grid, data)
	grid:addItem(UserData:createView(data, {quality=data.quality}))	
	grid:addItem(base.Label.new({text=data.name or "", size=18}):pos(0, -70):align(display.CENTER))

	-- 特效
	local aniSpr = UserData:createAniEffect(data)
	if aniSpr then 
		grid:setBackgroundImage(aniSpr)
	end 

	if data.count > 1 then     		
		grid:addItem(base.Label.new({text=tostring(data.count), size=22}):pos(40, -40):align(display.CENTER))
	end 
end

function RewardLayer:onEvent(listener)
	self.eventListener = listener 

	return self 
end

function RewardLayer:onEvent_(event)
	if not self.eventListener then return end  

	event.target = self 
	self.eventListener(event)
end

return RewardLayer


