--
-- Author: zsp
-- Date: 2015-04-02 18:00:26
--

--[[
	战斗胜利结算 战队升级弹层
--]]
local TeamLevelUpLayer = class("TeamLevelUpLayer",function()
     return display.newColorLayer(cc.c4b(0, 0,0,100))
end)

function TeamLevelUpLayer:ctor(params)
	
	-- local effect = display.newSprite("loot_effect.png");
	-- effect:setScale(2)
	-- effect:setPosition(display.cx,display.cy + 200)
	-- effect:addTo(self)

	--self:setOpacity(150)

	dialog = CommonView.mFrame1()
	-- display.newSprite("Levelup_Board.png")
	dialog:setPosition(display.cx,display.cy - 20)
	dialog:setScale(0)
	dialog:addTo(self)

	local size = dialog:getContentSize()

	self:performWithDelay(function()
		local ani = GameGaf.new({
	        name = "lvup", 
	        x = size.width * 0.5,
	        y = size.height - 80,         
	    })
	    :onEvent(function(event)        
	        if event.name == "finish" then          	   
	            if event.aniName == "a1" then 
	                event.target:play("a2", true)
	            end 
	        end 
	    end)
	    :start()
	    :play("a1", false) 

	    ani.anim:addTo(dialog)
	end, 0.5)
	

	self.teamLevelName = display.newTTFLabel({
		text  = "战队等级：",
		size  = 25,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.teamLevelName:setAnchorPoint(0,0.5)
	self.teamLevelName:setPosition(100,240)
	self.teamLevelName:setColor(cc.c3b(255,255,255))
	self.teamLevelName:addTo(dialog)


	self.teamLevelLabel = self:createLabel(GameExp.getUserLevel(params.teamTotalExp), GameExp.getUserLevel(params.teamTotalExp + params.teamAppendExp))
	self.teamLevelLabel:setAnchorPoint(0,0.5)
	self.teamLevelLabel:setPosition(270,240)
	self.teamLevelLabel:setColor(cc.c3b(255,255,255))
	self.teamLevelLabel:addTo(dialog)

	self.energyName = display.newTTFLabel({
		text  = "当前体力：",
		size  = 25,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.energyName:setAnchorPoint(0,0.5)
	self.energyName:setPosition(100,180)
	self.energyName:setColor(cc.c3b(255,255,255))
	self.energyName:addTo(dialog)

	self.energyLabel = self:createLabel(params.levelUp.power1, params.levelUp.power2)
	self.energyLabel:setAnchorPoint(0,0.5)
	self.energyLabel:setPosition(270,180)
	self.energyLabel:setColor(cc.c3b(255,255,255))
	self.energyLabel:addTo(dialog)

	self.maxEnergyName = display.newTTFLabel({
		text  = "体力上限：",
		size  = 25,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.maxEnergyName:setAnchorPoint(0,0.5)
	self.maxEnergyName:setPosition(100,120)
	self.maxEnergyName:setColor(cc.c3b(255,255,255))
	self.maxEnergyName:addTo(dialog)

	self.maxEnergyLabel = self:createLabel(params.levelUp.powerMax1, params.levelUp.powerMax2)
	self.maxEnergyLabel:setAnchorPoint(0,0.5)
	self.maxEnergyLabel:setPosition(270,120)
	self.maxEnergyLabel:setColor(cc.c3b(255,255,255))
	self.maxEnergyLabel:addTo(dialog)

	self.maxHeroLevelName = display.newTTFLabel({
		text  = "英雄等级：",
		size  = 25,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.maxHeroLevelName:setAnchorPoint(0,0.5)
	self.maxHeroLevelName:setPosition(100,60)
	self.maxHeroLevelName:setColor(cc.c3b(255,255,255))
	self.maxHeroLevelName:addTo(dialog)

	self.maxHeroLevelLabel = self:createLabel(params.levelUp.levelMax1, params.levelUp.levelMax2)
	self.maxHeroLevelLabel:setAnchorPoint(0,0.5)
	self.maxHeroLevelLabel:setPosition(270,60)
	self.maxHeroLevelLabel:setColor(cc.c3b(255,255,255))
	self.maxHeroLevelLabel:addTo(dialog)

	local closeBtn = CommonButton.close()
	closeBtn:setPosition(520,380)
	closeBtn:addTo(dialog)
	closeBtn:onButtonClicked(function(event)
		self:removeFromParent()
		if params.callback then 
			params.callback()
		end 
    end)


	dialog:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1,1.5),cc.ScaleTo:create(0.1,1)))
	AudioManage.playSound("AccountLevelUp.mp3",false)
end

function TeamLevelUpLayer:createLabel(num1, num2)
	local node = display.newNode()

	local label1 = base.Label.new({text=string.format("%d", num1), size=25, color=cc.c3b(255,216,0)})
	:addTo(node)

	if num1 ~= num2 then 
		local w = label1:getContentSize().width
		display.newSprite("RankUp.png"):rotation(90)
		:addTo(node)
		:pos(w + 30, 0)

		base.Label.new({text=string.format("%d", num2), cc.c3b(83,255,87)})
		:addTo(node)
		:pos(w + 60, 0)
	end 

	return node
end 


return TeamLevelUpLayer