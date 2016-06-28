
--[[
开服活动场景
]]

local OpenActivityLayer = class("OpenActivityLayer", function()
    return display.newNode()
end)

function OpenActivityLayer:ctor()
    self.layer_ = display.newNode():size(960, 640):pos(display.cx, display.cy):zorder(1):align(display.CENTER)
    self.layer_:addTo(self)

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

function OpenActivityLayer:initData()
    self.data = ActivityOpenData:getArray()

    self.sectionIndex = 1       -- 主分区选中
    self.subSectionIndex = 1    -- 子分区选中

    self.subLayers = {}

    self.mainBtns = {}
    self.subBtns = {}

    self.dotData = {} -- 红点数据

    self.completedCount = 0

end

function OpenActivityLayer:initView()

    CommonView.blackLayer2()
    :addTo(self)

    ------------------------------------------------------背景板
    display.newSprite("Carnival_Board.png")
    :addTo(self.layer_)
    :pos(480,350)

    -- 关闭按钮
    CommonButton.close_():addTo(self.layer_):pos(849, 575)
    :onButtonClicked(function()
        self:onEvent_{name="close", isCompleted=self.isCompleted}

        CommonSound.close() -- 音效
    end)


    -- 列表 活动任务
    self.listView_ = base.GridViewOne.new({
        ver = 1,
        viewRect = cc.rect(0, 0, 550, 332),
        itemSize = cc.size(550, 110),
    }):addTo(self.layer_)
    :pos(285, 75)

    self:addSectionButtons()

    self:addTimeWidget()

    self:addFinalWidget()
end

function OpenActivityLayer:onEvent(listener)
    self.eventListener = listener

    return self
end

function OpenActivityLayer:onEvent_(event)
    if not self.eventListener then return end

    event.target = self
    self.eventListener(event)
end

-----------------------------------------------
-- ////////////////////////////////////////////

-- 获取按钮的红点
function OpenActivityLayer:getRedPoint(grid)
    return grid:getItem("redpoint")
end

-- 为按钮添加红点
function OpenActivityLayer:addRedPointForGrid(grid, x, y)
    local redPoint = CommonView.redPoint()
    :pos(x, y)
    -- :hide()

    grid:addItemWithKey("redpoint", redPoint)
end

function OpenActivityLayer:showRedPointForGrid(grid, show)
    self:getRedPoint(grid):setVisible(show)
end

-- ////////////////////////////////////////////
-----------------------------------------------

-- 主分区按钮
function OpenActivityLayer:addSectionButtons()
    local image_ = {
              normal = "Carnival_Normal.png",
              selected = "Carnival_Selected.png",
              disabled = "Carnival_Gray.png"
          }
    for i,v in ipairs(self.data) do
        -- 主分区按钮
        local btn = CommonButton.sidebar_()
        :addTo(self.layer_)

        local normal = display.newSprite("Carnival_Normal.png")
        base.Label.new({text=v.name,size=22,border = false, shadow = 1}):addTo(normal):align(display.CENTER,80,25)
        local selected = display.newSprite("Carnival_Selected.png")
        base.Label.new({text=v.name,size=26,border = false, shadow = 1,color = cc.c3b(255, 0, 0)}):addTo(selected):align(display.CENTER,80,30)
        btn:setNormalImage(normal)
        btn:setSelectedImage(selected)
        btn:addItemWithKey("lock", display.newSprite("Carnival_lock.png"):pos(62, 0))

        table.insert(self.mainBtns, btn)

        -- 子分区
        local subLayer, subBtns = self:createSubSections(v.subSections, i)
        subLayer:addTo(self.layer_)
        :pos(359, 444)
        :hide()

        table.insert(self.subBtns, subBtns)
        table.insert(self.subLayers, subLayer)
    end

    -- 侧边 按钮
    self.btnGroup_ = base.ButtonGroup.new({
        zorder1 = 1,
        zorder2 = 5,
    })
    :addButtons(self.mainBtns)
    :walk(function(index, button)
        button:pos(200, 430 - (index-1) * 60)
        self:addRedPointForGrid(button, 67, 18)
        -- self:addLock(button,68, 10, index, 10)
    end)
    :onEvent(function(event)
        if self:isOpen(event.selected) then
            self:selectedSection(event.selected)
        else
            showToast({text=string.format("第%d天开放", event.selected), time=1,color=cc.c3b(255, 255, 0)})
            event.target:selectedButtonAtIndex_(event.last)
        end

    end)

end

-- 子分区层
function OpenActivityLayer:createSubSections(dataArr, sectionIndex)
    local node = display.newNode()
    local btns = {}
    local image_ = {
              normal = "Carnival_Button_Lignt.png",
              selected = "Carnival_Button.png",
              disabled = "Carnival_Button_Lignt.png"
          }
    for i,v in ipairs(dataArr) do
        local btn = CommonButton.sidebar_yellow1(v.name,{size = 21,image = image_,border = 1})
        :addTo(node)
        :pos((i-1) * 130, 0)

        self:addRedPointForGrid(btn, 55, 24)
        table.insert(btns, btn)
    end

    local btnGrop = base.ButtonGroup.new({
        zorder1 = 1,
        zorder2 = 5,
    })
    :addButtons(btns)
    :walk(function(index, button)
        button:pos((index-1) * 140, -10)
    end)
    :onEvent(function(event)
        CommonSound.click() -- 音效
        self:selectedSubSection(sectionIndex, event.selected)
    end)

    return node, btnGrop
end

-- 添加时间控件
function OpenActivityLayer:addTimeWidget()

    self.sprite = display.newSprite()
    :align(display.CENTER)
    :addTo(self.layer_)
    :pos(721, 520)

    self.timeLabel = base.Label.new({text="", size=18, color=cc.c3b(255, 255, 255), border = false})
    -- :align(display.CENTER)
    :addTo(self.layer_)
    :pos(768, 500)

    self:schedule(function()
        self:updateTimeShow()
    end, 0.2)
end

-- 添加时间控件
function OpenActivityLayer:addFinalWidget()
    local act = transition.sequence({
            cc.ScaleTo:create(0.1,1.2),
            cc.ScaleTo:create(0.1, 1),
            cc.DelayTime:create(1)
        })
    local button = cc.ui.UIPushButton.new({normal = "Carnival_all.png"}, {scale9 = true})
    :addTo(self.layer_)
    :pos(198, 116)
    :onButtonClicked(function()
        self:showFinalLayer()
    end)
    button:zorder(2)
    if not ActivityOpenData:isReceived() then
        button:runAction(cc.RepeatForever:create(act))
    end
end

-- 显示
function OpenActivityLayer:showFinalLayer()
    if self.finalLayer_ then return end
-- print("item id :", ActivityOpenData.awardItem.id)
    local icon = UserData:createItemView(ActivityOpenData.awardItem.id)
    self.finalLayer_ = app:createView("activity.FinalActivityLayer", {
        activityCount = ActivityOpenData:getActivityCount(),
        okActivity = ActivityOpenData:getCompletedCount(),
        awardCount = ActivityOpenData.awardItem.count,
        icon = icon,
        remainingDate = self.date,
        desc = ActivityOpenData:getRule(),
        received = ActivityOpenData:isReceived(),
    })
    :onEvent(function(event)
        if event.name == "close" then
            event.target:removeSelf()
            self.finalLayer_ = nil
        elseif event.name == "reward" then
            self:getFinalReward(event)
        end
    end)
    :addTo(self, 10)
    :updateView()
end

function OpenActivityLayer:getFinalReward(event)
    if ActivityOpenData:isReceived() then
        showToast({text="不可重复领取", time=3})
    else
        local date = self.date
        if date.day >= 1 or date.s < 0 then
            showToast({text="领取条件不足", time=3})
        else
            self:getFinalReward_()
        end
    end

end

function OpenActivityLayer:getFinalReward_()
    NetHandler.request("GetNDayEndReward", {
        onsuccess = function(params)
            if self.finalLayer_ then
                self.finalLayer_.received = ActivityOpenData:isReceived()
                self.finalLayer_:updateView()
            end

            UserData:showReward(params.items)
        end
    }, self)
end

----------------------------------------------------------
-- ///////////////// 只设置显示 无数据操作//////////////////
-- 显示子层
function OpenActivityLayer:showSubLayer(index)
    for i,v in ipairs(self.subLayers) do
        v:setVisible(i == index)
    end
end

-- 显示子层 并显示选中一个按钮
function OpenActivityLayer:showSubLayerAndSelectedIndex(index, btnIndex)
    print("index:", index, btnIndex)
    self:showSubLayer(index)
    local subGrop = self.subBtns[index]
    subGrop:selectedButtonAtIndex_(btnIndex)
end

-- 显示 选中 主分区一个按钮
function OpenActivityLayer:showSelectedSectionIndex(index)
    self.btnGroup_:selectedButtonAtIndex_(index)
end

-- ///////////////// 只设置显示 无数据操作//////////////////
------------------------------------------------------------
------------------------------------------------------------
-- 点击了第index个主分区
function OpenActivityLayer:selectedSection(index)
    self:showSubLayerAndSelectedIndex(index, 1)

    -- 数据处理
    self:selectedSubSection(index, 1)
end

-- 点击了第index个主分区的第subIndex个子分区
function OpenActivityLayer:selectedSubSection(index, subIndex)
    if self.sectionIndex == index and self.subSectionIndex == subIndex then return end
    self.sectionIndex = index
    self.subSectionIndex = subIndex
    self:selectedSubSection_(index, subIndex)
    return self
end

-- 选中
function OpenActivityLayer:selectedSubSection_(index, subIndex)
    local sectionData = self.data[index]
    if sectionData then
        local subData = sectionData.subSections[subIndex]
        if subData then
            local dataList = subData.activities
            self:updateActivity(dataList)
        end
    end
end
------------------------------------------------------------
------------------------------------------------------------

function OpenActivityLayer:updateData()
    ActivityOpenData:updateData()
    self.dotData = ActivityOpenData:getOkIndexes()
    self.completedCount = ActivityOpenData:getCompletedCount()
end


function OpenActivityLayer:updateView()
    print("updateView")
    self:showSelectedSectionIndex(self.sectionIndex)
    self:showSubLayerAndSelectedIndex(self.sectionIndex, self.subSectionIndex)

    local dataList = self:getActivityDataList()
    self:updateActivity(dataList)

    self:updateLock()
end

-- 更新红点显示
function OpenActivityLayer:updateDotView()
    self.btnGroup_:walk(function(i, v)
        local data = self.dotData[i]

        if self:isOpen(i) then
            self:showRedPointForGrid(v, data and #data.oklist > 0)
        else
            self:showRedPointForGrid(v, false)
        end
    end)

    for i,v in ipairs(self.subBtns) do
        local data = self.dotData[i]
        local mainhave = data and #data.oklist > 0 -- 主分区是否含有
        v:walk(function(index, btn)
            local isShow = false
            if mainhave then
                isShow = data.list[index]
            end
            self:showRedPointForGrid(btn, isShow)
        end)
    end
end

function OpenActivityLayer:addLock(grid, x, y,tag,zorder)
    if not self.lock_ then
        local lock_ = display.newSprite("Carnival_lock.png")
        lock_:pos(x, y)
        lock_:addTo(grid)
        lock_:zorder(zorder)
        lock_:setTag(tag)
        lock_:setScale(0.6)
    end
end

function OpenActivityLayer:isOpen(index)
    return index <= ActivityOpenData:getOpenDay()
end

-- 更新按钮锁
function OpenActivityLayer:updateLock()
    local openIndex = ActivityOpenData:getOpenDay()
    self.btnGroup_:walk(function(index, button)
        if index <= openIndex then
            button:getItem("lock"):hide()
        else
            button:getItem("lock"):show()
        end
    end)

    self:updateDotView()
end

-- 更新活动
function OpenActivityLayer:updateActivity(dataList)
    print("updateActivity")
    self:updateActivityData(dataList)
    self:updateListView(dataList)
end

-- 更新活动 数据
function OpenActivityLayer:updateActivityData(dataList)
    -- ActivityUtil.parseActivities(dataList)
    ActivityUtil.sortActivities(dataList)
end

-- 获取当前活动列表
function OpenActivityLayer:getActivityDataList()
    local sectionData = self.data[self.sectionIndex]
    if sectionData then
        local subData = sectionData.subSections[self.subSectionIndex]
        if subData then
            return subData.activities
        end
    end
    return {}
end

-- 更新时间显示
function OpenActivityLayer:updateTimeShow()
    local date = ActivityOpenData:getRemainingDate()

    local timestring = string.format("%02d:%02d:%02d", date.hour, date.min, date.sec)

    if date.day < 8 then
        self.sprite:setTexture(string.format("font5_%d.png", date.day))
    end
    self.timeLabel:setString(timestring)

    self.date = date
end

-- 更新显示具体活动列表
function OpenActivityLayer:updateListView(dataList)
    if not self.listView_ then return end

    self.listView_
    :resetData()
    :addSection({
        count = table.nums(dataList),
        getItem = function(event)
            local index = event.index
            return self:createItemGrid(dataList[index])
        end
    })
    :reload()
end

function OpenActivityLayer:createItemGrid(data)
    local grid = base.Grid.new()
    grid:setBackgroundImage("Carnival_List.png")
    if not data then return grid end
    -- dump(data, "show data")
    local item = nil
    -- 任务描述
    local item = base.Label.new({text=data.desc, size=18})
    grid:addItem(item:pos(-250, 38))

    -- 任务奖励
    local posX = -200
    local addX = 0
    for i,v in ipairs(data.items) do
        addX = (i-1) * 90

        -- 物品图像
        item = UserData:createItemView(v.id, {
            quality = v.quality,
            scale = 0.6,
        })
        grid:addItem(item:pos(posX+addX, -10))

        -- 物品数量
        item = base.Label.new({text=tostring(v.count), size=20})
        :align(display.CENTER_RIGHT)
        grid:addItem(item:pos(posX+addX + 40, -40))
    end

    -- 完成情况
    if data:isCompleted() then
        item = base.Label.new({text="已完成", size=22})
        :align(display.CENTER)
        grid:addItem(item:pos(190, -15))
    elseif data:isOk() then
        item = CommonButton.green1()
        :onButtonClicked(function(event)
            CommonSound.click() -- 音效
            self:completeActivity(data)
        end)

        grid:addItem(item:pos(190, -15))

        grid:addItem(CommonView.animation_btn2():pos(190, -11))
    else
        item = CommonButton.yellow1()
        :onButtonClicked(function(event)
            CommonSound.click() -- 音效
            ActivityUtil.jumpUI(data, self)
        end)

        grid:addItem(item:pos(190, -15))

        -- 进度
        item = base.Label.new({text=data:getProcessString(), size=20})
        :align(display.CENTER_RIGHT)
        grid:addItem(item:pos(210, 25))
    end

    return grid
end

function OpenActivityLayer:completeActivity(data)
    print("完成活动任务:", data.id, data.desc)

    NetHandler.request("FinishActivity", {
        data = {param1=data.id},
        onsuccess = function(params)
            showToast({text="领取成功"})

            local dataList = self:getActivityDataList()
            self:updateActivity(dataList)

            UserData:showReward(params.items)
            self:updateData()
            self:updateDotView()

        end,
        onerror = function()
        end
    }, self)
end

function OpenActivityLayer:onEnter()
    self:updateData()
    self:updateView()
    CommonView.animation_show_out(self.layer_)
end

function OpenActivityLayer:onExit()
    NetHandler.removeTarget(self)
end

return OpenActivityLayer

