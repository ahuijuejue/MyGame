local SkillDesNode = class("SkillDesNode",function ()
	return display.newNode()
end)

local bgImage = "Skill_Tip.png"
local skillCircle = "Skill_Circle.png"

function SkillDesNode:ctor(info1,info2,level)
	self.info1 = info1
	self.info2 = info2
	self.value1 = self:getUpValue(info1,level)
	self.value2 = self:getUpValue(info2,level)
	self:createDesNode()
end

function SkillDesNode:getUpValue(info,level)
	local value = {}
	local skillInfo = info
	local levelData = skillInfo.level_data

	if levelData then
		for i=1,#levelData do
			local tb = string.split(levelData[i],":")
			local k = tb[1]
			local v = checknumber(tb[2])
			table.insert(value,Formula[7](skillInfo[k],level,checknumber(v)))
			table.insert(value,v)
		end
	end

	local buffId = {}
	if skillInfo.buff_id then
		if string.find(skillInfo.buff_id,",") then
			local buffs = string.split(skillInfo.buff_id,",")
			for i=1,#buffs do
				table.insert(buffId,buffs[i])
			end
		else
			table.insert(buffId,skillInfo.buff_id)
		end
	end

	if skillInfo.my_buff then
		if string.find(skillInfo.my_buff,",") then
			local buffs = string.split(skillInfo.my_buff,",")
			for i=1,#buffs do
				table.insert(buffId,buffs[i])
			end
		else
			table.insert(buffId,skillInfo.my_buff)
		end
	end

	for i=1,#buffId do
		local buffInfo = GameConfig.buff[buffId[i]]
		local buffData = buffInfo.level_data
		if buffData then
			for i=1,#buffData do
				local tb = string.split(buffData[i],":")
				local k = tb[1]
				local v = checknumber(tb[2])
				table.insert(value,Formula[7](buffInfo[k],level,checknumber(v)))
				table.insert(value,v)
			end
		end
	end

	if skillInfo.breaks then
		local basicValue = tonumber(skillInfo.breaks)
		local upValue = tonumber(skillInfo.breaks_upgrade)
		table.insert(value,Formula[17](basicValue,level,upValue))
	end

	return value
end

function SkillDesNode:getUpString(info,value)
	local skillInfo = info
	local upStr = skillInfo.level_info
	for i=1,#value do
		upStr = string.gsub(upStr,"s",value[i],1)
	end
	return upStr
end

function SkillDesNode:createDesNode()

	local iconName = self.info1.image..".png"
	local icon1 = self:createSkillIcon(iconName)
	icon1:setScale(0.7)

	local param = {text = self.info1.info,align = cc.TEXT_ALIGNMENT_LEFT, dimensions = cc.size(400, 0)}
	local label1 = createOutlineLabel(param)
	label1:setAnchorPoint(0,1)
	label1:setPosition(140,120)
	icon1:addChild(label1)
    local h1 = label1:getContentSize().height

	local param = {text = self:getUpString(self.info1,self.value1),dimensions = cc.size(400, 0)}
	local upLabel1 = createOutlineLabel(param)
	upLabel1:setColor(cc.c3b(255,97,0))
	upLabel1:setAnchorPoint(0,1)
	upLabel1:setPosition(140,120-h1)
	icon1:addChild(upLabel1)
	local uph1 = upLabel1:getContentSize().height

    local iconName = self.info2.image..".png"
	local icon2 = self:createSkillIcon(iconName)

	skillInfo = GameConfig.skill[self.skillId2]
	local param = {text = self.info2.info, align = cc.TEXT_ALIGNMENT_LEFT, dimensions = cc.size(400, 0)}
	local label2 = createOutlineLabel(param)
	label2:setAnchorPoint(0,1)
	label2:setPosition(140,120)
	icon2:addChild(label2)
	local h2 = label2:getContentSize().height

	local param = {text = self:getUpString(self.info2,self.value2),dimensions = cc.size(400, 0)}
	local upLabel2 = display.newTTFLabel(param)
	upLabel2:setColor(cc.c3b(255,97,0))
	upLabel2:setAnchorPoint(0,1)
	upLabel2:setPosition(140,120-h2)
	icon2:addChild(upLabel2)
    local uph2 = upLabel2:getContentSize().height

    if h1 <= 29 then
    	h1 = 58
    end
    if uph1 <= 29 then
    	uph1 = 58
    end
    if h2 <= 29 then
    	h2 = 58
    end
    if uph2 <= 29 then
    	uph2 = 58
    end

	self.bgSprite = display.newScale9Sprite(bgImage, 0, 0, cc.size(430, h1+uph1+h2+uph2))
    self:addChild(self.bgSprite)
    if h1+uph1 >134 and h2+uph2 >134 then
    	icon1:setPosition(60,(h1+uph1)/2+h2+uph2)
	    icon2:setPosition(60,(h2+uph2)/2+15)
	elseif h1+uph1 <134 and h2+uph2 <134 then
		icon1:setPosition(60,164)
	    icon2:setPosition(60,67)
	elseif h1+uph1 >134 and h2+uph2 <134 then
		icon1:setPosition(60,self.bgSprite:getContentSize().height-70)
	    icon2:setPosition(60,75)
	elseif h1+uph1 <134 and h2+uph2 >134 then
		icon1:setPosition(60,50+h2+uph2)
	    icon2:setPosition(60,(h2+uph2)/2+20)
    end
	self.bgSprite:addChild(icon1)
	self.bgSprite:addChild(icon2)
end

function SkillDesNode:createSkillIcon(file)
	local circle = display.newSprite(skillCircle)
	circle:setScale(0.7)

	local icon = display.newSprite(file)
	icon:setPosition(67,67)
	circle:addChild(icon)

	return circle
end

return SkillDesNode