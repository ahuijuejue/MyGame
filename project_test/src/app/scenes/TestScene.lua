--
-- Author: zsp
-- Date: 2015-02-04 18:41:44
--

local BattleLoadingLayer = require("app.views.battle.BattleLoadingLayer")
require("app.battle.GafAssetCache")

local TestScene = class("TestScene", function()
    return display.newScene("TestScene")
end)


function TestScene:ctor()
    
    local loading = BattleLoadingLayer.new()
    loading:addTo(self)

    self.nameTable = {
        [1] = "Europe_1",
        [2] = "Tower5",
        [3] = "enter_effect_6",
        [4] = "enter_effect_3",
        [5] = "pet_tail_skill_1",
        [6] = "evolve_effect_1",
        [7] = "Eren",
        [8] = "Europe_4",
        [9] = "atk_effect_1",
        [10] = "SonGoKu",
        [11] = "atk_effect_3",
        [12] = "atk_effect_2",
        [13] = "sSaber",
        [14] = "trap_1",
        [15] = "sArthas",
        [16] = "Tower1",
        [17] = "navy_5",
        [18] = "skill_10063",
        [19] = "enter_effect_5",
        [20] = "skill_10066",
        [21] = "tail_skill_1",
        [22] = "navy_3",
        [23] = "Saber"
    }

    for k,v in pairs(self.nameTable) do
        GafAssetCache.addAssetName(v)
    end

    loading:load(GafAssetCache.getAssetNames(),handler(self, self.init))
    
end

function TestScene:init()
   
   -- for i = 1,#self.nameTable do
   --     local animNode = GafAssetCache.makeAnimatedObject(self.nameTable[i])
   --      --  animNode:setDelegate()
   --      -- animNode:registerScriptHandler(onFrame)

   --      animNode:setPosition(animNode:getFrameSize().width * -0.5 + 300,animNode:getFrameSize().height - 440  )

   --      animNode:addTo(self)
   --      animNode:start()
   -- end


   for i=1,23 do
        local animNode = GafAssetCache.makeAnimatedObject(self.nameTable[i])
        --  animNode:setDelegate()
        -- animNode:registerScriptHandler(onFrame)

        animNode:setPosition(animNode:getFrameSize().width * -0.5 + 300 + i * 10,animNode:getFrameSize().height - 440  )

        animNode:addTo(self)
        animNode:start()
   end

   local label =  display.newTTFLabel({
        text  = "完成了",
        size  = 24,
        align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
    })
   label:addTo(self)
   label:setPosition(display.cx,display.cy)
end

function TestScene:onEnter()
	
end

function TestScene:onExit()

end


return TestScene