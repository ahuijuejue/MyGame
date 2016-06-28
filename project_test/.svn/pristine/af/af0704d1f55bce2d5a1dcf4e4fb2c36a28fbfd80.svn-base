--[[
    即将开启内容提示栏
--]]

local PredictionView = class("PredictionView",function()
	return display.newNode()
end)

function PredictionView:ctor()
	self.back = display.newSprite("left_back.png")
    :pos(display.left+130,display.bottom)
    :addTo(self)

    self:initData()
    self:initView()
end

function PredictionView:initData()
	self.arr = {}

	local cfg = GameConfig["Prediction"]
	for k,v in pairs(cfg or {}) do
	    local data = {
	        openLv = v.OpenLv,
	        icon1 = v.Icon1,
	        icon2 = v.Icon2,
	        name = v.Name
		}
		table.insert(self.arr, data)
	end
	table.sort(self.arr,function(a,b)
		return tonumber(a.openLv) < tonumber(b.openLv)
	end )

end

function PredictionView:initView()
	self.icon1 = display.newSprite()  -- icon1
	:addTo(self.back)
	:pos(60,65)

    self.node = display.newNode():pos(10,62):addTo(self.back)

    local label = base.Label.new({text = "即将开放", size = 18})
    label:setPosition(127, 35)
    self.node:addChild(label)

    self.label1 = base.Label.new({text = "", size = 18, color = cc.c3b(255, 255, 0)})
    self.label1:setPosition(147, 15)
    self.node:addChild(self.label1)

	self.label2 = base.Label.new({text = "", size = 18})
	:align(display.CENTER)
	:addTo(self.node)
	:pos(170, -17)
end

function PredictionView:updateView()
	local needLevel = {}
    for i=1,#self.arr do
    	if UserData:getUserLevel() < tonumber(self.arr[i].openLv) then
		    table.insert(needLevel,self.arr[i])
    	end
    end

    if #needLevel>0 then
    	self.icon1:setTexture(needLevel[1].icon1)
    	if needLevel[1].icon2 then
    		if self.icon2 then
    			self.icon2:setTexture(needLevel[1].icon2)
    		else
    			self.icon2 = display.newSprite(needLevel[1].icon2)  -- icon2
				:addTo(self.back)
				:pos(145,65)
    		end
    		self.icon1:pos(60, 60)
		    self.node:pos(90,62)
    		self.label1:pos(147, 15)
    		self.label2:pos(170, -17)
    	else
    		if self.icon2 then
    			self.icon2:removeFromParent()
    			self.icon2 = nil
    		end
    		self.icon1:pos(60 , 65)
		    self.node:pos(10,62)
    		self.label1:pos(147, 0)
    		self.label2:pos(170, -30)
    	end
    	self.label1:setString("LV"..needLevel[1].openLv)
        self.label2:setString(needLevel[1].name)
    end
end

function PredictionView:getMaxLevel()
	return tonumber(self.arr[#self.arr].openLv)
end

function PredictionView:getIsShow()
    if UserData:getUserLevel() >= self:getMaxLevel() then
        return false
    else
        return true
    end
end

return PredictionView