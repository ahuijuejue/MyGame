local HeroGetLayer = import("..views.hero.HeroGetLayer")
local CharacterModel = import("app.battle.model.CharacterModel")
local GafNode = import("app.ui.GafNode")

local HeroGetScene = class("HeroGetScene", function()
    return display.newScene("HeroGetScene")
end)

local TAG = "HeroGetScene"

function HeroGetScene:ctor(hero,isHave)
	local bg = display.newSprite("Background_1.jpg")
    bg:pos(display.cx,display.cy)
    bg:addTo(self)

    --创建卡片界面
    local layer = display.newLayer()
    layer:pos(0,0)
    layer:addTo(self)

    --显示获得英雄卡片
    local param = {
        roleId = hero.roleId
	}
    local hero1 = CharacterModel.new(param)
    hero1:setHeroConfig()

	local border = display.newSprite("border_card.png")
    border:pos(display.cx,display.cy)
    border:addTo(layer,3)
    border:setScale(1.3)
    border:setVisible(false)

    local heroCard = display.newSprite(hero1.summonImage)
    heroCard:pos(display.cx,display.cy)
    heroCard:addTo(layer,2)
    heroCard:setScale(1.3)
    heroCard:setVisible(false)

    local heroFade = display.newSprite("Card_fade.png")
    heroFade:pos(display.cx,display.cy)
    heroFade:addTo(layer,1)
    heroFade:setScale(1.43)
    heroFade:setOpacity(0)
    heroFade:setVisible(false)

    local isOk = false
    local actions1 = {
		cc.ScaleTo:create(0.7, 1.2),
        cc.RotateTo:create(0.7,720*3)
	}
	local spawn1 = cc.Spawn:create(actions1)
    local heroCard1 = display.newSprite("Card_rotate.png")
    heroCard1:pos(display.cx,display.cy)
    heroCard1:addTo(layer)
    heroCard1:setScale(0)
    transition.execute(heroCard1, spawn1, {
	    onComplete = function()
	        isOk = true
	        border:setVisible(true)
	        heroCard:setVisible(true)
		    heroCard1:setVisible(false)
		    heroFade:setVisible(true)
		    local act = transition.sequence({
		        cc.FadeTo:create(0.4, 100),
        		cc.DelayTime:create(0.3),
			    cc.FadeTo:create(0.7, 0)
		    })
			heroFade:runAction(cc.RepeatForever:create(act))

            local param = {gaf = "card_effect_gaf"}
		    local effectNode = GafNode.new(param)
		    effectNode:playAction("card_effect_gaf", false)
		    effectNode:setScale(4.7)
		    effectNode:setTouchEnabled(false)
		    effectNode:setGafPosition(display.cx,display.cy-60)
		    layer:addChild(effectNode,3)
	    end,
	})

    layer:setTouchEnabled(true)
	layer:setTouchSwallowEnabled(true)
    layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	if isOk then
        		local param = {gaf = "card_effect_gaf"}
			    local effectNode = GafNode.new(param)
			    effectNode:playAction("card_effect_gaf", false)
			    effectNode:setScale(4.7)
			    effectNode:setTouchEnabled(false)
			    effectNode:setGafPosition(display.cx,display.cy-60)
			    layer:addChild(effectNode,3)
        	end
			return true
		elseif event.name == "ended" then
			if isOk then
		        heroFade:setVisible(false)
			    local actions = {
					cc.ScaleTo:create(0.7, 0),
			        cc.RotateTo:create(0.7,720*3)
				}
			    local spawn = cc.Spawn:create(actions)
			    border:runAction(spawn)

			    local actions1 = {
					cc.ScaleTo:create(0.7, 0),
			        cc.RotateTo:create(0.7,720*3)
				}
				local spawn1 = cc.Spawn:create(actions1)
			    transition.execute(heroCard, spawn1, {
				    onComplete = function()
				        layer:removeFromParent()
						self:showGetHeroLayer(hero,isHave)  --显示抽到英雄
				    end,
				})
				isOk = false
			end
		end
    end)

end

function HeroGetScene:showGetHeroLayer(hero,isHave)
    if isHave then
        local text = string.format(GET_TEXT_DATA("CHANGE_TO_STONE"),hero.exchangeStoneNum)
		local label = createOutlineLabel({text = text ,size = 20})
	    label:setColor(display.COLOR_RED)
	    label:setPosition(display.cx,display.cy-85)
	    label:zorder(10)
	    self:addChild(label)
    end
	self.getLayer = HeroGetLayer.new(hero)
	self:addChild(self.getLayer)
end

function HeroGetScene:onEnter()
	if self.isExit then
		self.isExit = false
	end
end

function HeroGetScene:onExit()
	self.isExit = true
end

return HeroGetScene