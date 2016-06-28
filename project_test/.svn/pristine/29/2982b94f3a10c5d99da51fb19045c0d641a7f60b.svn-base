--[[
山多拉的灯备战场景
]]
local TrialLightReadyScene = class("TrialLightReadyScene", base.Scene)

function TrialLightReadyScene:initData(options)        
    self.grade = options.grade or 1    
    self.heroList_ = UserData:getLightBattleList()
end

function TrialLightReadyScene:initView()
    self:autoCleanImage()
    -- 背景
    CommonView.background()
    :addTo(self)
    :center()
    
    CommonView.blackLayer3()
    :addTo(self)

    -- 返回按钮
    CommonButton.back()
    :addTo(self)
    :pos(display.right - 90, display.top - 60)
    :zorder(10)
    :onButtonClicked(function(event)
        CommonSound.back() -- 音效
        
        self:pop()
    end)
    

-- 主层

    --------背景框
    

    --------

    -- 选择层
    self.selectLayer_ = app:createView("readyplay.HolyLandSelectLayer", {limitnum = 4}):addTo(self)
    :setHeroList(self.heroList_)
    :onTouch(function(event)
        local name = event.name 
        if name == "selected" then 
            self.startPlayBtn_:setButtonEnabled(true)
        elseif name == "unselected" then 
            if event.count <= 0 then 
                self.startPlayBtn_:setButtonEnabled(false)
            end 
        end 
        -- body
    end)

    -- 开始按钮
    self.startPlayBtn_ = CommonButton.start()
    :onButtonClicked(function(event)
        CommonSound.click() -- 音效
        print("kaishi")
        if self.selectLayer_:canSelected() then             
            local msg = display.newNode():size(0, 100)
            base.Label.new({text="现在未满员出战，是否继续开始战斗？", size=20}):addTo(msg):align(display.CENTER):pos(0, 50)
            
            AlertShow.show2("友情提示", msg, "确定", function()
                self:didStartGame()
            end)
        else
            self:didStartGame()
        end 
    end)
    :addTo(self)
    :pos(display.cx + 400, 220)
    :zorder(10)
    :setButtonEnabled(false)
    

end 

function TrialLightReadyScene:didStartGame()
    local heroId, heroData = self.selectLayer_:getHeroList()  
        
    UserData:setLightBattleList(heroId)

    local light = TrialData:getLight(self.grade) 
    -- 进入战斗界面 
   local toData = {
        building        =   CityData:getBuilding(),
        seal_xing       =   SealData:getAttributeForBattle(),
        team               = clone(heroData), 
        teamTotalExp       = UserData.totalExp,      
        clockLevel         = light.enemyLevel,
        secondStarTime     = light.limitTime,
        thirdStarCondition = 2,
        teamAppendExp      = 0,
        heroAppendExp      = 0,
        skillValue         = 0,
        gold               = 0,
        item               = {},
        clock              = light:getDataList(), 
        id                 = light.id,          -- 配置id 
        type               = light.type,        -- 钟的类型  
        smallGold          = light.gold1,
        middleGold         = light.gold2,
        largeGold          = light.gold3,
        totalGold          = light.overGold,
        time               = light.limitTime,
        tailSkill          =   {                   
                                    level = SealData:getSealLevel(),    -- 封印等级 
                                    skill = TailsData:getTailsSkillIdList(),  -- 尾兽技能id列表 
                                },
        winFunction     =   function()
                                AudioManage.playMusic("Main.mp3",true)
                                app:popScene()
                                app:popScene()
                            end,
        failedFunction  =   function()
                                AudioManage.playMusic("Main.mp3",true)
                                app:popScene()
                                app:popScene()
                            end,
    }

    app:enterScene("TrialLightBattleScene", {toData})
    
end



return TrialLightReadyScene





    