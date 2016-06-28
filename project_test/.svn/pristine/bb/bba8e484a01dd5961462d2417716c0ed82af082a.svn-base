--[[
封印场景
]]
local TailsSealScene = class("TailsSealScene", base.Scene)

function TailsSealScene:initData()
    self.data_ = {}
    self.addSeal_ = 0
end

function TailsSealScene:initView()
    self:autoCleanImage()
    -- 背景
    display.newSprite("Tails_Background_2.jpg")
    :addTo(self)
    :center()


    -- 按钮层
    app:createView("widget.MenuLayer", {wealth="tree", menu=false}):addTo(self)
    :onBack(function(layer)
        app:popScene()
    end)

-- 主层

-----------------------------------------------
-- 背景框
    display.newSprite("Idolum_Item_Banner.png")
    :addTo(self.layer_)
    :pos(480, 125)

-----------------------------------------------

    -- 封印等级 显示
    display.newSprite("Idolum_Level.png"):addTo(self.layer_)
    :pos(180, 330)

    display.newSprite("Idolum_Slip2.png"):addTo(self.layer_)
    :pos(90, 290)
    :align(display.LEFT_CENTER)

    self.layer1_ = display.newNode():addTo(self.layer_):zorder(2) -- 封印等级 显示
    self.layer2_ = display.newNode():addTo(self.layer_):zorder(2):hide() -- 封印等级 增加经验后的显示
    self.star_ = {}
    for i=1,4 do
        display.newSprite("Idolum_Star.png"):addTo(self.layer_):pos(260+i*41, 330):scale(0.7)
        local star = display.newSprite("Idolum_Star_Light.png"):addTo(self.layer1_):pos(260+i*41, 330):hide():scale(0.7)
        table.insert(self.star_, star)
    end

    self.slider_ = UserData:slider("Idolum_Exp2.png")
    :addTo(self.layer1_)
    :pos(90, 290)
    :align(display.LEFT_CENTER)


    self.labelLv_ = base.Label.new({
        text="封印0层",
        color=cc.c3b(250,250,250),
        size=22,
    }):addTo(self.layer1_)
    :align(display.CENTER)
    :pos(180, 330)


--------------------------------------
-- 列表
    self.listView_ = base.TableView.new({
        rows = 2,
        viewRect = cc.rect(0, 0, 665, 260),
        direction = "horizontal",
        itemSize = cc.size(130, 130),
        page = true,
    })
    :addTo(self.layer_)
    :setBounceable(false)
    :pos(80, 5)
    :zorder(2)
    :onTouch(function(event)
        if event.name == "selected" then
            local index = event.index
            print("index:", index)
            if index then
                CommonSound.click() -- 音效

                self:selectedIndex(index, event.item)
            end
        end
    end)


-------------------------------------
-- 封印
    -- 金币封印
    self.btnGoldSeal_ = CommonButton.yellow2("封印")
    :addTo(self.layer_):pos(830, 55)
    :onButtonClicked(function(event)
        CommonSound.click() -- 音效
        print("金币 封印魔像")

        self:onButtonGoldSeal()
    end)
    :setButtonEnabled(false)

    display.newSprite("Gold.png"):addTo(self.layer_)
    :pos(775, 110)

    self.lbCostGold_ = base.Label.new({text="0", size=22}):addTo(self.layer_)
    :pos(805, 110)

    -- 宝石封印
    self.gemsLayer_ = display.newNode():addTo(self.layer_):hide()

    self.btnGemsSeal_ = CommonButton.yellow2("封印")
    :addTo(self.gemsLayer_):pos(830, 170)
    :onButtonClicked(function(event)
        CommonSound.click() -- 音效
        print("宝石 封印魔像")
        if UserData.diamond >= 100 then
            UserData:addDiamond(-self:getCostGems())
            GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
            SealData:addSealExp(1000)

            self:resetAddItems()
            self:updateListView()
            self:updateCostView()
            self:updateButtonState()
            self:updateSealView()
            self:updateSealExView()
            self:updateAttributeData()
            self:updateAttributeView()
        else
            GemsAlert:show()
        end

    end)

    display.newSprite("Diamond.png"):addTo(self.gemsLayer_)
    :pos(775, 225)

    self.lbCostGems_ = base.Label.new({text=string.format("%d", self:getCostGems()), size=22}):addTo(self.gemsLayer_)
    :pos(805, 225)

    ------------------------------------------------
    -- 进度label
    self.sliderLabel_ = base.Label.new({text="0/0", size=22})
    :align(display.CENTER)
    :addTo(self.layer_)
    :pos(800, 290)
    :zorder(5)

    -- 封印属性加成
    self:initAttributeView()

end

-- 封印属性加成
function TailsSealScene:initAttributeView()
    display.newSprite("Seal_Player_Attr.png")
    :addTo(self.layer_)
    :pos(730, 425)

    base.Label.new({text="战队属性加成", size=22, color=cc.c3b(249,255,22)})
    :addTo(self.layer_)
    :pos(570, 510)

    self.openAttriLabel = base.Label.new({text="10层开启闪避属性加成", size=20, color=cc.c3b(227,115,28)})
    :addTo(self.layer_)
    :pos(730, 330)
    :align(display.CENTER)

    self.attriListView = base.GridView.new({
        rows = 1,
        viewRect = cc.rect(0, 0, 300, 150),
        itemSize = cc.size(300, 25),
    }):addTo(self.layer_)
    :setBounceable(false)
    :pos(570, 345)
    :zorder(2)

end

function TailsSealScene:onButtonGoldSeal(callback)
    local itemsStr = ""
    for i,v in ipairs(self.willCost) do
        if v > 0 then
            local item = self.items_[i]
            if type(item.uniqueId) == "table" then
                local tablelen = #item.uniqueId + 1
                for i2=1,v do
                    itemsStr = itemsStr..tostring(item.uniqueId[tablelen-i2]).."_1,"
                end
            else
                itemsStr = itemsStr..tostring(item.uniqueId).."_" ..tostring(v) .. ","
            end
        end
    end

    NetHandler.request("Seal", {
        data = {param1=itemsStr},
        onsuccess = function(params)
            self:resetAddItems()
            self:updateListView()
            self:updateCostView()
            self:updateButtonState()
            self:updateSealView()
            self:updateSealExView()
            showToast({text="封印成功"})
            UserData:showReward(params.items)
            self:updateAttributeData()
            self:updateAttributeView()

            if callback then
                callback({result=true})
            end
        end,
        onerror = function()
            self.btnGoldSeal_:setButtonEnabled(true)

            if callback then
                callback({result=false})
            end
        end
    }, self)
    self.btnGoldSeal_:setButtonEnabled(false)
end

------------------------------
------------ 封印物品
-- 当前选中可获得经验
function TailsSealScene:getSealExp()
    local addseal = 0
    for i,v in ipairs(self.willCost) do
        if v > 0 then
            local data = self.items_[i]
            addseal = addseal + data.seal * v
        end
    end
    return addseal
end
-- 是否可以再增加物品
function TailsSealScene:canAddItem()
    return not SealData:isSealMaxAddExp(self:getSealExp())
end

function TailsSealScene:resetAddItems()
    for i,v in ipairs(self.willCost) do
        if v > 0 then
            self.willCost[i] = 0
        end
    end
end

--
function TailsSealScene:updateItemView(item, count, countMax)
    if count > 0 then
        item:showSubButton(true)
        item:setCount(count, countMax)
    else
        item:showSubButton(false)
        item:setCount(count, countMax)
    end
end

function TailsSealScene:selectedIndex(index, target)
    if self:canAddItem() then
        local data = self.items_[index]
        if self.willCost[index] < data.count then
            self.willCost[index] = self.willCost[index] + 1

            self:showAddExp(data.seal)

            self:updateItemView(target, self.willCost[index], data.count)
            self:updateCostView()
            self:updateButtonState()
            self:updateSealView()
            self:updateSealExView()
            self:updateAttributeData()
            self:updateAttributeView()
        end
    else
        showToast({text="已达到当前最大封印等级"})
    end
end

function TailsSealScene:reduceIndex(index, target)
    if self.willCost[index] > 0 then
        local data = self.items_[index]
        self.willCost[index] = self.willCost[index] - 1
        self:updateItemView(target, self.willCost[index], data.count)
        self:updateCostView()
        self:updateButtonState()
        self:updateSealView()
        self:updateSealExView()
        self:updateAttributeData()
        self:updateAttributeView()
    end
end


-----------------------------------------
---- 消耗 金钱

-- 当前选中 需要金币
function TailsSealScene:getCostGold()
    local exp = self:getSealExp()
    print("exp:", exp)
    return SealData:getSealCost(exp)
end

-- 需要 宝石
function TailsSealScene:getCostGems()
    return 100
end

function TailsSealScene:updateCostView()
    local gold = self:getCostGold()
    self.lbCostGold_:setString(checknumber(gold))
    local color
    if gold > UserData.gold then -- 金币不足
        color = cc.c3b(250, 30, 0)
    else
        color = cc.c3b(255, 255, 255)
    end
    self.lbCostGold_:setColor(color)
end

---------------------------------------
-- 刷新 封印按钮 状态
function TailsSealScene:updateButtonState()
    if SealData:isSealMax() then            -- 封印达到当前最高级
        self.btnGoldSeal_:setButtonEnabled(false)
        self.btnGemsSeal_:setButtonEnabled(false)
    else
        if self:getSealExp() > 0 then
            self.btnGoldSeal_:setButtonEnabled(true)
        else
            self.btnGoldSeal_:setButtonEnabled(false)
        end
        self.btnGemsSeal_:setButtonEnabled(true)
    end
end

--------------------------------------------
-- 封印 信息
-- 刷新封印显示
function TailsSealScene:updateSealView()
    local sealInfo = SealData:getSealInfo()
    for i,v in ipairs(self.star_) do
        if i > sealInfo.star then
            v:hide()
        else
            v:show()
        end
    end
    self.slider_:setPercentage(math.min(sealInfo.progress * 100, 100))
    self:updateProcessLabel(sealInfo.exp, sealInfo.expMax)
    self.labelLv_:setString(string.format("封印%d层", sealInfo.lv))


    return self
end
-- 刷新封印后 的显示
function TailsSealScene:updateSealExView()
    local willAdd = self:getSealExp()
    if willAdd > 0 then
        local sealInfo = SealData:getSealInfo_(SealData.totalExp + willAdd)
        self.labelLv_:setString(string.format("封印%d层", sealInfo.lv))
        self.slider_:setPercentage(math.min(sealInfo.progress * 100, 100))
        self:updateProcessLabel(sealInfo.exp, sealInfo.expMax)
        for i,v in ipairs(self.star_) do
            if i > sealInfo.star then
                v:hide()
            else
                v:show()
            end
        end
    end

    return self
end

-- 显示封印数值
function TailsSealScene:updateProcessLabel(value, valueMax)
    local str = string.format("%d/%d", value, valueMax)
    self.sliderLabel_:setString(str)
end

function TailsSealScene:showAddExp(value)
    local str = string.format("+ %d", value)
    local label = base.Label.new({text=str, size=20, color=cc.c3b(0,255,0)})
    :align(display.CENTER)
    :addTo(self.layer_)
    :pos(800, 290)
    :zorder(5)

    local sequence = transition.sequence({
        cc.MoveBy:create(0.5, cc.p(0, 50)),
        cc.RemoveSelf:create()
    })

    label:runAction(sequence)
end

---------------------------------
-- 刷新

function TailsSealScene:updateData()
    self.willCost = {}
    self:updateAttributeData()
end

function TailsSealScene:updateAttributeData()
    local willAdd = self:getSealExp()
    local sealInfo = SealData:getSealInfo_(SealData.totalExp)
    local willSealInfo = SealData:getSealInfo_(SealData.totalExp + willAdd)

    self.sealInfoDict = SealData:getAttributeInfoDict(sealInfo.lv)
    self.sealInfoWillDict = SealData:getAttributeInfoDict(willSealInfo.lv)
    self.nextInfo = SealData:getAttributeNextInfo(willSealInfo.lv)

end

function TailsSealScene:updateView()
    self:updateListView()
    self:updateSealView()
    self:updateButtonState()
    self:updateAttributeView()
end

function TailsSealScene:updateListView()
    local items = SealData:getCanSealItems()

    if self.isGuide then
        table.insert(items, 1, self.guideData.item)
    end

    self.items_ = items
    self.listView_
    :resetData()
    :addItems(#items, function(event)
        local index = event.index
        local data = items[index]
        self.willCost[index] = self.willCost[index] or 0
        local costValue = self.willCost[index]

        local borderName = UserData:getItemBorder(data)

        local grid = event.target:getFreeItem(borderName)
        if not grid then
            grid = app:createView("tails.SealGrid", {
                flag = borderName,
            })
        end

        grid:setIcon(UserData:getItemIcon(data))
        grid:setBorder(borderName)
        grid:setItemFlag(UserData:getItemFlag(data))

        grid:setCount(costValue, data.count)
        grid:onSubButtonEvent(function()
            self:reduceIndex(index, grid)
        end)

        if costValue > 0 then
            grid:showSubButton(true)
        else
            grid:showSubButton(false)
        end

        return grid
    end)
    :reload()
end

function TailsSealScene:updateAttributeView()
    if self.nextInfo then
        local typeStr = GlobalData:convertHeroType(self.nextInfo.type)
        local str = string.format("%d层开启%s +%d", self.nextInfo.level, typeStr.desc, self.nextInfo.value)

        self.openAttriLabel:setString(str)
    else
        self.openAttriLabel:setString("")
    end

    local keys = table.keys(self.sealInfoWillDict)

    self.attriListView
    :removeAllItems()
    :addItems(#keys, function(event)
        local index = event.index
        local key = keys[index]
        local curData = self.sealInfoDict[key]
        local willData = self.sealInfoWillDict[key]
        local descStr = GlobalData:convertHeroType(key).desc

        local grid = base.Grid.new()

        local descColor = cc.c3b(250,250,250)
        if not curData then
            descColor = cc.c3b(0,250,0)
        end
        grid:addItem(base.Label.new({text=descStr, size=20, color=descColor}):pos(-130, 0)) -- 属性描述

        local valueColor = cc.c3b(250,250,250)
        if not curData or curData < willData then
            valueColor = cc.c3b(0,250,0)
        end
        grid:addItem(base.Label.new({text=string.format("+%d", willData), size=20, color=valueColor}):pos(0, 0)) -- 增加属性值

        return grid
    end)
    :reload()
end

-------------------------------------------------------
-------------------------------------------------------
-- 新手引导

function TailsSealScene:onGuide()
    if UserData:getUserLevel() < OpenLvData.tails.openLv then return end

    if GuideData:isNotCompleted("Tails1") then
        self.isGuide = true
        local itemId = OpenLvData.tails.desc
        local guideItem = ItemData:createItem(itemId, itemId, 1)
        local guideSealExp = guideItem.seal

        self.guideData = {
            item = guideItem,
            exp = guideSealExp,
        }

        self:updateListView()

        local item = self.listView_:getItemAtIndex(1)
        local point = convertPosition(item, self)
        UserData:showGuideLayer({
            text=GameConfig.tutor_talk["63"].talk,
            x = point.x,
            y = point.y,
            offX = 300,
            offY = 110,
            scale = -1,
            callback = function()     -- 选择物品
                self:selectedIndex(1, item)
                self:showGuideSealLayer()
            end,
        })

    end
end

function TailsSealScene:showGuideSealLayer()
    UserData:showGuideLayer({
        text = GameConfig.tutor_talk["64"].talk,
        x = display.cx+360,
        y = display.cy-265,
        offX = -300,
        offY = 110,
        autoremove = false,
        callback = function(target)     -- 点击封印 回调
            GuideData:setCompleted("Tails1", function()
                self.isGuide = false
                SealData:addSealExp(self.guideData.exp)

                self:resetAddItems()
                self:updateListView()
                self:updateCostView()
                self:updateButtonState()
                self:updateSealView()
                self:updateSealExView()
                showToast({text="封印成功"})
                self:updateAttributeData()
                self:updateAttributeView()

                target:removeSelf()
                UserData:showGuideLayer({
                    text = GameConfig.tutor_talk["50"].talk,
                    x = display.right - 70,
                    y = display.top - 50,
                    offX = -310,
                    offY = -50,
                    callback = function()
                        app:popScene()
                    end
                })

            end,
            function()
                self:showGuideSealLayer()
                target:removeSelf()
            end)
        end,
        autoremove = false,
    })
end




return TailsSealScene





