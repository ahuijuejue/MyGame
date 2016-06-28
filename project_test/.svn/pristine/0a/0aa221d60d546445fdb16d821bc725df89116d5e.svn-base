local HeroFlashLayer = class("HeroFlashLayer",function ()
	return display.newNode()
end)

local GafNode = import("app.ui.GafNode")

function HeroFlashLayer:ctor(param)
	self.heroSprite = display.newSprite(param.image)

    local width = self.heroSprite:getContentSize().width/2
    local height = self.heroSprite:getContentSize().height/2

    local posX = - width/2
    local toPosX1 = width
    local toPosX2 = toPosX1 + 150
    local posY = display.height - height/2 - 100

    if param.dir == 2 then
        posX = display.width + width/2
        toPosX1 = display.width - width
        toPosX2 = toPosX1 - 150
    end

    self.heroSprite:setPosition(posX,posY)
	self:addChild(self.heroSprite)

    local param1 = {x = toPosX1, y= posY, easing = "exponentialOut", time = 0.5, onComplete = function (sender)
        local param2 = {x = toPosX2, y = posY, easing = "exponentialIn", time = 0.5, onComplete = function ()
            if param.callback then
                param.callback(self)
            end
        end}
        transition.moveTo(sender,param2)
    end}
    transition.moveTo(self.heroSprite,param1)
end

return HeroFlashLayer