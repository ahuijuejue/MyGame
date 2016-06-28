--[[
设置场景
]]
local PlayerSetScene = class("PlayerSetScene", base.Scene)


function PlayerSetScene:initData(params)
    self.data_ = {}
end

function PlayerSetScene:initView(params)
    self:autoCleanImage()
    -- 背景
    CommonView.background()
    :addTo(self)
    :center()

    CommonView.blackLayer3()
    :addTo(self)

    -- 按钮层
    app:createView("widget.MenuLayer"):addTo(self)
    :onBack(function(layer)
        self:pop()
    end)


-- 主层
---------------------------------------------------------------------
    --------背景框
    CommonView.boardFrame1()
    :addTo(self.layer_)
    :pos(435, 280)

    display.newSprite("PlayerInfo_Board.png"):addTo(self.layer_)
    :pos(295, 280)

    display.newSprite("Setup_Board.png"):addTo(self.layer_)
    :pos(697, 280)

    CommonView.titleFrame1()
    :addTo(self.layer_)
    :pos(315, 455)

    CommonView.barFrame1()
    :addTo(self.layer_)
    :pos(315, 405)

    CommonView.lines2()
    :addTo(self.layer_)
    :pos(315, 260)

    CommonView.titleFrame1()
    :addTo(self.layer_)
    :pos(697, 475)

    base.Label.new({text="设 置", size=24})
    :align(display.CENTER)
    :addTo(self.layer_)
    :pos(697, 475)

----------------------------------------------------------------------
    -- 头像
    self.headIcon_ = base.Grid.new()
    :addTo(self.layer_)
    :pos(150, 435)
    :setBackgroundImage("Mail_Circle.png")
    :addItem(display.newSprite("Banner_Level.png"):pos(-50, 30))
    :addItemWithKey("labelLv", base.Label.new({size=20, color=cc.c3b(250,250,250)})
            :pos(-50,30):align(display.CENTER))

---------------------------------------------------
--label
    -- 服务器名
    base.Label.new({text=UserData.zoneName, size=24}):addTo(self.layer_)
    :align(display.CENTER)
    :pos(315, 455)

    self.userName = base.Label.new({text=UserData.name, size=22, color=cc.c3b(0,250,0)}):addTo(self.layer_)
    :align(display.CENTER)
    :pos(315, 405)

    base.Label.new({text="战队经验：", size=20}):addTo(self.layer_)
    :pos(85, 220)

    base.Label.new({text="英雄数量：", size=20}):addTo(self.layer_)
    :pos(85, 185)

    base.Label.new({text="英雄等级上限：", size=20}):addTo(self.layer_)
    :pos(85, 150)

    base.Label.new({text="体力上限：", size=20}):addTo(self.layer_)
    :pos(85, 115)

    base.Label.new({text="英雄总战力：", size=20}):addTo(self.layer_)
    :pos(85, 85)

    -- 战队经验
    self.labelExp_ = base.Label.new({size=20, color=cc.c3b(250,250,0)}):addTo(self.layer_)
    :pos(200, 220)

    -- 英雄数量
    self.labelRoleCount_ = base.Label.new({size=20, color=cc.c3b(250,250,0)}):addTo(self.layer_)
    :pos(200, 185)

    -- 英雄等级上限
    self.labelLv_ = base.Label.new({size=20, color=cc.c3b(250,250,0)}):addTo(self.layer_)
    :pos(254, 150)

    -- 体力上限
    self.labelPowerMax_ = base.Label.new({size=20, color=cc.c3b(250,250,0)}):addTo(self.layer_)
    :pos(200, 115)

    -- 英雄总战力
    self.heroPowerMax_ = base.Label.new({size=20, color=cc.c3b(250,250,0)}):addTo(self.layer_)
    :pos(225, 85)

---------------
-- 按钮
    -- 更换头像
    CommonButton.long_red()
    :addTo(self.layer_)
    :pos(170, 320)
    :grayDisabled(true)
    :setButtonLabel(base.Label.new({text="更换头像", size=20}):align(display.CENTER))
    :onButtonClicked(function(event)
        CommonSound.click() -- 音效

        app:createView("setup.SetHeadLayer"):addTo(self)
        :zorder(10)
        :onEvent(function(event)
            if event.name == "close" then
                event.target:removeSelf()
            elseif event.name == "change" then
                local iconName = event.text
                UserData:setHead(iconName)
                self:updateHeadIcon()
                NetHandler.request("UpdateTeamSrc", {
                    data = {param1=iconName},
                })
            end
        end)
    end)

    -- 更换名称
    CommonButton.long_red()
    :addTo(self.layer_)
    :pos(420, 320)
    :setButtonLabel(base.Label.new({text="更换名称", size=20}):align(display.CENTER))
    :onButtonClicked(function(event)
        CommonSound.click() -- 音效

        self:showTakeNameLayer()
    end)

    -- 声音设置

    cc.ui.UIPushButton.new({ -- 声音设置
        normal = "Sound_Button.png",
        pressed = "Sound_Button.png",
    }):addTo(self.layer_)
    :pos(697, 385)
    :onButtonClicked(function(event)
        CommonSound.click() -- 音效

        app:createView("setup.SetSoundLayer"):addTo(self)
        :zorder(10)
        :onEvent(function(event)
            if event.name == "close" then
                event.target:removeSelf()
            end
        end)
    end)

    -- 推送设置

    cc.ui.UIPushButton.new({ -- 推送设置
        normal = "Push_Button.png",
        pressed = "Push_Button.png",
    }):addTo(self.layer_)
    :pos(697, 255)
    :onButtonClicked(function(event)
        CommonSound.click() -- 音效

        app:createView("setup.SetNotifLayer"):addTo(self)
        :zorder(10)
        :onEvent(function(event)
            if event.name == "close" then
                event.target:removeSelf()
            end
        end)
    end)

    -- 礼包兑换

    cc.ui.UIPushButton.new({ -- 礼包兑换
        normal = "Gift_Exchange_Button.png",
        pressed = "Gift_Exchange_Button.png",
    }):addTo(self.layer_)
    :pos(697, 125)
    :onButtonClicked(function(event)
        CommonSound.click() -- 音效

        app:createView("setup.GiftExchangeLayer"):addTo(self)
        :zorder(10)
        :onEvent(function(event)
            if event.name == "close" then
                event.target:removeSelf()
            elseif event.name == "ok" then
                local name = event.text
                if string.len(name) > 0 then
                    self:sendGiftCode(name, event.target)
                else
                    showToast({text="不能为空"})
                end
            end
        end)
    end)

    -- 切换账号
    self.accountButton = CommonButton.yellow("切换账号"):addTo(self.layer_)
    :pos(450, 100)
    :onButtonClicked(function(event)
        CommonSound.click() -- 音效

        app:backToStart()
    end)

end

function PlayerSetScene:showTakeNameLayer()
    app:createView("setup.SetNameLayer"):addTo(self)
    :zorder(10)
    :onEvent(function(event)
        if event.name == "close" then
            event.target:removeSelf()
        elseif event.name == "ok" then
            local name = event.text
            if string.len(name) > 0 then
                if MatchWord:check(name) then
                    self.takeNameLayer = event.target
                    NetHandler.request("UpdateTeamName", {
                        data={param1=2, param2=name},
                        onsuccess = function()
                            showToast({text="更名成功"})
                            if self.takeNameLayer then
                                self.takeNameLayer:removeSelf()
                                self.takeNameLayer = nil
                                self:updateUserName()
                            end
                        end
                    }, self)
                else
                    showToast({text="含有非法字符"})
                end
            else
                -- print("名字为空")
                showToast({text="名字为空"})
            end
        end
    end)
end

function PlayerSetScene:sendGiftCode(text, target)
    NetHandler.request("GiftExchange", {
        data = {param1=text},
        onsuccess = function()
            target:removeSelf()
        end
    }, self)
end

-----------------------------------------

function PlayerSetScene:updateView()

    self.headIcon_:getItem("labelLv"):setString(tostring(UserData:getUserLevel()))

    -- 战队经验
    local curentExp = UserData:getUserCurrentExp()
    local upgradeExp = UserData:getUserUpgradeExp()
    self.labelExp_:setString(string.format("%d/%d",curentExp,upgradeExp))
    -- 英雄数量
    local heros = HeroListData.heroList
    self.labelRoleCount_:setString(tostring(#heros))
    -- 英雄等级上限
    self.labelLv_:setString(tostring(GameExp.getLimitLevel()))
    -- 体力上限
    self.labelPowerMax_:setString(tostring(UserData:getPowerMax()))
    -- 英雄总战力
    self.heroPowerMax_:setString(tostring(HeroListData:getAllHeroPower()))

    self:updateHeadIcon()
end

function PlayerSetScene:updateUserName()
    self.userName:setString(UserData.name)
end

function PlayerSetScene:updateHeadIcon()
    self.headIcon_:setNormalImage(UserData.headIcon)
end


return PlayerSetScene





