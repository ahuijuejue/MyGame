--[[
	翻翻乐活动
]]
local FlipFunLayer = class("FlipFunLayer",function()
	return display.newNode()
end)
local NodeBox = import("app.ui.NodeBox")
local scheduler = require("framework.scheduler")

local payBtn1 = "flip_pay1.png"
local payBtn2 = "flip_pay2.png"
local refreshBtn1 = "flip_btn1.png"
local refreshBtn2 = "flip_btn2.png"
local flipDiamond = "flip_diamond.png"
local flipFace = "flip_face.png"
local flipBack = "flip_back.png"
local stoneBarBg = "Stone_Bar.png"
local stoneImage = "Stone.png"
local rankBanner = "rank_banner.png"
local titleBanner = "board_flip_banner.png"

function FlipFunLayer:ctor()
	self.arr = FlopModel.hopeItems
	self.closeFunc = nil
	self.allFlipPic = {}
	self.showPic = {}
	self:initData()
	self:initView()
	self:createItemsView()
	self:addNodeEventListener(cc.NODE_EVENT,function (event)
		if event.name == "enter" then
			self:onEnter()
		elseif event.name == "exit" then
			self:onExit()
		end
	end)
	CommonView.animation_show_out(self.board)
end

function FlipFunLayer:touchFlip(pos)
	local btn = self.allFlipPic[pos]
	btn:setVisible(false)

	local item = FlopModel.getItems[tostring(pos)]
	local x,y = btn:getPosition()
	local flipPic = display.newSprite(flipFace)
	flipPic:setPosition(x+660,y+248)
	flipPic:setScaleX(-1)
	self.board:addChild(flipPic)

	local x = flipPic:getContentSize().width/2
	local y = flipPic:getContentSize().height/2
	local itemSprite = self:showItem(tostring(item.param1),item.param3)
	itemSprite:setVisible(false)
	itemSprite:setPosition(x,y)
	flipPic:addChild(itemSprite)

	transition.scaleTo(flipPic,{scaleX = 0, time = 0.1, onComplete = function ()
		itemSprite:setVisible(true)
		transition.scaleTo(flipPic,{scaleX = 1, time = 0.1})
	end})

	table.insert(self.showPic,flipPic)
end

function FlipFunLayer:autoFlip()
	for i,v in ipairs(FlopModel.leftPos) do
		local pos = tonumber(v)
		self:touchFlip(pos)
	end
end

function FlipFunLayer:initData()
	self.rankRewardData = FlopModel.rankRewardData
	self.rankData       = FlopModel.rankData
end

function FlipFunLayer:initView()
	-- 灰色背景
	CommonView.blackLayer2()
	:addTo(self)

	--背景板
	self.board = display.newSprite(FlopModel.bgImage)
	:addTo(self)
	:pos(display.cx-40,display.cy+20)

	display.newSprite(titleBanner):addTo(self.board):pos(400, 547)

	-- 排行奖励
	self.listView1 = base.ListView.new({
        viewRect = cc.rect(0, 0, 265, 210),
        itemSize = cc.size(265, 70),
        })
    :addTo(self.board)
    :pos(25, 183)

	-- 排行
	self.listView2 = base.ListView.new({
        viewRect = cc.rect(0, 0, 265, 110),
        itemSize = cc.size(265, 35),
        })
    :addTo(self.board)
    :pos(25, 46)

	-- User排名 次数
    self.rankNum = createOutlineLabel({text = "", size = 28})
    :addTo(self.board)
    :pos(120, 30)

    self.flopTimes = createOutlineLabel({text = "", size = 28})
    :addTo(self.board)
    :pos(255, 30)

	--关闭
	self.closeBtn = CommonButton.close():addTo(self.board):pos(935,525)
	:scale(0.8)
	:onButtonClicked(function()
		CommonSound.close()
		if self.closeFunc then
			self.closeFunc()
		end
	end)

	--添加时间控件
	self:addTimeWidget()

	--充值按钮
	cc.ui.UIPushButton.new({normal = payBtn1,pressed = payBtn2}, options)
	:pos(660,33)
	:addTo(self.board)
	:onButtonClicked(function ()
		app:pushScene("RechargeScene")
	end)

	createOutlineLabel({text = "活动期间每充值"..FlopModel.price.."元,即可获得一次翻牌机会",size = 17})
	:addTo(self.board)
	:pos(655,388)

	self:createNodeBox()
	self:updateNode()
	self:createRefreshBtn()
	self:createAutoBtn()
	self:createProgress()
end

--显示必将翻出商品
function FlipFunLayer:createItemsView()
	local posX = 0-(#self.arr - 1)*50+165
	local addX = 65
    for j=1,#self.arr do
        self:showItem(tostring(self.arr[j].param1), tonumber(self.arr[j].param3))
        :addTo(self.board)
        :pos(posX+(j-1)*addX+610,87)
        :scale(0.6)
        :zorder(10)
    end
end

function FlipFunLayer:createRefreshBtn()
	local refreshBtn = cc.ui.UIPushButton.new({normal = refreshBtn1, pressed = refreshBtn2})
	:onButtonClicked(function ()
		if #FlopModel.poses > 0 then
			NetHandler.gameRequest("FreshOpenCard")
		else
			showToast({text = "无法刷新",color = display.COLOR_RED, size = 28})
		end

	end)
	refreshBtn:setPosition(500,33)
	self.board:addChild(refreshBtn)

	local priceLabel = createOutlineLabel({text = "刷新：100", size = 24})
	priceLabel:setPosition(-22,0)
	refreshBtn:addChild(priceLabel)

	local iconSprite = display.newSprite(flipDiamond)
	iconSprite:setPosition(60,0)
	refreshBtn:addChild(iconSprite)
end

--自动翻牌按钮
function FlipFunLayer:createAutoBtn()
	local autoBtn = cc.ui.UIPushButton.new({normal = refreshBtn1, pressed = refreshBtn2})
	:onButtonClicked(function ()
		if FlopModel:getLeftTimes() <= 0 then
			showToast({text = "次数不足",color = display.COLOR_RED, size = 28})
		elseif #FlopModel:getLeftPos() <= 0 then
			showToast({text = "牌全部已翻开，请刷新",color = display.COLOR_RED, size = 28})
		else
			NetHandler.gameRequest("OpenCardAct",{param1 = -1})
		end
    end)
    autoBtn:setPosition(820,33)
	self.board:addChild(autoBtn)

	self.countLabel = createOutlineLabel({text = "", size = 24})
	autoBtn:addChild(self.countLabel)
end

--充值进度
function FlipFunLayer:createProgress()
    local bgSprite = display.newSprite(stoneBarBg)
    bgSprite:setPosition(660,412)
    self.board:addChild(bgSprite)

    local offsetX = bgSprite:getContentSize().width/2
    local offsetY = bgSprite:getContentSize().height/2

    self.costProgress = cc.ProgressTimer:create(display.newSprite(stoneImage))
    self.costProgress:setType(1)
    self.costProgress:setPosition(offsetX,offsetY)
    self.costProgress:setMidpoint(cc.p(0,1))
    self.costProgress:setBarChangeRate(cc.p(1, 0))
    bgSprite:addChild(self.costProgress,1)

	local param = {text = "" ,color = display.COLOR_WHITE, size = 22,x = offsetX, y = offsetY}
    self.costLabel = createOutlineLabel(param)
    bgSprite:addChild(self.costLabel,2)
end

function FlipFunLayer:createNodeBox()
	for i=1,10 do
		local flipPic = cc.ui.UIPushButton.new({normal = flipBack})
		--牌特效
    	local flipAnimation = CommonView.animation_flip()
    	:scale(0.25)
    	:addTo(flipPic)

		flipPic:onButtonClicked(function ()
			if FlopModel:getLeftTimes() > 0 then
				NetHandler.gameRequest("OpenCardAct",{param1 = i})
			else
				showToast({text = "次数不足",color = display.COLOR_RED, size = 28})
			end
		end)
		table.insert(self.allFlipPic, flipPic)
	end

	local nodeBox =  NodeBox.new()
	nodeBox:setCellSize(cc.size(89,125))
	nodeBox:setPosition(660,248)
	nodeBox:setSpace(15,5)
	nodeBox:setUnit(5)
	nodeBox:addElement(self.allFlipPic)
	self.board:addChild(nodeBox,10)
end

--时间控件
function FlipFunLayer:addTimeWidget()
	self.sprite = display.newSprite()
    :align(display.CENTER)
    :addTo(self.board)
    :pos(735, 470)

    self.timeLabel = base.Label.new({text="", size=18, color=cc.c3b(255, 255, 255), border = false})
    :addTo(self.board)
    :pos(805, 447)
end

-- 更新时间显示
function FlipFunLayer:updateTimeShow()
	self.leftTime = self.leftTime - 1
	if self.leftTime <= 0 then
		self.closeFunc()
	end
	local date = convertSecToDate(self.leftTime)
    local timestring = string.format("%02d:%02d:%02d", date.hour, date.min, date.sec)
    if date.day < 8 then
        self.sprite:setTexture(string.format("font5_%d.png", date.day))
    end
    self.timeLabel:setString(timestring)
end

--显示商品列表
function FlipFunLayer:showItem(itemId, count)
    local grid = UserData:createItemView(itemId, {scale=0.7})

    local label = base.Label.new({
        text = tostring(count),
        size = 18,
        color = CommonView.color_white(),
    })
    :align(display.BOTTOM_RIGHT)
    :pos(50, -50)

    grid:addItem(label)

    return grid
end

function FlipFunLayer:updateNode()
	local poses = FlopModel.poses
	local items = FlopModel.getItems
	for i,v in ipairs(poses) do
		local pos = tonumber(v)
		local item = items[v]
		local btn = self.allFlipPic[pos]
		btn:setVisible(false)

		local x,y = btn:getPosition()
		local flipPic = display.newSprite(flipFace)
		flipPic:setPosition(x+660,y+248)
		self.board:addChild(flipPic)

		local x = flipPic:getContentSize().width/2
		local y = flipPic:getContentSize().height/2
		local itemSprite = self:showItem(tostring(item.param1),item.param3)
		itemSprite:setPosition(x,y)
		flipPic:addChild(itemSprite)

		table.insert(self.showPic,flipPic)
	end
end

function FlipFunLayer:resetNode()
	for i,v in ipairs(self.allFlipPic) do
		v:setVisible(true)
	end
	for i,v in ipairs(self.showPic) do
		v:removeFromParent(true)
		v = nil
	end
	self.showPic = {}
end

function FlipFunLayer:updateData()

end

function FlipFunLayer:updateRankRewardList()
	self.listView1
	:removeAllItems()
	:addItems( #self.rankRewardData , function(event)
		local index = event.index
		local data = self.rankRewardData[index]
		local grid = base.Grid.new()
			  :setBackgroundImage(rankBanner)

		return grid
	end)
	:reload()
end

function FlipFunLayer:updateRankList()
	self.listView2
	:removeAllItems()
	:addItems(#self.rankData, function(evnet)
		local index = event.index
		local data = self.rankData[index]
		local grid = base.Grid.new()
		return grid
	end)
	:reload()
end

function FlipFunLayer:updateUserRankView()
    self.rankNum:setString(FlopModel.rankNum)
    self.flopTimes:setString(FlopModel.flopTimes)
end

function FlipFunLayer:updateView()
	self:updateRankRewardList()
	self:updateRankList()
	self:updateUserRankView()

	local str = string.format("自动翻牌：%d",FlopModel:getLeftTimes())
	self.countLabel:setString(str)

	str = string.format("还需%d",FlopModel:getNeedMoney())
	self.costLabel:setString(str)

	self.costProgress:setPercentage(FlopModel:getNowMoney())
end

function FlipFunLayer:startTimer()
    if self.timeHandle then
        return
    end
    self.timeHandle = scheduler.scheduleGlobal(handler(self,self.updateTimeShow),1)
end

function FlipFunLayer:stopTimer()
    if self.timeHandle then
        scheduler.unscheduleGlobal(self.timeHandle)
        self.timeHandle = nil
    end
end

function FlipFunLayer:onEnter()
	self.leftTime = FlopModel.closeTime - UserData:getServerSecond()
	self:updateTimeShow()
	self:startTimer()
	self:updateData()
	self:updateView()
end

function FlipFunLayer:onExit()
	self:stopTimer()
end

return FlipFunLayer