--[[
	老虎机活动 31001  购买 31002
--]]
local TigerLayer = class("TigerLayer",function()
	return display.newNode()
end)
local scheduler = require("framework.scheduler")
local btnFive = "Pay_Five.png"
local btnFiveSelect = "Pay_Five_Select.png"
local btnOne = "Pay_One.png"
local btnOneSelect = "Pay_One_Select.png"
local discOne = "DiscOne.png"
local discTwo = "DiscTwo.png"
local lightRing = "LightRing.png"
local rankBanner = "rank_banner.png"
local titleBanner = "Tiger_Board_banner.png"

function TigerLayer:ctor()
    self.closeFunc = nil
    self.lightRingSprite = {}
    self.movePos = 1
    self.endPos = 1
    self.blinkNum = 0
    self:createAllPos()
    self:initData()
    self:initView()
    self:addNodeEventListener(cc.NODE_EVENT,function (event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)
    CommonView.animation_show_out(self.board)
end

function TigerLayer:initData()
    self.rankRewardData = SlotModel.rankRewardData
    self.rankData = SlotModel.rankData
end

function TigerLayer:initView()
	-- 灰层背景
	CommonView.blackLayer2()
    :addTo(self)

    --底板
    self.board = display.newSprite(SlotModel.bgImage)
    :addTo(self)
    :pos(display.cx,display.cy+20)

    display.newSprite(titleBanner):addTo(self.board):pos(400, 547)

    --排行奖励
    self.listView1 = base.ListView.new({
        viewRect = cc.rect(0, 0, 265, 210),
        itemSize = cc.size(265, 70),
        })
    :addTo(self.board)
    :pos(25, 183)

    --购买次数排行
    self.listView2 = base.ListView.new({
        viewRect = cc.rect(0, 0, 265, 110),
        itemSize = cc.size(265, 35),
        })
    :addTo(self.board)
    :pos(25, 46)

    -- User排名 次数
    self.rankNum = createOutlineLabel({text = "", size = 30})
    :addTo(self.board)
    :pos(120, 30)

    self.slotTimes = createOutlineLabel({text = "", size = 30})
    :addTo(self.board)
    :pos(255, 30)

    --光圈特效
    self.lightAnimation = CommonView.animation_tiger_light()
    :zorder(11)
    :scale(1.2)
    :pos(362,372)
    :addTo(self.board)

    -- 关闭按钮
	self.closeBtn = CommonButton.close():addTo(self.board):pos(862,525)
	:scale(0.8)
	:onButtonClicked(function()
		CommonSound.close()
        if self.closeFunc then
            self.closeFunc()
        end
	end)

    --购买五次按钮
    self.btnFive = cc.ui.UIPushButton.new({normal = btnFive,pressed = btnFiveSelect})
    :addTo(self.board)
    :pos(695,75)
    :onButtonClicked(function ()
        self.lightAnimation:setVisible(false)
        if UserData.diamond < SlotModel.price2 then
            showToast({text="钻石不足"})
        else
            showLoading()
            NetHandler.gameRequest("OnearmBundit",{param1  = 2})
        end
    end)

    local param = {text = SlotModel.price2 ,color = display.COLOR_WHITE, size = 20,x = -72, y = -18}
    local priceLabel = createOutlineLabel(param)
    self.btnFive:addChild(priceLabel)

    --光圈
    self.lightRing = display.newSprite(lightRing)
    :addTo(self.board)
    :pos(359,372)
    self.lightRing:setVisible(true)

    for i=1,5 do
        local fiveImage = display.newSprite(lightRing)
        fiveImage:setVisible(false)
        self.board:addChild(fiveImage)
        table.insert(self.lightRingSprite, fiveImage)
    end
    self:createOnceSoltBtn()
    self:createItemsView()
    self:addTimeWidget()
end

function TigerLayer:addTimeWidget()
    self.sprite = display.newSprite()
    :align(display.CENTER)
    :addTo(self.board)
    :pos(640, 470)

    self.timeLabel = base.Label.new({text="", size=18, color=cc.c3b(255, 255, 255), border = false})
    :addTo(self.board)
    :pos(730, 447)
end

-- 更新时间显示
function TigerLayer:updateTimeShow()
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

function TigerLayer:showItem(itemId, count)
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

--显示商品
function TigerLayer:createItemsView()
    for j=1,#(SlotModel.itemsData) do
        self:showItem(tostring(SlotModel.itemsData[j].param1), tonumber(SlotModel.itemsData[j].param3))
        :addTo(self.board)
        :pos(self:getPos(j))
        :zorder(10)
    end
end

function TigerLayer:createOnceSoltBtn()
    self.btnOne = cc.ui.UIPushButton.new({normal = btnOne,pressed = btnOneSelect}, options)
    :addTo(self.board)
    :pos(440,75)
    :onButtonClicked(function ()
        self.lightAnimation:setVisible(false)
        if UserData.diamond < SlotModel:getCost(1) then
            showToast({text="钻石不足"})
        else
            showLoading()
            NetHandler.gameRequest("OnearmBundit",{param1  = 1})
        end
    end)

    local param = {text = "" ,color = display.COLOR_WHITE, size = 20,x = -72, y = -18}
    self.priceLabel = createOutlineLabel(param)
    self.btnOne:addChild(self.priceLabel)
end

function TigerLayer:doSlot()
    self.movePos = 1
    self.num = math.random(4,6)

    local pos = tonumber(SlotModel.pos[1])
    if pos < 7 then
        self.endPos = (self.num+1) * 12 + pos
    else
        self.endPos = self.num * 12 + pos
    end

    self.lightRing:setVisible(true)
    self.closeBtn:setButtonEnabled(false)
    self.btnOne:setButtonEnabled(false)
    self.btnFive:setButtonEnabled(false)
    self.lightRing:setPosition(359,372)
    for i,v in ipairs(self.lightRingSprite) do
        v:setVisible(false)
    end
    self:playLightRing()
end

function TigerLayer:doSlot2()
    self.blinkNum = 0
    self.lightRing:setVisible(false)
    self.closeBtn:setButtonEnabled(false)
    self.btnFive:setButtonEnabled(false)
    self.btnOne:setButtonEnabled(false)
    for i,v in ipairs(self.lightRingSprite) do
        v:setVisible(true)
    end
    self.numFive = math.random(15,17)
    self:createFive()
end

function TigerLayer:createFive()
    --生成
    local N = 12
    local array = {0,0,0,0,0}

    for i = 1 , 5 do
        newrandomseed()
        local x = math.random(1,12)
        function isExist(value)
            for i,v in ipairs(array) do
                if v == value then
                    return true
                end
            end
            return false
        end
        while isExist(x)  do
            newrandomseed()
            x = math.random(1,12)
        end
        array[i] = x
    end
    -- 购买五次定时器
    scheduler.performWithDelayGlobal(function ()
        self.blinkNum = self.blinkNum + 1
        for i,v in ipairs(self.lightRingSprite) do
            v:setPosition(self:getPos(array[i]))
        end
        if self.blinkNum > self.numFive then
            self:stopFivePos()
            UserData:showReward(UserData:parseItems(SlotModel.itemsGet))
        else
            self:createFive()
        end
    end,0.08)
end

--固定五个位置
function TigerLayer:stopFivePos()
    for i,v in ipairs(SlotModel.pos) do
        self.lightRingSprite[i]:setPosition(self:getPos(tonumber(v)))
    end
    self.btnFive:setButtonEnabled(true)
    self.btnOne:setButtonEnabled(true)
    self.closeBtn:setButtonEnabled(true)
end

function TigerLayer:getPos(pos)
    local x = self.fivePos[pos][1]
    local y = self.fivePos[pos][2]

    return x,y
end

function TigerLayer:createAllPos()
    self.fivePos = {}

    local x = 359
    local y = 372

    for x=359,771,103 do
        table.insert(self.fivePos,{x,y})
    end
    x = 771
    for y=268,100,-103 do
        table.insert(self.fivePos,{x,y})
    end
    y = 165
    for x=668,359,-103 do
       table.insert(self.fivePos,{x,y})
    end
    x = 359
    y = 268
    table.insert(self.fivePos,{x,y})
end

function TigerLayer:playLightRing()
    local x = self.lightRing:getPositionX()
    local y = self.lightRing:getPositionY()
    local time = 0.01
    if self.movePos < 13 then
        time = 0.13 - math.pow(self.movePos,2) * 0.0008
    elseif self.movePos >= self.endPos - 6 then
        local pos = 6 - self.endPos + self.movePos
        time = 0.05 + math.pow(pos,2) * 0.03
    end

    local pos = math.mod(self.movePos,12)
    if pos < 5 and pos > 0 then
        x = x + 103
    elseif pos < 7 and pos >= 5 then
        y = y - 103
    elseif pos < 11 and pos >= 7 then
        x = x - 103
    else
        y = y + 103
    end

    -- 购买一次定时器
    scheduler.performWithDelayGlobal(function ()
        self.movePos = self.movePos+1
        self.lightRing:setPosition(x,y)
        if self.movePos >= self.endPos then
            self.btnOne:setButtonEnabled(true)
            self.btnFive:setButtonEnabled(true)
            self.closeBtn:setButtonEnabled(true)
            scheduler.performWithDelayGlobal(function ()
                UserData:showReward(UserData:parseItems(SlotModel.itemsGet))
            end, 1)

        else
            self:playLightRing()
        end
    end,time)
end

function TigerLayer:startTimer()
    if self.timeHandle then
        return
    end
    self.timeHandle = scheduler.scheduleGlobal(handler(self,self.updateTimeShow),1)
end

function TigerLayer:stopTimer()
    if self.timeHandle then
        scheduler.unscheduleGlobal(self.timeHandle)
        self.timeHandle = nil
    end
end

function TigerLayer:updateData()
end

function TigerLayer:updateRankRewardList()
    self.listView1
    :removeAllItems()
    :addItems( #self.rankRewardData , function(event)
        local index = event.index
        local data = self.rankRewardData[index]
        local grid = base.Grid.new()
              :setBackgroundImage(rankBanner)

        local posX = 5
        local addX = 50
        local posY = 7
        display.newSprite(string.format("font5_%d.png", v.rankNum)):addTo(grid):pos(10, posY):scale(0.8)

        for i,v in ipairs(data.rewardItems) do

            local item = UserData:createItemView(v.itemId, {scale = 0.7})
            item:addTo(grid):pos(posX+addX*(i-1), posY)
            item:addChild(base.Label.new({text = v.itemNum, size = 18}))
        end

        return grid
    end)
    :reload()
end

function TigerLayer:updateRankList()
    self.listView2
    :removeAllItems()
    :addItems( #self.rankData , function(event)
        local index = event.index
        local data = self.rankData[index]
        local grid = base.Grid.new()

        local posY = 7
        display.newSprite(string.format("font4_%d.png", v.rankNum)):addTo(grid):pos(10, posY):scale(0.5)
        base.Label.new({text = data.name, size = 24}):addTo(grid):pos(30, posY)
        base.Label.new({text = data.slotTimes, size = 24}):addTo(grid):pos(50, posY)

        return grid
    end)
    :reload()
end

function TigerLayer:updateUserRankView()
    self.rankNum:setString(SlotModel.rankNum)
    self.slotTimes:setString(SlotModel.slotTimes)
end

function TigerLayer:updateView()
    local str = tostring(SlotModel:getCost(1))
    self.priceLabel:setString(str)

    self:updateRankRewardList()
    self:updateRankList()
    self:updateUserRankView()
end

function TigerLayer:onEnter()
    self.leftTime = SlotModel.closeTime - UserData:getServerSecond()
    self:updateTimeShow()
    self:updateData()
    self:updateView()
    self:startTimer()
end

function TigerLayer:onExit()
    self:stopTimer()
end

return TigerLayer
