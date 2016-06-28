local HeroEquipLayer = class("HeroEquipLayer",function ()
	return display.newNode()
end)

local EquipMainNode = import("..item.EquipMainNode")
local NodeBox = import("app.ui.NodeBox")
local CostNode = import("app.ui.CostNode")
local GameEquip = import("app.data.GameEquip")
local EquipListLayer = import("..item.EquipListLayer")
local EquipEnhanceLayer = import("..item.EquipEnhanceLayer")
local EquipMergeLayer = import("..item.EquipMergeLayer")
local HeroExtraNode = import(".HeroExtraNode")
local ExtraInfoLayer = import(".ExtraInfoLayer")
local ItemDropLayer = import("..item.ItemDropLayer")

local bgImage = "bg_002.png"
local strenImage1 = "GearPlusAll_Button.png"
local strenImage2 = "GearPlusAll_Button_Light.png"
local strenImage3 = "GearPlusAll_Button_Gray.png"
local awakeBg = "Awake_Shading.png"
local cashImage = "Gold.png"
local closeImage = "Close.png"

function HeroEquipLayer:ctor(hero)
	self.hero = hero
	self.equipInfo = GameConfig.hero_equip[self.hero.roleId]

	self:createBoard()

	local equipView = self:createEquipView()
	equipView:setPosition(574,368)
	self:addChild(equipView)

	self:createAllStrenBtn()
	self:createExtraBtn()
end

function HeroEquipLayer:createBoard()
	local bgSprite = display.newSprite(bgImage)
	bgSprite:setPosition(438,336)
	self:addChild(bgSprite)

	self.board = display.newSprite(awakeBg)
	self.board:setPosition(438,92)
	self:addChild(self.board)
end

function HeroEquipLayer:createEquipView()
	self.equipNodes = {}
	for i=1,#self.hero.equip do
		local node = EquipMainNode.new()
		node:setCallBack(function ()
			AudioManage.playSound("Click.mp3")
			if i == 1 and not OpenLvData:isOpen("equip") then
				local param = {text = "战队"..OpenLvData.equip.openLv.."级开启",size = 30,color = display.COLOR_RED}
	            showToast(param)
				return
			end
			self.selectIndex = i
			if self.hero.equip[i] == 0 then
				local canEquip = GamePoint.heroCanEquip(i,self.hero)
				if i == 1 and not canEquip then
					self:showMergeLayer()
				else
					self:showEquipListView()
				end
			else
				self:showEquipInfo(i)
			end
		end)
		if i == 1 then
			node:createMark()
		end
		table.insert(self.equipNodes,node)
	end

	local nodeBox = NodeBox.new()
	nodeBox:setCellSize(cc.size(172,135))
	nodeBox:setSpace(3,7)
	nodeBox:setUnit(3)
	nodeBox:addElement(self.equipNodes)
	return nodeBox
end

function HeroEquipLayer:updateEquipView()
	for i=1,#self.hero.equip do
		if self.hero.equip[i] == 0 then
			local canEquip = GamePoint.heroCanEquip(i,self.hero)
			self.equipNodes[i].point:setVisible(canEquip)

			local key = string.format("GearItemID%d",i)
			local equipIds = self.equipInfo[key]
			local tempEquip = GameEquip.new({itemId = equipIds[1]})
			self.equipNodes[i]:updateNode(tempEquip)
			tempEquip = nil

			if not canEquip then
				if i == 1 then
					self.equipNodes[i].point:setVisible(GamePoint.matEnough(equipIds[1]))
				end
			end
		else
			self.equipNodes[i].arrowSprite:setVisible(GamePoint.equipCanAdv(self.hero.equip[i]))
			self.equipNodes[i].point:setVisible(GamePoint.equipCanPlus(self.hero,self.hero.equip[i]))
			self.equipNodes[i]:updateNode(self.hero.equip[i])
		end
		if i == 1 then
			if OpenLvData:isOpen("equip") then
				self.equipNodes[i]:removeLock()
			else
				self.equipNodes[i]:createLock()
			end
		end
	end
	if self.delegate then
		self.delegate:updatePoint(2,GamePoint.heroEquipCanUpdate(self.hero))
	end

	self:setCostLabel()
	self:setExtraNodeValue()

	if self.infoLayer then
	    self.infoLayer:updateInfo()
	end

	if self.mergeLayer then
		self.mergeLayer:updateView()
	end
end

--显示可装备列表
function HeroEquipLayer:showEquipListView(tag)
	local key = string.format("GearItemID%d",self.selectIndex)
	local equipIds = self.equipInfo[key]
	local equips = ItemData:getEquipList(equipIds)
	local sortFunc = function (a,b) return a.power > b.power end
	table.sort(equips,sortFunc)

	if #equips > 0 or tag then
		self.listLayer = EquipListLayer.new(equips)
		self.listLayer.delegate = self
		display.getRunningScene():addChild(self.listLayer,5)
	else
		local item = ItemData:getItemConfig(equipIds[1])
	    self:showDropLayer(item)
	end
end

--移除可装备列表
function HeroEquipLayer:removeEquipListLayer()
	self.listLayer:removeFromParent(true)
	self.listLayer = nil
end

function HeroEquipLayer:showDropLayer(item)
	local colorLayer = display.newColorLayer(cc.c4b(0,0,0,100))
	display.getRunningScene():addChild(colorLayer,5)

	local dropLayer = ItemDropLayer.new(item)
    dropLayer:setPosition(display.cx,display.cy)
    colorLayer:addChild(dropLayer)
    dropLayer:setScale(0.3)
    local seq = transition.sequence({
        cc.ScaleTo:create(0.15, 1.15),
        cc.ScaleTo:create(0.05, 1)
        })
    dropLayer:runAction(seq)

    local closeBtn = cc.ui.UIPushButton.new({normal = closeImage, pressed = closeImage})
	:onButtonClicked(function ()
		AudioManage.playSound("Close.mp3")
		colorLayer:removeFromParent(true)
		colorLayer = nil
		dropLayer = nil
		closeBtn = nil
	end)
	closeBtn:setPosition(240,100)
	dropLayer:addChild(closeBtn)
end

--显示专属装备合成界面
function HeroEquipLayer:showMergeLayer()
	local key = string.format("GearItemID%d",1)
	local equipIds = self.equipInfo[key]
	local equip = GameEquip.new({itemId = equipIds[1]})

	self.mergeLayer = EquipMergeLayer.new(equip)
	self.mergeLayer.delegate = self
	display.getRunningScene():addChild(self.mergeLayer,5)
	equip = nil
end

--移除专属装备合成界面
function HeroEquipLayer:removeMergeLayer()
	if self.mergeLayer then
		self.mergeLayer:removeFromParent(true)
		self.mergeLayer = nil
	end
end

--装备查看
function HeroEquipLayer:showEquipInfo(index)
	local equips = {}
	for i,v in ipairs(self.hero.equip) do
		if v ~= 0 then
			table.insert(equips,v)
		end
	end
	index = self.hero.equip[index]
	
	self.infoLayer = EquipEnhanceLayer.new(equips,table.indexof(equips,index),self.hero)
	self.infoLayer.delegate = self
	display.getRunningScene():addChild(self.infoLayer,5)

	CommonView.animation_show_out(self.infoLayer)
end

function HeroEquipLayer:removeEquipInfo()
	if self.infoLayer then
		self.infoLayer:removeFromParent(true)
		self.infoLayer = nil
	end
end

--增加英雄装备
function HeroEquipLayer:updateHeroEquip(equip)
	local heroId = self.hero.roleId
	local pos = self.selectIndex
	local uniqueId = equip:getLastUid()

	if self.hero.equip[self.selectIndex] ~= 0 then
		local uniqueId2 = self.hero.equip[self.selectIndex]:getLastUid()
		local param = {param1 = heroId, param2 = uniqueId2, param3 = uniqueId, param4 = pos}
		NetHandler.gameRequest("ReplaceEquip",param)
	else
		local param = {param1 = heroId,param2 = uniqueId,param3 = pos}
		NetHandler.gameRequest("BeginUseEquip",param)
	end
end

--卸下英雄装备
function HeroEquipLayer:removeHeroEquip(equip)
	local uniqueId = equip:getLastUid()
	local pos = self.selectIndex
	local heroId = self.hero.roleId
	local param = {param1 = uniqueId, param2 = pos, param3 = heroId}
	NetHandler.gameRequest("UnloadEquip",param)
end

--强化英雄当前装备
function HeroEquipLayer:strenHeroEquip(equip,type_)
	local heroId = self.hero.roleId
	local uniqueId = equip:getLastUid()
	local times = 0
	if type_ == 1 then
		times = 1
	elseif type_==2 then
		times = 10
	end
	local param = {param1 = heroId, param2 = uniqueId, param3 = times}
	NetHandler.gameRequest("QiangHuaEquip",param)
end

--进阶英雄当前装备
function HeroEquipLayer:advHeroEquip(equip)
	local heroId = self.hero.roleId
	local uId = equip:getLastUid()
	local iId = equip.itemId
	local param = {param1 = uId, param2 = iId, param3 = heroId}
	NetHandler.gameRequest("JinjieEquip",param)
end

--专属装备合成
function HeroEquipLayer:mergeHeroEquip()
	NetHandler.gameRequest("AssemblyEquip",{param1 = self.hero.roleId})
end

--加护装备
function HeroEquipLayer:plusHeroEquip(equip)
	NetHandler.gameRequest("JiahuEquip",{param1 = self.hero.roleId, param2 = equip:getLastUid()})
end

--强化所有装备
function HeroEquipLayer:strenAllEquip(type_)
	local heroId = self.hero.roleId
	local times = 0
	if type_ == 1 then
		times = 1
	elseif type_ == 2 then
		times = 10
	end
	local param = {param1 = heroId, param3 = times}
	NetHandler.gameRequest("QiangHuaEquip",param)
end

--创建全部强化按钮
function HeroEquipLayer:createAllStrenBtn()
	local btnParam = {normal = strenImage1, pressed = strenImage2, disabled = strenImage3}
	local labelParam = {text = GET_TEXT_DATA("TEXT_ALL_STR"),color = display.COLOR_WHITE, size = 22}

	self.strenBtn1 = CostNode.new(btnParam,labelParam,cashImage)
	self.strenBtn1:setPosition(490,195)
	self.strenBtn1:onButtonClicked(function ()
		AudioManage.playSound("Click.mp3")
		local cost = GamePoint.heroAllStrenCost(self.hero,1)
		if cost > UserData.gold then
			local param = {text = GET_TEXT_DATA("MONEY_NOT_ENOUGH"),size = 30,color = display.COLOR_RED}
    		showToast(param)
		else
			self:strenAllEquip(1)
		end
	end)
	self:addChild(self.strenBtn1)

	labelParam = {text = "",color = display.COLOR_WHITE, size = 22}
	self.strenBtn2 = CostNode.new(btnParam,labelParam,cashImage)
	self.strenBtn2:setPosition(750,195)
	self.strenBtn2:onButtonClicked(function ()
		AudioManage.playSound("Click.mp3")
		local cost = GamePoint.heroAllStrenCost(self.hero,2)
		if cost > UserData.gold then
			local param = {text = GET_TEXT_DATA("MONEY_NOT_ENOUGH"),size = 30,color = display.COLOR_RED}
    		showToast(param)
		else
			self:strenAllEquip(2)
		end
	end)
	self:addChild(self.strenBtn2)
end

function HeroEquipLayer:setCostLabel()
	local heroLv = self.hero.level
	local costNum = GamePoint.heroAllStrenCost(self.hero,1)
	local allCostNum = GamePoint.heroAllStrenCost(self.hero,2)
	local times = {}
	for i=1,#self.hero.equip do
		if self.hero.equip[i] ~= 0 then
			table.insert(times,self.hero.equip[i]:getUpTimes(heroLv))
		end
	end
	if costNum > UserData.gold then
		self.strenBtn1:setColor(display.COLOR_RED)
	else
		self.strenBtn1:setColor(display.COLOR_WHITE)
	end
	if allCostNum > UserData.gold then
		self.strenBtn2:setColor(display.COLOR_RED)
	else
		self.strenBtn2:setColor(display.COLOR_WHITE)
	end
	if costNum ~= 0 then
		self.strenBtn1:setButtonEnabled(true)
	else
		self.strenBtn1:setButtonEnabled(false)
	end
	if allCostNum ~= 0 then
		self.strenBtn2:setButtonEnabled(true)
	else
		self.strenBtn2:setButtonEnabled(false)
	end
	self.strenBtn1:setString(costNum)
	self.strenBtn2:setString(allCostNum)
	local count = 0
	if #times > 0 then
		count = math.max(unpack(times))
	end
	self.strenBtn2:setButtonLabelString(string.format(GET_TEXT_DATA("TEXT_ALL_STR_5"),count))
end

--创建加成按钮
function HeroEquipLayer:createExtraBtn()
	self.extraNode1 = HeroExtraNode.new(GET_TEXT_DATA("TEXT_STREN_EXTRA"))
	self.extraNode1:setNodeCallback(function ()
		AudioManage.playSound("Click.mp3")
		self:showExtraInfoLayer(1)
	end)
	self.extraNode2 = HeroExtraNode.new(GET_TEXT_DATA("TEXT_ADV_EXTRA"))
	self.extraNode2:setNodeCallback(function ()
		AudioManage.playSound("Click.mp3")
		self:showExtraInfoLayer(2)
	end)
	self.extraNode3 = HeroExtraNode.new(GET_TEXT_DATA("TEXT_HOLD_EXTRA"))
	self.extraNode3:setNodeCallback(function ()
		AudioManage.playSound("Click.mp3")
		self:showExtraInfoLayer(3)
	end)

	local extraNodes = {self.extraNode1,self.extraNode2,self.extraNode3}
	local nodeBox = NodeBox.new()
	nodeBox:setUnit(3)
	nodeBox:setCellSize(cc.size(254,120))
	nodeBox:addElement(extraNodes)
	nodeBox:setPosition(401,63)
	self.board:addChild(nodeBox)
end

function HeroEquipLayer:showExtraInfoLayer(tag)
	local infoLayer = ExtraInfoLayer.new()
	infoLayer:setInfo(self.hero,tag)
	display.getRunningScene():addChild(infoLayer,5)
end

function HeroEquipLayer:setExtraNodeValue()
	local strLv = HeroAbility.getStrenLv(self.hero)
	if strLv ~= 0 then
		local types = self.equipInfo.Strengthen_type
		local values = {}
		for i=1,#types do
			local baseValue = self.equipInfo.Strengthen_value[i]
			table.insert(values,baseValue*strLv)
		end
		self.extraNode1:setValues(types,values)
	else
		self.extraNode1:setValues()
	end

	local advLv = HeroAbility.getAdvLv(self.hero)
	if advLv ~= 0 then
		local types = string.split(self.equipInfo["Quality_type"][advLv],":")
		local values = string.split(self.equipInfo["Quality_value"][advLv],":")
		self.extraNode2:setValues(types,values)
	else
		self.extraNode2:setValues()
	end

	local plusLv = HeroAbility.getPlusLv(self.hero)
	if plusLv ~= 0 then
		local types = self.equipInfo.Equip_up_type
		local values = {}
		for i=1,#types do
			local baseValue = self.equipInfo.Equip_up_value[i]
			table.insert(values,baseValue*plusLv)
		end
		self.extraNode3:setValues(types,values)
	else
		self.extraNode3:setValues()
	end
end

return HeroEquipLayer