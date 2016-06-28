local LoadingLayer = import("..ui.LoadingLayer")
local AlertLayer = import("..ui.AlertLayer")
local TutorialLayer = import("..ui.TutorialLayer")
local AsideLayer = import("..ui.AsideLayer")

GameToast = {}
GameLoading = nil
GameMask = {}
NetAlert = nil
BroadCast = nil

--显示loading
function showLoading()
    hideLoading()
    GameLoading = LoadingLayer.new()
    GameLoading:showAnimation()
    display.getRunningScene():addChild(GameLoading,100)
end

--移除loading
function hideLoading()
    if GameLoading then
        display.getRunningScene():removeChild(GameLoading)
        GameLoading = nil
    end
end

--显示弹框
function showAlert(title,msg,callback)
    local alertLayer = AlertLayer.new(title,msg,callback)
    display.getRunningScene():addChild(alertLayer,999)
    return alertLayer
end

--移除弹框
function hideAlert(alert)
    if alert then
        alert:removeFromParent(true)
        alert = nil
    end
end

--购买技能点弹框
function buySkillAlert()
    -- local vipLv = tostring(UserData.vip)
    -- local buyLimimt = GameConfig.Vip[vipLv].skill_time
    local buyTimes = UserData.skillBuyTimes
    local nTimes = math.min(buyTimes+1,table.nums(GameConfig.TimesDiamond))
    local point = GameConfig.Global["1"].BuySkillPoint
    local price = GameConfig.TimesDiamond[tostring(nTimes)].BuySkillPoint
    local title = GET_TEXT_DATA("FRIEND_TIP")
    local msg = string.format(GET_TEXT_DATA("BUY_SKILL_TIP"),price,point)
    local alert = showAlert(title,msg,{sure = function (alert)
        -- if buyTimes >= tonumber(buyLimimt) then
        --     local param = {text = "购买次数已达上限",size = 30, color = display.COLOR_RED}
        --     showToast(param)
        -- else
        if UserData.diamond < tonumber(price) then
            local param = {text = "钻石不足",size = 30, color = display.COLOR_RED}
            showToast(param)
        else
            hideAlert(alert)
            NetHandler.gameRequest("BuySkillPowerStart")
        end
    end,cancel = function (alert)
        hideAlert(alert)
    end})

    local buyText = string.format(GET_TEXT_DATA("BUT_SKILL_TIMES"),buyTimes)
    local param = {text = buyText}
    local label = createOutlineLabel(param)
    label:setPosition(245,120)
    alert.box:addChild(label)
end

--增加屏蔽层
function showMask()
    local maskLayer = display.newColorLayer(cc.c4b(0,0,0,0))
    display.getRunningScene():addChild(maskLayer,999)
    table.insert(GameMask,maskLayer)
end

--移除屏蔽层
function hideMask()
    if #GameMask > 0 then
        GameMask[#GameMask]:removeFromParent(true)
        table.remove(GameMask,#GameMask)
    end
end

function showToast(param)
    local scene = display.getRunningScene()
    local x = param.x or display.cx
    local y = param.y or display.cy
    local text = param.text or ""
    local size = param.size or 26
    local color = param.color or cc.c3b(255, 45, 45)
    local time = param.time or 0.3
    local zorder = param.zorder or 999

    local label = createOutlineLabel({text = text, size = size ,color = color})
    label:setPosition(x,y-size)
    scene:addChild(label,zorder)

    local sequence = transition.sequence({
        cc.MoveBy:create(time, cc.p(0,size)),
        cc.DelayTime:create(0.3),
    })
    transition.execute(label,sequence,{onComplete = function ()
        label:removeFromParent(true)
    end})
end

--新手引导教程指引
-- {
--     rect = rect,
--     text = "",
--     dir = -1 or 1,
--     callback = callback
-- }
function showTutorial(param)
    local tutorLayer = TutorialLayer.new(param.rect or {x=0,y=0,width=display.width,height=display.height})
    if param.text then
        tutorLayer:showTip(param.text,param.x,param.y,param.scale)
    end
    local isShow = param.show or true
    if isShow then
        tutorLayer:showAnimation()
    end
    if param.callback then
        tutorLayer:setCallback(param.callback)
    end
    display.getRunningScene():addChild(tutorLayer,90)

    return tutorLayer
end

function showTutorial2(param)
    local rect = param.rect
    rect.x = rect.x - rect.width * 0.5
    rect.y = rect.y - rect.height * 0.5
    param.rect = rect
    return showTutorial(param)
end

--新手引导旁白
function showAside(param)
    local key = param.key
    local text = string.split(GameConfig.tutor_talk[key].talk,"|")
    local asideLayer = AsideLayer.new()
    asideLayer:setCallback(param.callback)
    asideLayer:setAside(text)
    asideLayer:setTalk()
    asideLayer:setAsideName(param.name or GameConfig.tutor_talk["10001"].talk)
    display.getRunningScene():addChild(asideLayer,90)
end

--战斗新手引导
function showBattleGuide(param)
    local text = param.text
    local callback = param.callback
    local x = param.x or 0
    local y = param.y or 0

    local sprite = display.newSprite("OperateBanner.png")
    sprite:setPosition(x,y)

    if text then
        local param = {text = text,size = 20}
        local label = createOutlineLabel(param)
        label:setPosition(140,100)
        sprite:addChild(label)
    end

    return sprite,label
end

--显示滚动条广告
function showNotice()
    function noticeBack()
        NoticeData:removeNotice()
        if NoticeData.notice[1] then
            local text = NoticeData.notice[1]
            BroadCast:setLabel(text,560,19)
        else
            BroadCast = nil
            local director = cc.Director:getInstance()
            director:setNotificationNode(BroadCast)
        end
    end
    if BroadCast then
        return
    else
        local text = NoticeData.notice[1]
        BroadCast = require("app.ui.NoticeNode").new()
        BroadCast:setPosition((display.width-560)/2,display.height-90)
        BroadCast:setLabel(text,560,19)
        BroadCast:setCallback(noticeBack)
        BroadCast:updateLabelPos()
        local director = cc.Director:getInstance()
        director:setNotificationNode(BroadCast)
    end
end

--创建物品Icon
function createItemIcon(itemId,enable,scale)
    local item = ItemData:getItemConfig(itemId)
    local itemBox = string.format("AwakeStone%d.png",item.configQuality)
    local itemBtn = cc.ui.UIPushButton.new({normal = itemBox})
    itemBtn:setButtonEnabled(enable or false)
    itemBtn:setScale(scale or 1)

    local itemSprite = display.newSprite(item.imageName)
    itemBtn:addChild(itemSprite,-2)

    local coinImage = "HeroStone.png"
    local stuffImage = "Stuff.png"

    if item.type == 1 then
        local stone = display.newSprite(coinImage)
        stone:setPosition(-48,40)
        itemBtn:addChild(stone)
    elseif item.type == 3 then
        local stuff = display.newSprite(stuffImage)
        stuff:setPosition(-48,40)
        itemBtn:addChild(stuff)
    end

    return itemBtn
end

--人物对话
function showRoleTalk(param)
    local image = param.image
    local dir = param.dir
    local name = param.name
    local callback = param.callback
    local text = param.text

    local layer =  display.newColorLayer(cc.c4b(0, 0,0,150))
    layer:addNodeEventListener(cc.NODE_TOUCH_EVENT,function (event)
        if event.name == "began" then
            return true
        elseif event.name == "ended" then
            if callback then
                callback()
            end
            layer:removeFromParent(true)
        end
    end)

    local shading = display.newSprite("Plot_Shading.png")
    shading:setAnchorPoint(0.5,0)
    shading:setPosition(display.cx,0)
    layer:addChild(shading)

    local roleSprite
    if image then
        roleSprite = display.newSprite(image)
        layer:addChild(roleSprite)
    end

    local nameLabel = base.TalkLabel.new({
            text  = name,
            size  = 30,
        })
    nameLabel:setAnchorPoint(0,0.5)
    layer:addChild(nameLabel)

    local infoLabel = base.TalkLabel.new({
            text  = text,
            size  = 24,
            dimensions = cc.size(400, 300)
        })
    infoLabel:setAnchorPoint(0,1)
    layer:addChild(infoLabel)

    if dir == 1 then
        roleSprite:setAnchorPoint(0,0)
        roleSprite:setPosition(0,0)

        nameLabel:setPosition(display.cx-30,183)
        infoLabel:setPosition(display.cx+30,453-32*infoLabel:getLines())
    elseif dir == -1 then
        roleSprite:flipX(true)
        roleSprite:setAnchorPoint(1,0)
        roleSprite:setPosition(display.width,0)

        nameLabel:setPosition(30,183)
        infoLabel:setPosition(90,453-32*infoLabel:getLines())
    elseif dir == 0 then
        nameLabel:setPosition(display.cx-180,183)
        infoLabel:setPosition(display.cx-120,453-32*infoLabel:getLines())
    end

    return layer
end

--创建英雄星级Icon
function createStarIcon(starLv)
    local bgImage = "Hero_Star_Circle.png"
    local starImage = string.format("Skill_Plus%d.png",starLv)

    local bgSprite = display.newSprite(bgImage)
    local starSprite = display.newSprite(starImage)
    starSprite:setScale(0.5)
    starSprite:setPosition(27,18)
    bgSprite:addChild(starSprite)

    return bgSprite
end

--创建英雄头像
function createHeroCircle(awakeLevel)
    local bgImage = string.format("HeroCircle%d.png",awakeLevel)
    local bgSprite = display.newSprite(bgImage)
    return bgSprite
end

--创建带描边label
function createOutlineLabel(param)
    local label = display.newTTFLabel(param)
    label:enableOutline(cc.c4b(59,30,18,255),1)
    return label
end

--创建带文字按钮
function createButtonWithLabel(param1,param2)
	local button = cc.ui.UIPushButton.new(param1)

    local label = createOutlineLabel(param2)
    button:setButtonLabel(label)

	return button
end

--创建物品效果动画
function createAniEffect(index)
    local str = string.format("ani_effect%d.png", index)
    local sSpr = display.newSprite(str)
    local action = cc.RepeatForever:create(cc.RotateBy:create(4, 360))
    sSpr:runAction(action)
    return sSpr
end

--创建箭头动画
function createAniArrow()
    local str = string.format("RankUp.png")
    local sSpr = display.newSprite(str):rotation(180)
    local action = cc.RepeatForever:create(cc.Sequence:create(
        cc.MoveBy:create(0.5, cc.p(0, -20)),
        cc.DelayTime:create(0.1),
        cc.MoveBy:create(0.5, cc.p(0, 20)),
        cc.DelayTime:create(0.1)
    ))
    sSpr:runAction(action)
    return sSpr
end

function createAnimation(name,len,time)
    local animation = cc.Animation:create()
    animation:setDelayPerUnit(time)
    for i=1,len do
        local image = string.format(name,i)
        animation:addSpriteFrameWithFile(image)
    end
    return animation
end

function showDropLayer(item)
    local closeImage = "Close.png"
    local ItemDropLayer = require("app.views.item.ItemDropLayer")

    local colorLayer = display.newColorLayer(cc.c4b(0,0,0,100))
    display.getRunningScene():addChild(colorLayer,5)

    local dropLayer = ItemDropLayer.new(item)
    dropLayer:setPosition(display.cx,display.cy)
    colorLayer:addChild(dropLayer)
    dropLayer:setScale(0.3)
    local seq = transition.sequence({
        cc.ScaleTo:create(0.15, 1.15),
        cc.ScaleTo:create(0.05, 1)
        })
    dropLayer:runAction(seq)

    local closeBtn = cc.ui.UIPushButton.new({normal = closeImage, pressed = closeImage})
    :onButtonClicked(function ()
        AudioManage.playSound("Close.mp3")
        colorLayer:removeFromParent(true)
        colorLayer = nil
        dropLayer = nil
        closeBtn = nil
    end)
    closeBtn:setPosition(240,100)
    dropLayer:addChild(closeBtn)
end