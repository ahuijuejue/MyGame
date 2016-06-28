local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    self:initData()
end

function MyApp:initData()
    SceneList = {}

    --账号服务器链接
    AccountConnection = require("app.net.Connection").new("Account")
    --游戏服务器链接
    GameConnection = require("app.net.Connection").new("Game")
    --聊天服务器链接
    ChatConnection = require("app.net.Connection").new("Chat")

    ConnectManage = require("app.net.ConnectManage").new()
    ChatManage = require("app.net.ConnectManage").new()

    SummonData    = require("app.data.SummonData").new()
    HeroListData  = require("app.data.HeroListData").new()
    ItemData      = require("app.data.ItemData").new()
    ChapterData   = require("app.data.ChapterData").new()
    TailsData     = require("app.data.TailsData").new()
    OpenLvData    = require("app.data.OpenLvData").new()
    UserData      = require("app.data.UserData").new()

    -- UserData.account = device.getOpenUDID()
    UserData.account = LOGIN_ACCOUNT
    UserData.pwd = LOGIN_PWD

    AudioData     = require("app.data.AudioData").new()
    PlayerSetData = require("app.data.PlayerSetData").new():loadConfig()
    ArenaTeam     = require("app.data.ArenaTeam")
    ArenaData     = require("app.data.ArenaData").new()
    BuyData       = require("app.data.BuyData").new()
    GlobalData    = require("app.data.GlobalData").new()
    MailData      = require("app.data.MailData").new()
    ShopList      = require("app.data.ShopList").new()
    TaskData      = require("app.data.TaskData").new()
    SceneData     = require("app.data.SceneData").new()
    SealData      = require("app.data.SealData").new()
    TailsSkillData  = require("app.data.TailsSkillData").new()
    ArenaReport   = require("app.data.ArenaReport").new()
    ArenaScoreData  = require("app.data.ArenaScoreData").new()
    CreateInfoData  = require("app.data.CreateInfoData").new()
    RankData      = require("app.data.RankData").new()
    TrialData     = require("app.data.TrialData").new()
    TrialIcon     = require("app.data.TrialIcon").new()
    SignInData    = require("app.data.SignInData").new()
    GameGaf       = require("app.data.GameGaf")
    GuideData       = require("app.data.GuideData").new()
    NameData        = require("app.data.NameData").new()
    MatchWord     = require("app.data.MatchWord").new()
    AincradData     = require("app.data.AincradData").new()
    AincradBuffData = require("app.data.AincradBuffData").new()
    CostDiamondData = require("app.data.CostDiamondData").new()
    VipData         = require("app.data.VipData").new()
    RechargeData         = require("app.data.RechargeData").new()
    NumberData      = require("app.data.NumberData").new()
    ResetTimeData   = require("app.data.ResetTimeData").new()
    RobotData       = require("app.data.RobotData").new()
    TreeData        = require("app.data.TreeData").new()
    CityData        = require("app.data.CityData").new()
    NoticeData      = require("app.data.NoticeData").new()
    GuideManager    = require("app.util.guide.GuideManager").new()
    ActivityOpenData  = require("app.data.ActivityOpenData").new()
    ActivityNormalData  = require("app.data.ActivityNormalData").new()
    ArenaLookingForData = require("app.data.ArenaLookingForData").new()
    SwordActivityData = require("app.data.SwordActivityData").new()
    ChatData        = require("app.data.ChatData").new()
    UnionListData        = require("app.data.UnionListData").new()
    SlotModel = require("app.model.SlotModel").new()
    FlopModel = require("app.model.FlopModel").new()
    FeedbackModel = require("app.model.FeedbackModel").new()
    GamblingModel = require("app.model.GamblingModel").new()
    DiscountShopModel = require("app.model.DiscountShopModel").new()
    CoinData = require("app.data.CoinData").new()

    --游戏事件分发器
    GameDispatcher = require("framework.cc.components.behavior.EventProtocol").new()
end

function MyApp:pushToScene(name,needNew,args,transitionType,time,more)
    local cScene = display.getRunningScene()
    local index = self:indexOfScene(name)

    if index == 0 then
        showMask()
        local scene = self:createScene(name,args,transitionType,time,more)
        table.insert(SceneList,scene)

        local sDirector = cc.Director:getInstance()
        sDirector:pushScene(scene)

        return scene
    else
        local cIndex = self:indexOfScene(cScene.name)
        local times = cIndex - index
        local times_ = times
        while times > 0 do
            self:popToScene()
            times = times - 1
        end
        if needNew and times_ > 0 then
            local scene = self:createScene(name,args,transitionType,time,more)
            table.remove(SceneList,#SceneList)
            table.insert(SceneList,scene)

            local sDirector = cc.Director:getInstance()
            sDirector:replaceScene(scene)

            return scene
        end
    end
end

function MyApp:enterToScene(name,needNew,args,transitionType,time,more)
    if self:indexOfScene(name) ~= 0 then
        self:pushToScene(name,needNew,args,transitionType,time,more)
        return
    end

    local lastScene = SceneList[#SceneList]
    if lastScene then
        table.remove(SceneList,#SceneList)
    end
    local scene = self:createScene(name,args,transitionType,time,more)
    table.insert(SceneList,scene)

    local sDirector = cc.Director:getInstance()
    if sDirector:getRunningScene() then
        sDirector:replaceScene(scene)
    else
        sDirector:runWithScene(scene)
    end
end

--进入下一个场景 会移除堆栈所有的场景
function MyApp:enterByScene(name,args,transitionType,time,more)
    self:popToRootScene()
    self:enterToScene(name,args,transitionType,time,more)
end

function MyApp:popToRootScene()
    local times = #SceneList - 1
    while times > 0 do
        self:popToScene()
        times = times - 1
    end
end

function MyApp:logSceneList()
    for i,v in ipairs(SceneList) do
        print(v.name)
    end

end

function MyApp:popToScene()
    if #SceneList > 1 then --至少存在一个场景
        table.remove(SceneList,#SceneList)
        local sDirector = cc.Director:getInstance()
        sDirector:popScene()
        hideMask()
        self:collectMemory()
    end
end

function MyApp:indexOfScene(name)
    for i,v in ipairs(SceneList) do
        if v.name == name then
            return i
        end
    end
    return 0
end

function MyApp:createScene(name,args,transitionType,time,more)
    local scenePackageName = self.packageRoot .. ".scenes." .. name
    local sceneClass = require(scenePackageName)
    local scene = sceneClass.new(unpack(checktable(args)))

    if transitionType then
        local newScene = display.wrapSceneWithTransition(scene, transitionType, time, more)
        newScene.name = scene.name
        scene = newScene
    end
    return scene
end

function MyApp:connectEvent(event)
    local data = event.data
    if data.name == cc.net.SocketTCP.EVENT_CONNECTED then
        if data.tag == "Game" then
            self:gameSeverConnected()
        elseif data.tag == "Chat" then
            ChatManage:start()
        end
    elseif data.name == cc.net.SocketTCP.EVENT_CONNECT_FAILURE then
        if data.tag == "Game" then
            self:gameSeverFailure()
        end
    end
end

function MyApp:gameSeverConnected()
    hideLoading()
    ConnectManage:start()
    NetHandler.enterGameHandler()
end

function MyApp:gameSeverFailure()
    hideLoading()
    showAlert("",GET_TEXT_DATA("TEXT_SERVER_ERR"),{sure = function (alert)
        showLoading()
        hideAlert(alert)
        GameConnection:disconnect()
        GameConnection:connect(UserData.ip,UserData.port)
    end,cancel = function (alert)
        hideAlert(alert)
        self:backToStart()
    end})
end

function MyApp:setGameTick()
    ConnectManage:setTick(function ()
        NetHandler.gameRequest("Heart")
    end)
    ConnectManage:setTickBreakCallback(function ()
        showLoading()
        GameConnection:disconnect()
        GameConnection:connect(UserData.ip,UserData.port)
    end)
end

function MyApp:setChatTick()
    ChatManage:setTick(function ()
        NetHandler.chatRequest("ChatHeart")
    end)
    ChatManage:setTickBreakCallback(function ()
        ChatConnection:disconnect()
        ChatConnection:connect(UserData.chatSever,UserData.chatPort)
    end)
end

function MyApp:backToStart()
    self:removeNetEvent()
    PlayerData.clean()
    ConnectManage:stop()
    ChatManage:stop()
    GameConnection:disconnect()
    ChatConnection:disconnect()
    AccountConnection:disconnect()
    if LOAD_UPDATE then
        self:popToRootScene()
        SceneList = {}
        local UpdateScene = require("update.UpdateScene")
        local scene = UpdateScene.new()
        display.replaceScene(scene)
    else
        self:enterByScene("StartScene")
    end
end

function MyApp:addNetEvent()
    if self.connect then
        return
    end
    self.connect = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_STATUS,handler(self,self.connectEvent))
end

function MyApp:removeNetEvent()
    if self.connect then
        GameDispatcher:removeEventListener(self.connect)
        self.connect = nil
    end
end

--收集内存
function MyApp:collectMemory()
    local scheduler = require("framework.scheduler")
    scheduler.performWithDelayGlobal(function ()
        display.removeUnusedSpriteFrames()
        collectgarbage("collect")
    end,1)
end

return MyApp