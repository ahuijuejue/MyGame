
local AincradBar = class("AincradBar", function()
	return display.newNode()
end)

function AincradBar:ctor()		
	self:initData()
	self:initView()
	self:setNodeEventEnabled(true)
end

function AincradBar:initData()	
	self.buff = {}
	self.willBuff = {}
end 

function AincradBar:initView()	
	local posX = 0
	local posY = 0

	-- display.newSprite("Aincrad_Buff_Banner.png"):addTo(self)
	-- :pos(posX, posY)

	self.buffLayer = display.newNode():addTo(self)
	:zorder(2)
	:pos(posX-250, posY)
	
end 

function AincradBar:onEnterTransitionFinish()	
	self:updateData()
	self:updateView()

end 

function AincradBar:updateData() 
	local buffs = AincradBuffData:getHaveBuff()
	self.buff = {} 
	for i,v in ipairs(buffs) do
		table.insert(self.buff, {
			id = v.id,
			icon = v.icon,
			value = v.process,
		})
	end	
end 

function AincradBar:updateView()
	self:updateBuffShow()
end 

function AincradBar:showChange(animated)
	self:updateData()
	self:updateView()
end 

function AincradBar:updateBuffShow()
	self.buffLayer:removeAllChildren()
	for i,v in ipairs(self.buff) do
		display.newSprite(v.icon)
		:addTo(self.buffLayer)
		:pos((i-1) * 90, 0) 
		:scale(0.35)

		local willadd = self.willBuff[v.id] or 0
		base.Label.new({text=string.format("%d%%", v.value + willadd), size=18}):addTo(self.buffLayer):zorder(2):align(display.CENTER)
		:pos((i-1) * 90 + 50, 0)
	end
end 

function AincradBar:setWillBuff(dict)
	self.willBuff = dict or {}	
end 

function AincradBar:onExit()

end 


return AincradBar
