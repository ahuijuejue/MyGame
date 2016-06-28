--[[
尾兽场景
]]
local TailsScene = class("TailsScene", base.Scene)


function TailsScene:initData()

    self.tails_ = TailsData:getTailsList()

    self.isShowBeastGuide = false
end

function TailsScene:initView()
    self:autoCleanImage()
    -- 背景
    display.newSprite("Tails_Background.jpg")
    :addTo(self)
    :center()

    -- 按钮层
    app:createView("widget.MenuLayer", {wealth="tree"}):addTo(self)
    :onBack(function(layer)
        app:popScene()
    end)


-- 主层
----------------------------------------------
    --------背景框

    display.newSprite("Idolum_Name.png"):addTo(self.layer_)
    :pos(50, 440)
    --------
-----------------------------------------------
-- 按钮
    CommonButton.yellow2("封印魔像")
    :addTo(self.layer_)
    :pos(570, 40)
    :onButtonClicked(function()
        CommonSound.click() -- 音效

        print("封印魔像")
        app:pushScene("TailsSealScene")

    end)

    CommonButton.yellow2("出战设置")
    :addTo(self.layer_)
    :pos(740, 40)
    :onButtonClicked(function(event)
        if event.comb == 1 then
            CommonSound.click() -- 音效

            print("出战设置")
            self:showTailsSetLayer()
        end
    end)
----------------------------------------------------------
    -- 封印等级
    display.newSprite("Idolum_Level.png"):addTo(self.layer_)
    :pos(100, 70)

    display.newSprite("Idolum_Slip.png"):addTo(self.layer_)
    :pos(15, 35)
    :align(display.LEFT_CENTER)

    -- 星级
    self.star_ = {}
    for i=1,4 do
        display.newSprite("Idolum_Star.png"):addTo(self.layer_):pos(180+i*41, 70):scale(0.7)
        local star = display.newSprite("Idolum_Star_Light.png"):addTo(self.layer_):pos(180+i*41, 70):hide():scale(0.7)
        table.insert(self.star_, star)
    end

    self.slider_ = UserData:slider("Idolum_Exp.png")
    :addTo(self.layer_)
    :pos(15, 35)
    :align(display.LEFT_CENTER)

    self.labelLv_ = base.Label.new({
        text="封印0层",
        color=cc.c3b(250,250,250),
        size=22,
    }):addTo(self.layer_)
    :align(display.CENTER)
    :pos(100, 70)

    -- 箭头
    local arrow1 = display.newSprite("Page_Left.png"):pos(420, 300):addTo(self.layer_):hide()
    local arrow2 = display.newSprite("Page_Left.png"):pos(946, 300):addTo(self.layer_):rotation(180):hide()
    self.arrow_ = {arrow1, arrow2}

    -- 列表
    self.listView_ = base.ListView.new({
        viewRect = cc.rect(0, 0, 525, 230),
        direction = "horizontal",
        itemSize = cc.size(175, 230),
        page = true,
    })
    :addTo(self.layer_)
    :setBounceable(false)
    :zorder(5)
    :pos(435, 230)
    :setBounceable(false)
    :onTouch(function(event)
        if event.name == "clicked" then
            local index = event.itemPos
            if index then
                CommonSound.click() -- 音效

                self:selectedIndex(index)
            end

        elseif event.name == "moved" or event.name == "page_ended" then
            self:updateArrow()
        end

    end)

end

function TailsScene:onTailsClose(event)
    local tailsList = event.target:getList()
    dump(tailsList, "list")
    UserData:setTailsBattleList(tailsList)
    NetHandler.request("SaveTailsFormation", {
        data = {
            param1 = table.concat(tailsList, ","),
        },
    })
    event.target:removeSelf()
end

function TailsScene:showTailsSetLayer()
    local tailsLayer = app:createView("tails.TailsSetLayer",{list=UserData:getTailsBattleList()}):addTo(self, 10)
    :onClosed(function(event)
        self:onTailsClose(event)
    end)
------------------------------------------
-- 新手引导
    if GuideData:isNotCompleted("Tails2") and UserData:getUserLevel() >= OpenLvData.tails.openLv then
        self:showGuideTeamLayer(tailsLayer)
    end

end

function TailsScene:selectedIndex(index)
    print("选择：", self.tails_[index].name)
    local data = self.tails_[index]
    local sealInfo = SealData:getSealInfo()
    if sealInfo.lv >= data.openLv then
        app:pushScene("TailsBeastScene", {{id=data.id}})
    end
end

function TailsScene:updateArrow()
    local rect = self.listView_:getScrollNodeRect()
    local viewRect = self.listView_:getViewRect()

    local scrollX = self.listView_:getScrollNode():getPositionX()
    if scrollX < viewRect.x - 2 then
        self.arrow_[1]:show()
    else
        self.arrow_[1]:hide()
    end

    if scrollX + rect.width > viewRect.x + viewRect.width + 2 then
        self.arrow_[2]:show()
    else
        self.arrow_[2]:hide()
    end

end

--------------------------------------

function TailsScene:updateData()
    self.lv = UserData:getUserLevel()
end

function TailsScene:updateView()
    local sealInfo = SealData:getSealInfo()
    self:setSealLv(sealInfo.lv)
    :setStar(sealInfo.star)
    :setProgress(sealInfo.progress)

    self:updateListView()
    if self.offset_ then
        self.listView_:getScrollNode():pos(self.offset_[1], self.offset_[2])
    end
    self:updateArrow()
end

-- 设置封印等级
function TailsScene:setSealLv(lv)
    self.labelLv_:setString(string.format("封印%d层", lv))
    return self
end

-- 设置封印星星数量
function TailsScene:setStar(num)
    for i,v in ipairs(self.star_) do
        if i > num then
            v:hide()
        else
            v:show()
        end
    end
    return self
end

-- 设置封印进度条
function TailsScene:setProgress(per)
    self.slider_:setPercentage(math.min(per * 100, 100))
    return self
end

function TailsScene:updateListView()
    local items = self.tails_

    self.listView_
    :removeAllItems()
    :addItems(#items, function(event)
        local index = event.index
        local data = items[index]
        -- dump(data)
        local grid = base.Grid.new()
        :setNormalImage(display.newSprite("Tails_Name.png"):pos(0, 80))
        :addItems({
            base.Label.new({text = data.name, color=cc.c3b(250,250,250), size=18}):pos(0, 80):align(display.CENTER),
        })

        -- local icon = display.newSprite(data.icon):pos(0, -50):align(display.BOTTOM_CENTER)
        -- print("file:", data.iconAni)

        local delay = 0
        if index > 3 then
            delay = 0.5 * (index - 3)
        end

        local sealInfo = SealData:getSealInfo()
        local isNotOpen = sealInfo.lv < data.openLv

        local icon = display.newSprite(data.icon)

        if isNotOpen then
            grid:addItems({
                display.newSprite("AwakeStone0.png"):pos(0, -30),
                icon:pos(0, -30),
                display.newSprite("Tails_Lock.png"):pos(0, -30),

            })

            grid:addItem(base.Label.new({text=string.format("封印外道像\n%d层解锁", data.openLv), size=18, color=cc.c3b(250,10,10)})
                :align(display.CENTER):pos(0, -30):zorder(2))

        else
            grid:addItem(display.newSprite("AwakeStone4.png"):pos(0, -30))
            grid:addItem(icon:pos(0, -30))
        end

        return grid

    end)
    :reload()
end
------------------------------------------------------------
-- 新手引导

function TailsScene:onGuide()
    if UserData:getUserLevel() < OpenLvData.tails.openLv then return end

    if GuideData:isNotCompleted("Tails1") then
        UserData:showGuideLayer({
            x = display.cx+90,
            y = display.cy-280,
            offX = -310,
            offY = 110,
            text = GameConfig.tutor_talk["62"].talk,
            callback = function()
                app:pushScene("TailsSealScene")
            end,
        })
    elseif GuideData:isNotCompleted("Tails2") then
        if not self.isShowBeastGuide then -- 显示尾兽界面
            local point = convertPosition(self.listView_:itemAtIndex(1), self)
            UserData:showGuideLayer({
                text = GameConfig.tutor_talk["65"].talk,
                x = point.x,
                y = point.y - 20,
                offX = -300,
                offY = 110,
                callback = function()
                    self.isShowBeastGuide = true
                    self:selectedIndex(1)
                end,
            })
        else -- 尾兽出战
            UserData:showGuideLayer({
                text = GameConfig.tutor_talk["66"].talk,
                x = display.cx+260,
                y = display.cy-280,
                offX = -300,
                offY = 110,
                callback = function()
                    self:showTailsSetLayer()
                end,
            })
        end
    end
end

-- 显示出战界面引导
function TailsScene:showGuideTeamLayer(tailsLayer)
    function showClose()
        local point = convertPosition(tailsLayer.closeBtn, self)
        UserData:showGuideLayer({
            x = point.x,
            y = point.y,
            callback = function(target)
                self:onTailsClose({target = tailsLayer})
            end
        })
    end


    local data = tailsLayer.list_[1]
    local item = tailsLayer.listView_:itemAtIndex(1)
    local point = convertPosition(item, self)
    UserData:showGuideLayer({
        text = GameConfig.tutor_talk["67"].talk,
        x = point.x,
        y = point.y,
        offX = 300,
        offY = 110,
        scale = -1,
        callback = function()
            if tailsLayer:canSelected() then
                tailsLayer:selectedGetList(data)
                item:setSelected(true)
            end
            GuideData:setCompleted("Tails2", function()
                showClose()
            end, function()
                self:showGuideTeamLayer(tailsLayer)
            end)
        end,
    })
end
-------------------------------------------------

function TailsScene:onExit()
    self.offset_ = {self.listView_:getScrollNode():getPosition()}
    self:stopAllActions()

    TailsScene.super.onExit(self)
end

return TailsScene





