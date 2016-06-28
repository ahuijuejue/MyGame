--[[
建筑属性弹出层
]]

local CityInfoLayer = class("CityInfoLayer", function()
	return display.newNode()
end)

function CityInfoLayer:ctor(params)
	self.model = params.towerModel 
	self.name = params.name or ""
	self:initView()
end

function CityInfoLayer:initView()
	-- 灰层背景	
	CommonView.blackLayer2()
    :addTo(self)
    :onTouch(function()
    	self:onButtonClose()
    end)

    self.layer_ = display.newNode():size(960, 640):align(display.CENTER):addTo(self):center()
    self.layer_:setScale(0.3)
    local seq = transition.sequence({
        cc.ScaleTo:create(0.15, 1.15),
        cc.ScaleTo:create(0.05, 1)
        })
    self.layer_:runAction(seq)
	
-- 主层	
------------------------------------
--背景框
    CommonView.mFrame1()
    :addTo(self.layer_)
	:pos(480, 320)
	:onTouch(function(event)
		if event.name == "began" then 
			return true 
		end 
	end)

	-- 标题
	base.Label.new({text=self.name.."属性", size=20})
	:align(display.CENTER)
	:addTo(self.layer_)
	:pos(480, 434)


------------------------------------
-- 关闭按钮
	CommonButton.close()
	:addTo(self.layer_)
	:pos(730, 490)
	:onButtonClicked(function()
		self:onButtonClose()		
	end)
------------------------------------
-- 属性名 
	local names = {
		"生命：",
		"物理攻击：",
		"能量攻击：",
		"物理防御：",
		"能量防御：",
		"物理破防：",
		"能量破防：",
		"命中：",
		"闪避：",
		"暴击：",
		"吸血：",
		"击退：",
		"后仰：",		
	}

	local values = {
		self.model.property.maxHp,
		self.model.property.atk,
		self.model.property.magicAtk,
		self.model.property.defense,
		self.model.property.magicDefense,
		self.model.property.acp,
		self.model.property.magicAcp,
		self.model.property.rate,
		self.model.property.dodge,
		self.model.property.crit,
		self.model.property.blood,
		self.model.property.breakValue,
		self.model.property.tumble,
	}

	local flag = 7
	for i,v in ipairs(names) do
		if i <= flag then 
			self:addInfoLabel(v, 270, 380-(i-1)*30)
			self:addInfoLabel(tostring(values[i]), 400, 380-(i-1)*30)
		else 
			self:addInfoLabel(v, 500, 380-(i-flag-1)*30)
			self:addInfoLabel(tostring(values[i]), 600, 380-(i-flag-1)*30)
		end 
	end

------------------------------------
end

function CityInfoLayer:addInfoLabel(text, x, y)
	base.Label.new({text=text, size=20})
	:addTo(self.layer_)
	:pos(x, y)
end 

function CityInfoLayer:onButtonClose()
	CommonSound.close() -- 音效
	self:onEvent_({name="close"})
end 

function CityInfoLayer:onEvent(listener)
	self.eventListener_ = listener 
	return self 
end

function CityInfoLayer:onEvent_(event)
	if not self.eventListener_ then return end 
	event.target = self 
	self.eventListener_(event)
end

return CityInfoLayer
