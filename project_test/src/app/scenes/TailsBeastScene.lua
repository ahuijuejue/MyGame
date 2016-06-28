--[[
尾兽信息场景
]]
local TailsBeastScene = class("TailsBeastScene", base.Scene)

function TailsBeastScene:initData(options)

    self.tails_ = TailsData:getTails(options.id)
    self.skillData =self.tails_:getSkillList()
end

function TailsBeastScene:initView()
    self:autoCleanImage()
    -- 背景
    CommonView.background()
    :addTo(self)
    :center()

    CommonView.blackLayer3()
    :addTo(self)

    -- 按钮层
    app:createView("widget.MenuLayer", {wealth="tree"}):addTo(self)
    :onBack(function(layer)
        self:pop()
    end)


-- 主层
--------------------------------------------------------------
--------背景框
    CommonView.backgroundFrame1()
    :addTo(self.layer_)
    :pos(435, 280)


    display.newSprite("Tails_Show.png"):addTo(self.layer_)
    :pos(185, 280)

    CommonView.nameFrame2()
    :addTo(self.layer_)
    :pos(185, 535)

    CommonView.titleFrame3()
    :addTo(self.layer_)
    :pos(605, 478)

    CommonView.titleFrame3()
    :addTo(self.layer_)
    :pos(605, 258)

    -- 箭头
    for i=1,1 do
        CommonView.rAward1()
        :addTo(self.layer_)
        :pos(575 + i * 25, 140)
    end

    -- 花纹
    CommonView.lines2()
    :rotation(90)
    :addTo(self.layer_)
    :pos(360, 290)

--------------------------------------------------------------
    -------- label
    local tails = self.tails_
    -- 尾兽介绍
    display.newSprite("Tails_Desc.png")
    :addTo(self.layer_)
    :pos(605, 478)

    base.Label.new({text=tails.name,size=24}):addTo(self.layer_)
    :pos(185, 535)
    :align(display.CENTER)


    base.Label.new({
        text=tails.desc,
        size=20,
        align = cc.TEXT_ALIGNMENT_LEFT,
        dimensions = cc.size(405, 210),
    }):addTo(self.layer_)
    :pos(400, 450)
    :align(display.TOP_LEFT)
-----------------------------------
-- 尾兽技能
    -- 技能名
    display.newSprite("Tails_TailsSkill.png")
    :addTo(self.layer_)
    :pos(555, 258)

    self.skillNameLabel = base.Label.new({text="",size=24}):addTo(self.layer_)
    :pos(620, 258)

    -- 技能标题
    display.newSprite("Tails_CurSkill.png")
    :addTo(self.layer_)
    :pos(470, 200)

    display.newSprite("Tails_NextStar.png")
    :addTo(self.layer_)
    :pos(735, 200)

    -- 技能描述
    self.labelNow = base.Label.new({    -- 当前星级技能描述
        size=20,
        align = cc.TEXT_ALIGNMENT_LEFT,
        valign  = cc.VERTICAL_TEXT_ALIGNMENT_CENTER,
        dimensions = cc.size(175, 150),
    }):addTo(self.layer_)
    :pos(470, 185)
    :align(display.TOP_CENTER)

    self.labelNext = base.Label.new({   -- 下一星级技能描述
        size    = 20,
        align   = cc.TEXT_ALIGNMENT_LEFT,
        valign  = cc.VERTICAL_TEXT_ALIGNMENT_CENTER,
        dimensions = cc.size(175, 150),
    }):addTo(self.layer_)
    :pos(735, 185)
    :align(display.TOP_CENTER)

--------------------------
-- 尾兽形象
    local tailsAni = GameGaf.new({
        name = tails.iconAni,
        y = -100,
    })
    :onEvent(function(event)
        if event.name == "finish" then
            if event.aniName == "cheer" then
                event.target:play("idle", true)
            end
        end
    end)
    :start()
    :play("idle", true)

    base.Grid.new():addTo(self.layer_)
    :pos(180, 345)
    :addItem(tailsAni.anim)
    :onClicked(function()
        CommonSound.click() -- 音效

        tailsAni:play("cheer", false)
    end, cc.size(200, 200))
--------------------------------------
-- 星级
    -- 条
    display.newSprite("Tails_Star_Slip.png")
    :addTo(self.layer_)
    :pos(205, 152)


    -- display.newSprite("Tails_Star_Exp.png")
    -- :addTo(self.layer_)
    -- :pos(205, 152)


    self.slider_ = UserData:slider("Tails_Star_Exp.png")
    :addTo(self.layer_)
    :pos(205, 152)
    -- :align(display.LEFT_CENTER)

    -- 星星
    self.starView_ = {}
    for i=1,7 do
        display.newSprite("Idolum_Star.png"):addTo(self.layer_):pos(21 + i*41, 205):scale(0.7)
        local star = display.newSprite("Idolum_Star_Light.png"):addTo(self.layer_):pos(21 + i*41, 205):hide():scale(0.7)
        table.insert(self.starView_, star)
    end

    -- 碎片数量
    self.labelChips_ = base.Label.new({text="0/0", size=20}):addTo(self.layer_)
    :align(display.CENTER)
    :pos(190, 152)
    :zorder(2)

    -- 增加碎片按钮（跳转到世界树）
    base.Grid.new():addTo(self.layer_)--:hide()
    :pos(110, 152)
    :addItems({
        display.newSprite("HeroStone.png"),
        -- display.newSprite("Plus.png"):pos(20,-15),
    })


-----------------------------------------------
    -- 升星按钮
    self.starLvup_ = CommonButton.green("升星")
    :addTo(self.layer_):pos(185, 80)
    :onButtonClicked(function(event)
        CommonSound.click() -- 音效

        if tails:canLvup() then
            NetHandler.request("UpTailsStar", {
                data = {
                    param1 = tails.id,
                },
                onsuccess = function(params)
                    if params.id == tails.id then
                        self:updateChips()
                        self:updateSlider()
                        self:updateLvupButton()
                        self:updateStar()
                        self:updateSkillView()
                        tailsAni:play("cheer", false)
                    end
                end,
                onerror = function()
                    self:updateLvupButton()
                end
            }, self)
            self.starLvup_:setButtonEnabled(false)
        end
    end)

end
-- 刷新 升星按钮
function TailsBeastScene:updateLvupButton()
    local tails = self.tails_

    self.starLvup_:setButtonEnabled(tails:canLvup())
end

-- 刷新 碎片数量显示
function TailsBeastScene:updateChips()
    local tails = self.tails_

    self.labelChips_:setString(string.format("%d/%d", tails:getChipsCount(), tails:getChipsMax()))
end

function TailsBeastScene:updateSlider()
    local per = 0
    local tails = self.tails_
    if tails:getChipsMax() ~= 0 then
        per = tails:getChipsCount() / tails:getChipsMax()
    end

    UserData:setSliderPer(self.slider_, per)
end

-- 刷新 星星显示
function TailsBeastScene:updateStar()
    local tails = self.tails_

    for i,v in ipairs(self.starView_) do
        if i <= tails.star then
            v:show()
        else
            v:hide()
        end
    end
end

--------------------------------------

function TailsBeastScene:updateData()

end

function TailsBeastScene:updateView()
    self:updateChips()
    self:updateSlider()
    self:updateStar()
    self:updateLvupButton()
    self:updateSkillView()
end

function TailsBeastScene:updateSkillView()
    local level = self.tails_.star
    local skill = self.skillData[level]
    local nextSkill = self.skillData[level + 1]
    local skillName = nil
    local sealLevel = SealData:getSealLevel()

    if skill then
        self.labelNow:setString(skill:getDesc(sealLevel))
        skillName = skill.name
    else
        self.labelNow:setString("")
    end

    if nextSkill then
        self.labelNext:setString(nextSkill:getDesc(sealLevel))
        if not skillName then
            skillName = nextSkill.name
        end
    else
        self.labelNext:setString("")
    end

    -- 技能名
    if skillName then
        self.skillNameLabel:setString(skillName)
    end
end

------------------------------------------------------------
-- 新手引导

function TailsBeastScene:onGuide()
    if UserData:getUserLevel() < OpenLvData.tails.openLv then return end

    if GuideData:isNotCompleted("Tails2") then
        local posX = display.right - 70
        local posY = display.top - 50

        showTutorial2({
            text = GameConfig.tutor_talk["50"].talk,
            rect = cc.rect(posX, posY, 130, 130),
            x = posX - 300,
            y = posY - 50,
            callback = function(target)
                app:popScene()
                target:removeSelf()
            end,
        })
    end
end



return TailsBeastScene





