local BasicScene = import("..ui.BasicScene")
local HeroAwakeScene = class("HeroAwakeScene", BasicScene)

local HeroInfoLayer = import("..views.hero.HeroInfoLayer")
local MenuNode = import("..views.main.MenuNode")
local TutorialLayer = import("..ui.TutorialLayer")
local GameEquip = import("app.data.GameEquip")
local AwakeSuccessLayer = import("..views.hero.AwakeSuccessLayer")
local StarUpLayer = import("..views.hero.StarUpLayer")

local TAG = "HeroAwakeScene"
local bgImageName = "Background_gray.jpg"
local skyImage = "Sky_Left.png"
local backImage = "Return.png"
local backImage2 = "Return_Light.png"

function HeroAwakeScene:ctor(hero)
    HeroAwakeScene.super.ctor(self,TAG)
    self:createBackground()
    self.hero = hero
    --需要显示的属性类型
    self.attrType = {}
    --需要显示的属性值
    self.attrValue = {}
    --创建界面
    self.infoLayer = HeroInfoLayer.new(hero)
    self:addChild(self.infoLayer)

    local menuNode = MenuNode.new()
    menuNode:setPosition(display.width-60,50)
    menuNode:setHorBtnVisible(false)
    self:addChild(menuNode,4)

    self:createBackBtn()
end

function HeroAwakeScene:createBackground()
    local bgSprite = display.newSprite(bgImageName)
    bgSprite:setPosition(display.cx,display.cy)
    self:addChild(bgSprite)

    local skySprite = display.newSprite(skyImage)
    skySprite:setPosition(display.cx,bgSprite:getContentSize().height - skySprite:getContentSize().height/2)
    self:addChild(skySprite,-1)

    local colorLayer = display.newColorLayer(cc.c4b(0,0,0,170))
    self:addChild(colorLayer)
end

function HeroAwakeScene:createBackBtn()
    local backBtn = cc.ui.UIPushButton.new({normal = backImage, pressed = backImage2})
    :onButtonClicked(function ()
        AudioManage.playSound("Back.mp3")
        app:popToScene()
    end)
    self:addChild(backBtn,4)

    local posX = display.width - 55
    local posY = display.height - 45
    backBtn:setPosition(posX,posY)
end

function HeroAwakeScene:onGuide()
    if not GuideData:isCompleted("Awaken") then
        self.step = 0
        local rect = {x = display.cx+25, y = display.cy+135, width = 110, height = 110}
        local text = GameConfig.tutor_talk["35"].talk
        local param = {rect = rect, text = text,x = 260,y = 540, callback = handler(self,self.nextGuide)}
        showTutorial(param)
    elseif GuideData:isNotCompleted("StarUp") and UserData:getUserLevel() >= OpenLvData.starUp.openLv then
        self.step = 30
        local rect = {x = display.cx+345, y = display.cy-30, width = 120, height = 80}
        local posX = rect.x - 240
        local posY = rect.y + rect.height/2+110
        local text = GameConfig.tutor_talk["34"].talk
        local param = {rect = rect, text = text , x = posX, y = posY, callback = handler(self,self.nextGuide)}
        showTutorial(param)
    elseif not GuideData:isCompleted("Equipment") and OpenLvData:isOpen("equip") then
        self.step = 20
        local rect = {x = display.cx+345, y = display.cy+52, width = 120, height = 80}
        local posX = rect.x - 250
        local posY = rect.y + rect.height/2+110
        local text = GameConfig.tutor_talk["26"].talk
        local param = {rect = rect, text = text, x = posX,y = posY, callback = handler(self,self.nextGuide)}
        showTutorial(param)
    end
end

function HeroAwakeScene:nextGuide(tutor)
    if self.step == 0 then
        self:step0()
    elseif self.step == 1 then
        self:step1()
    elseif self.step == 2 then
        self:step2()
    elseif self.step == 3 then
        self.tutor = tutor
        NetHandler.gameRequest("NewComerGuide",{param1 = "Awaken"})
        return
    elseif self.step == 20 then
        self.infoLayer:resetTabStatus()
        self.infoLayer.tabNodes[2]:setLocalZOrder(3)
        self.infoLayer.tabNodes[2]:setPressedStatus()
        self.infoLayer:showView(2)
        local rect = {x = display.cx-140, y = display.cy+90, width = 110 ,height = 110}
        local text = GameConfig.tutor_talk["27"].talk
        local param = {rect = rect, text = text,x = display.cx+230, y = display.cy+220, scale = -1,callback = handler(self,self.nextGuide)}
        showTutorial(param)
    elseif self.step == 21 then
        self:addTempMat(1)
        self.infoLayer.equipView:showMergeLayer()

        local rect = {x = display.cx+55, y = display.cy -187, width = 115 ,height = 80}
        local posX = rect.x - 240
        local posY = rect.y + rect.height/2+110
        local text = GameConfig.tutor_talk["28"].talk
        local param = {rect = rect, text = text,x = posX,y = posY,callback = handler(self,self.nextGuide)}
        showTutorial(param)
    elseif self.step == 22 then
        self:guideEquip()
        self:addTempAdvMat(1)
        self.infoLayer.equipView:removeMergeLayer()
        self.infoLayer.equipView:updateEquipView()
        self.infoLayer.equipView.equipNodes[1]:showStrEffect(2)
        self.infoLayer.heroView:addEquipEffect()

        local rect = {x = display.cx-140, y = display.cy+90, width = 110 ,height = 110}
        local text = GameConfig.tutor_talk["27"].talk
        local param = {rect = rect, text = text,x = display.cx+230, y = display.cy+220, scale = -1,callback = handler(self,self.nextGuide)}
        showTutorial(param)
    elseif self.step == 23 then
        self.infoLayer.equipView.selectIndex = 1
        self.infoLayer.equipView:showEquipInfo(1)

        local rect = {x = display.cx-60, y = display.cy-260, width = 115 ,height = 80}
        local posX = rect.x - 240
        local posY = rect.y + rect.height/2+110
        local text = GameConfig.tutor_talk["29"].talk
        local param = {rect = rect, text = text,x = posX,y = posY,callback = handler(self,self.nextGuide)}
        showTutorial(param)
    elseif self.step == 24 then
        local equip = self.hero.equip[1]
        HeroAbility.unloadEquip(self.hero,equip,1)
        equip:upEquipLevel(10)
        HeroAbility.loadEquip(self.hero,equip,1)
        HeroAbility.strAbilityExtra(self.hero)
        self.infoLayer.equipView:updateEquipView()

        local rect = {x = display.cx+15, y = display.cy-260, width = 115 ,height = 80}
        local posX = rect.x - 240
        local posY = rect.y + rect.height/2+110
        local text = GameConfig.tutor_talk["31"].talk
        local param = {rect = rect, text = text,x = posX,y = posY,callback = handler(self,self.nextGuide)}
        showTutorial(param)
    elseif self.step == 25 then
        self.tutor = tutor
        NetHandler.gameRequest("NewComerGuide",{param1 = "Equipment"})
        return
    elseif self.step == 30 then
        self:step30()
    elseif self.step == 31 then
        self:step31()
    elseif self.step == 32 then
        self:step32()
    elseif self.step == 33 then
        self:step33()
    elseif self.step == 34 then
        self:step34()
    elseif self.step == 35 then
        self.tutor = tutor
        NetHandler.gameRequest("NewComerGuide",{param1 = "StarUp"})
        return
    end
    self.step = self.step + 1
    tutor:removeFromParent(true)
    tutor = nil
end

function HeroAwakeScene:stoneTutorial(pos)
    self.infoLayer.awakeView:createStoneMergeView(pos)
    local rect = {x = display.cx+54, y = display.cy -19, width = 120 ,height = 100}
    local posX = rect.x - 140
    local posY = rect.y + rect.height/2
    local text = GameConfig.tutor_talk["6"].talk
    local param = {rect = rect, text = text, x = posX, y=posY, callback = handler(self,self.nextGuide)}
    showTutorial(param)
end

--添加装备合成材料
function HeroAwakeScene:addTempMat(index)
    local equipInfo = GameConfig.hero_equip[self.hero.roleId]
    local key = string.format("GearItemID%d",index)
    local equipIds = equipInfo[key]
    local equipId = equipIds[index]
    local iConfig = GameConfig.item[equipId]
    local needItem = iConfig.Content.NeedItemID
    local needNum = iConfig.Content.NeedItemNum
    for i,v in ipairs(needItem) do
        local count = needNum[i]
        ItemData:addMultipleItem(v,count)
    end
end

--添加装备进阶材料
function HeroAwakeScene:addTempAdvMat(index)
    local equipId = self.hero.equip[index].targetItem
    local iConfig = GameConfig.item[equipId]
    local needItem = iConfig.Content.NeedItemID
    local needNum = iConfig.Content.NeedItemNum
    for i,v in ipairs(needItem) do
        local count = needNum[i]
        ItemData:addMultipleItem(v,count)
    end
end

function HeroAwakeScene:step0()
    self.infoLayer.awakeView:createStoneMergeView(1)

    local rect = {x = display.cx+58, y = display.cy -198, width = 120 ,height = 100}
    local posX = rect.x - 140
    local posY = rect.y + rect.height/2
    local text = GameConfig.tutor_talk["35"].talk
    local param = {rect = rect, text = text, x = posX-50, y=posY+130, callback = handler(self,self.nextGuide)}
    showTutorial(param)
end

function HeroAwakeScene:step1()
    self.infoLayer.awakeView:removeMergeLayer()
    self:insertStone(1)

    local rect = {x = display.cx+240, y = display.cy-105, width = 120, height = 80}--一键融合
    local posX = rect.x - 140
    local posY = rect.y + rect.height/2
    local text = GameConfig.tutor_talk["17"].talk
    local param = {rect = rect, text = text, x = posX-50, y=posY+120, callback = handler(self,self.nextGuide)}
    showTutorial(param)
end

function HeroAwakeScene:step2()
    HeroAbility.insertAllStone(self.hero)
    self.infoLayer.awakeView:updateView()

    local rect = {x = display.cx+7, y = display.cy-37, width = 150 ,height = 150}
    local text = GameConfig.tutor_talk["18"].talk
    local param = {rect = rect, text = text,x = 300,y = 510,callback = handler(self,self.nextGuide)}
    showTutorial(param)
end

function HeroAwakeScene:step3()
    local rect = {x = display.width-110, y = display.height-85, width = 110, height = 80}
    local posX = rect.x - 250
    local posY = rect.y + rect.height/2 - 50
    local text = GameConfig.tutor_talk["9"].talk
    local param = {rect = rect, text = text,x = posX,y = posY,callback = function (tutor)
        tutor:removeFromParent(true)
        tutor = nil
        app:pushToScene("MissionScene",true,{{latestType = 1}})
    end}
    showTutorial(param)
end

function HeroAwakeScene:step12()
    HeroAbility.insertAllStone(self.hero)
    self.infoLayer.awakeView:updateView()

    local rect = {x = display.cx+5, y = display.cy - 35, width = 150 ,height = 150}
    local text = GameConfig.tutor_talk["23"].talk
    local param = {rect = rect, text = text,callback = handler(self,self.nextGuide)}
    showTutorial(param)
end

function HeroAwakeScene:step13()
    local rect = {x = display.width-110, y = display.height-85, width = 110, height = 80}
    local posX = rect.x - 140
    local posY = rect.y + rect.height/2 - 50
    local text = GameConfig.tutor_talk["23"].talk
    local param = {rect = rect, text = text,x = posX,y = posY,callback = function (tutor)
        tutor:removeFromParent(true)
        tutor = nil
        app:pushToScene("MainScene")
    end}
    showTutorial(param)
end

function HeroAwakeScene:step30()
    self.infoLayer:resetTabStatus()
    self.infoLayer.tabNodes[3]:setLocalZOrder(3)
    self.infoLayer.tabNodes[3]:setPressedStatus()
    self.infoLayer:showView(3)

    local rect = {x = display.cx - 110, y = display.cy - 250, width = 120 ,height = 100}
    local posX = rect.x - 140
    local posY = rect.y + rect.height/2 +130
    local text = GameConfig.tutor_talk["35"].talk
    local param = {rect = rect, text = text,x = posX,y = posY, callback = handler(self,self.nextGuide)}
    showTutorial(param)
end

--引导镶嵌硬币
function HeroAwakeScene:step31()
    self.infoLayer.skillView:createInsertView(1)

    local rect = {x = display.cx+30, y = display.cy-30, width = 120 ,height = 100}
    local posX = rect.x - 220
    local posY = rect.y + rect.height/2 +130
    local text = GameConfig.tutor_talk["36"].talk
    local param = {rect = rect, text = text,x = posX,y = posY, callback = handler(self,self.nextGuide)}
    showTutorial(param)
end

--引导英雄进阶
function HeroAwakeScene:step32()
    self.infoLayer.skillView:removeInsertView()

    --临时增加英雄硬币
    self.hero.coinNums[1] = 15
    ItemData:reduceMultipleItem("10003",15)
    self.infoLayer.skillView:updateSkillView()

    local rect = {x = display.cx+220, y = display.cy-260, width = 120 ,height = 100}
    local posX = rect.x - 230
    local posY = rect.y + rect.height/2 +120
    local text = GameConfig.tutor_talk["37"].talk
    local param = {rect = rect, text = text, x = posX,y = posY, callback = handler(self,self.nextGuide)}
    showTutorial(param)
end

--引导升级技能3
function HeroAwakeScene:step33()
    local hero = self.hero
    hero:setStarLevel(hero.starLv + 1)
    hero.coinNums = {0,0,0,0,0,0}
    self.infoLayer.skillView:showStarUp()
    self.infoLayer.skillView:upgradeHeroName()

    showMask()
    self.infoLayer.skillView:showStarUp(function()
            hideMask()
            self:showStarUpSuccess(function()
                    showAside({key = "10015",callback = function ()
                    local rect = {x = display.cx+100, y = display.cy-140, width = 120 ,height = 100}
                    local posX = rect.x - 230
                    local posY = rect.y + rect.height/2 +110
                    local text = GameConfig.tutor_talk["38"].talk
                    local param = {rect = rect, text = text, x = posX,y = posY, callback = handler(self,self.nextGuide)}
                    showTutorial(param)
                end})
            end)
        end)
end

--引导升级技能2
function HeroAwakeScene:step34()
    local hero = self.hero
    local skillId = self.hero.skills[3]
    local level = hero.skillLevel[skillId]
    hero.skillLevel[skillId] = level + 1
    hero:updateProperty()

    --更新界面
    self.infoLayer.skillView.skillNode[3]:lvUpEffect()
    self.infoLayer.skillView.skillNode[3]:updateView()

    local rect = {x = display.cx-45, y = display.cy-140, width = 120 ,height = 100}
    local posX = rect.x - 230
    local posY = rect.y + rect.height/2 +110
    local text = GameConfig.tutor_talk["39"].talk
    local param = {rect = rect, text = text, x = posX,y = posY, callback = handler(self,self.nextGuide)}
    showTutorial(param)
end

--引导starUp结束
function HeroAwakeScene:step35()
    local hero = self.hero
    local skillId = self.hero.skills[2]
    local level = hero.skillLevel[skillId]
    hero.skillLevel[skillId] = level + 1
    hero:updateProperty()

    --更新界面
    self.infoLayer.skillView.skillNode[2]:lvUpEffect()
    self.infoLayer.skillView.skillNode[2]:updateView()

    self:tutorialBack()
end

--新手引导镶嵌宝石
function HeroAwakeScene:insertStone(pos)
    local heroId = self.hero.roleId
    local awakeInfo = GameConfig.hero_awake[heroId]
    local currentId = self.hero.stones[pos]
    if currentId == 0 then
        local key = string.format("ItemID%d",self.hero.awakeLevel+1)
        local targetId = awakeInfo[key][pos]
        HeroAbility.switchHeroStone(self.hero,targetId,pos)
    end
    self.infoLayer.awakeView:updateView()
end

--新手引导专属装备合成
function HeroAwakeScene:guideEquip()
    local equipInfo = GameConfig.hero_equip[self.hero.roleId]
    local key = string.format("GearItemID%d",1)
    local equipIds = equipInfo[key]
    local equip = GameEquip.new({itemId = equipIds[1],id = equipIds[1]})
    local length = #equip.needItem
    for i=1,length do
        local id = equip.needItem[i]
        local count = equip.needCount[i]
        ItemData:reduceMultipleItem(id,count)
    end
    HeroAbility.loadEquip(self.hero,equip,1)
    HeroAbility.advAbilityExtra(self.hero)
    self:showAttrUp(equip.types,equip.abilitys)
end

--新手引导装备强化
function HeroAwakeScene:strongEquip(uId)
    local equip = self.hero.equip[1]
    equip.uniqueId = uId
    local upLv = self.hero.equip[1]:getUpTimes(self.hero.level)
    local cost = equip:oneCost(self.hero.level)

    HeroAbility.unloadEquip(self.hero,equip,1)
    equip:upEquipLevel(upLv)
    HeroAbility.loadEquip(self.hero,equip,1)
    HeroAbility.strAbilityExtra(self.hero)
end

--引导升级技能2
function HeroAwakeScene:tutorialSkill()
    local skillId = self.hero.skills[1]
    local level = self.hero.skillLevel[skillId]
    self.hero.skillLevel[skillId] = level + 1
    self.infoLayer.skillView.skillNode[1]:updateView()
end

--引导返回
function HeroAwakeScene:tutorialBack()
    local rect = {x = display.width-110, y = display.height-85, width = 110, height = 80}
    local posX = rect.x - 250
    local posY = rect.y + rect.height/2 - 50
    local text = GameConfig.tutor_talk["9"].talk
    local param = {rect = rect, x = posX, text = text, y = posY, callback = function (tutor)
        tutor:removeFromParent(true)
        tutor = nil
        app:pushToScene("MissionScene",true,{{latestType = 1}})
    end}
    showTutorial(param)
end

function HeroAwakeScene:netCallback(event)
    local data = event.data
    local order = data.order
    if order == OperationCode.NewComerGuideProcess then
        self.tutor:removeFromParent(true)
        self.tutor = nil
        if self.step == 3 then
            local level = self.hero.awakeLevel + 1
            self.hero:setHeroAwakeLevel(level)

            self.infoLayer.heroView:awakeUpEffect(function ()
                self.infoLayer.awakeView:updateView()
                self:showAwakeSuccess()
            end)
        elseif self.step == 11 then
            local level = self.hero.awakeLevel + 1
            self.hero:setHeroAwakeLevel(level)

            self.infoLayer.heroView:awakeUpEffect(function ()
                self.infoLayer.awakeView:updateView()
                self:showAwakeSuccess()
            end)
        elseif self.step == 25 then
            local equip = self.hero.equip[1]
            local param = {itemId = equip.targetItem, id = equip:getLastUid(),level = equip.strLevel}
            local advEquip = GameEquip.new(param)
            local length = #advEquip.needItem
            for i=1,length do
                local id = advEquip.needItem[i]
                local count = advEquip.needCount[i]
                ItemData:reduceMultipleItem(id,count)
            end
            HeroAbility.unloadEquip(self.hero,equip,1)
            HeroAbility.loadEquip(self.hero,advEquip,1)
            HeroAbility.advAbilityExtra(self.hero)
            equip = nil

            self.infoLayer.equipView:removeEquipInfo()
            self.infoLayer.equipView:updateEquipView()
            self.infoLayer.equipView.equipNodes[1]:showStrEffect(1)
        elseif self.step == 35 then
            self:step35()
        end
    elseif order == OperationCode.JuexingRongHeBaoshiProcess then
        AudioManage.playSound("GemsLevelUp.mp3")

        local awakeInfo = GameConfig.hero_awake[self.hero.roleId]
        local key = string.format("ItemID%d",self.hero.strongLv+1)
        local stoneId = awakeInfo[key][data.param2]
        local stone = ItemData:getItemConfig(stoneId)
        local type_ = stone.content.Type
        local value_ = stone.content.Value
        self:showAttrUp(type_,value_)

        self.infoLayer.awakeView:removeMergeLayer()
        self.infoLayer.awakeView:updateView()
    elseif order == OperationCode.JueXingHeroProcess then
        --觉醒特效
        self.infoLayer.awakeView:showAwakeSuccess(function()
            self.infoLayer.heroView:awakeUpEffect(function ()
                self.infoLayer.awakeView:updateView()
                self:showAwakeSuccess()
            end)
        end)
    elseif order == OperationCode.OneKeyJuexingRongHeBaoshiProcess then
        self.infoLayer.awakeView:updateView()
    elseif order == OperationCode.ReplaceEquipProcess then
        self.infoLayer.equipView:updateEquipView()
    elseif order == OperationCode.BeginUseEquipProcess then
        local equip = ItemData:getEquipWithUid(data.param2)
        self:showAttrUp(equip.types,equip.abilitys)
        self.infoLayer.equipView:updateEquipView()
        --添加装备特效
        local pos = data.param3
        self.infoLayer.equipView.equipNodes[pos]:showStrEffect(2)
        self.infoLayer.heroView:addEquipEffect()
    elseif order == OperationCode.UnloadEquipProcess then
        self.infoLayer.equipView:updateEquipView()
    elseif order == OperationCode.QiangHuaEquipProcess then
        AudioManage.playSound("GearLevelUp.mp3")
        self.infoLayer.equipView:updateEquipView()
        if self.infoLayer.equipView.infoLayer then
            self.infoLayer.equipView.infoLayer:enhEquipEffect()
        end
    elseif order == OperationCode.JinjieEquipProcess then
        --进阶特效
        local pos = GamePoint.getEquipPos(self.hero,data.param1)
        self.infoLayer.equipView:updateEquipView()
        self.infoLayer.equipView.equipNodes[pos]:showStrEffect(1)
    elseif order == OperationCode.AssemblyEquipProcess then
        self.infoLayer.equipView:removeMergeLayer()
        self.infoLayer.equipView:updateEquipView()

        self.infoLayer.equipView.equipNodes[1]:showStrEffect(2)
        self.infoLayer.heroView:addEquipEffect()
    elseif order == OperationCode.JiahuEquipProcess then
        self.infoLayer.equipView:updateEquipView()
        if self.infoLayer.equipView.infoLayer then
            self.infoLayer.equipView.infoLayer:plusEquipEffect()
        end
    elseif order == OperationCode.JieSuoHeroNameProcess then
        --解锁英雄名
        AudioManage.playSound("Hero_Star.mp3")
        self.infoLayer.skillView:showStarUp(function()
            self:showStarUpSuccess()
        end)   ---------------------------- 升星特效
        self.infoLayer.skillView:upgradeHeroName()
    elseif order == OperationCode.XiangQianHeroNameChipProcess then
        self.infoLayer.skillView:updateSkillView()
    elseif order == OperationCode.UpHeroSkillLevelProcess then
        AudioManage.playSound("SkillLevelUp.mp3")
        --进击技能升级特效
        local skillId = data.param2
        local pos = 0
        for i=1,#self.hero.skills do
            if self.hero.skills[i] == skillId then
                pos = i
            end
        end
        self.infoLayer.skillView.skillNode[pos]:lvUpEffect()

        for i=1,#self.infoLayer.skillView.skillNode do
            self.infoLayer.skillView.skillNode[i]:updateView()
        end
    elseif order == OperationCode.UseYaoShuiProcess then
        self.infoLayer.awakeView:updateView()
    elseif order == OperationCode.OpenShopProcess then
        app:pushScene("ShopScene")
    end
end

--强化装备效果
function HeroAwakeScene:showStrUpEffect(event)
    if event.data["type_"] == 3 then
        local pos = event.data["pos"]
        self.infoLayer.awakeView.stoneHoles[pos]:showAddEffect()
    else
        local pos = event.data["pos"]
        self.infoLayer.equipView.equipNodes[pos]:showStrEffect(event.data["type_"])
    end
end

function HeroAwakeScene:showAttrUp(types,values)
    function showAttr()
       local text = GET_ABILITY_TEXT(self.attrType[1]).."+"..math.ceil(self.attrValue[1])
       local param = {text = text,size = 30,color = display.COLOR_GREEN,x = display.cx - 320, y = display.cy-60}
       local label = createOutlineLabel(param)
       self:addChild(label)

        local sequence = transition.sequence({
            cc.MoveBy:create(0.3, cc.p(0,30)),
            cc.DelayTime:create(0.3),
        })
        transition.execute(label,sequence,{onComplete = function ()
            label:removeFromParent(true)
            table.remove(self.attrType,1)
            table.remove(self.attrValue,1)
            if #self.attrType > 0 then
                showAttr()
            end
        end})
    end
     if #self.attrType > 0 then
        self.attrType = mergeTable(self.attrType,types)
        self.attrValue = mergeTable(self.attrValue,values)
    else
        self.attrType = mergeTable(self.attrType,types)
        self.attrValue = mergeTable(self.attrValue,values)
        showAttr()
    end
end

function HeroAwakeScene:showAwakeSuccess()
    local layer = AwakeSuccessLayer.new(self.hero)
    layer:setCallback(function ()
        if self.step == 3 then
            self:step3()
        elseif self.step == 11 then
            self:step13()
        end
        layer:removeFromParent(true)
        layer = nil
    end)
    self:addChild(layer,9)
end

function HeroAwakeScene:showStarUpSuccess(callback)
    local layer = StarUpLayer.new(self.hero)
    layer:setCallback(function ()
        layer:removeFromParent(true)
        layer = nil
        if callback then
            callback()
        end
    end)
    self:addChild(layer,9)
end


function HeroAwakeScene:onEnter()
    HeroAwakeScene.super.onEnter(self)
    self:onGuide()
    self.infoLayer:updateView()
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
    self.strEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.EQUIP_STR_EFFECT,handler(self,self.showStrUpEffect))
end

function HeroAwakeScene:onExit()
    HeroAwakeScene.super.onExit(self)
    GameDispatcher:removeEventListener(self.netEvent)
    GameDispatcher:removeEventListener(self.strEvent)
end

return HeroAwakeScene
