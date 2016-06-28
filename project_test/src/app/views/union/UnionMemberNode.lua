local UnionMemberNode = class("UnionMemberNode",function ()
	return display.newNode()
end)

local boardImage = "Arena_Enermy_Banner_.png"
local dpsImage = "Job_Dps.png"
local tankImage = "Job_T.png"
local aidImage = "Job_Assistant.png"
local stoneBarBg = "Stone_Bar.png"
local stoneImage = "Stone.png"
local expImage = "ExpMode_Slip.png"
local avatarBgImage = "HeroCircle%d.png"
local jobImage = "Job_Circle.png"
local pointImage = "Point_Red.png"

function UnionMemberNode:ctor(memberData, index)
	self.memberData = memberData
	self.index = index
	self:createUnionMemberNode()
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(false)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,handler(self,self.nodeOnTouch))
	self:addNodeEventListener(cc.NODE_EVENT,function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)
end

function UnionMemberNode:createUnionMemberNode()
	self.boardSprite = display.newSprite(boardImage)
	self.boardSprite:setAnchorPoint(0,0)
	self:addChild(self.boardSprite)

    self:createDuty()
    self:createHeadIcon()
    self:createMemberInfo()
end

-- 公会中职位
function UnionMemberNode:createDuty()
    self.memberDuty = createOutlineLabel({text = "", color = cc.c3b(255, 231, 96), size = 24})
    local duty = ""
    if self.memberData.duty == "1" then
    	if self.memberData.vipLevel ~= "0" then
    		duty = "会长 vip"..self.memberData.vipLevel
    	else
    		duty = "会长"
    	end
    elseif self.memberData.duty == "2" then
    	if self.memberData.vipLevel ~= "0" then
    		duty = "副会长 vip"..self.memberData.vipLevel
    	else
    		duty = "副会长"
    	end
    elseif self.memberData.duty == "3" then
    	if self.memberData.vipLevel ~= "0" then
    		duty = "管理员 vip"..self.memberData.vipLevel
    	else
    		duty = "管理员"
    	end
    end
    self.memberDuty:setString(duty)
    self.memberDuty:pos(90,255)
    self.memberDuty:addTo(self.boardSprite)
end

-- 头像 等级
function UnionMemberNode:createHeadIcon()
	-- 头像
    local sprite = display.newSprite("Mail_Circle.png"):pos(90,175):addTo(self.boardSprite)
	base.Grid.new():pos(90,175)
	:addItem(display.newSprite(self.memberData.headIcon))
	:onTouch(function(event)
		local point = {x = event.x, y = event.y}
		local point_ = sprite:convertToNodeSpace(point)
		if event.name == "began" then
			self:showTeam( point_.y , event.y)
		elseif event.name == "ended" then
			self:hideTeam()
		end
	end, cc.size(130, 130))
	:addTo(self.boardSprite)

    -- 等级
    display.newSprite("Banner_Level.png"):pos(40,207):scale(0.9):addTo(self.boardSprite):zorder(2)
	base.Label.new({text = self.memberData.level, size=18}):align(display.CENTER):pos(40,207):addTo(self.boardSprite):zorder(3)
end

function UnionMemberNode:showTeam(posY, posY_)
	if not self.teamLayer_ then
		self.teamView_ = {}
		local node = display.newNode():addTo(self.delegate):zorder(15)
		display.newSprite("Defence_Show.png"):addTo(node)

		-- 通过公式计算
		local otherLevel = tonumber(self.memberData.level)
		local ownLevel = GameExp.getUserLevel(tonumber(UserData.totalExp))
		local unionPower = math.floor(math.min(9, math.max(3, 6+(otherLevel-ownLevel)/3)))
		local unionExp = math.floor(math.min(6, math.max(1, 3+(otherLevel-ownLevel)/3)))
		local unionGold = math.floor(math.min(6, math.max(1, 3+(otherLevel-ownLevel)/3)))
		node:addChild(createOutlineLabel({text = "获胜奖励:", size = 16}):pos(190,38))
		node:addChild(createOutlineLabel({text = "公会体力+"..tostring(unionPower), size = 16}):pos(190,13))
		node:addChild(createOutlineLabel({text = "公会经验+"..tostring(unionExp), size = 16}):pos(190,-12))
		node:addChild(createOutlineLabel({text = "公会币+"..tostring(unionGold), size = 16}):pos(190,-37))

		for i=1,5 do
			local grid = base.Grid.new():addTo(node):pos(i * 78 - 290, 0):scale(0.6)
			if i == 1 then grid:scale(0.8) end

			table.insert(self.teamView_, grid)
		end
		self.teamLayer_ = node
	end

	local posX = display.cx + ( (self.index-1)%4 - 2.5) * 100 + 50
	self.teamLayer_:show():pos(posX, posY_ + 200- posY)

	for i,v in ipairs(self.memberData.heros) do
		local grid = self.teamView_[i]
		grid:addItems({
			display.newSprite(v:getIcon()):zorder(2):scale(0.8), 	-- 队员头像
			display.newSprite(v:getBorder()):scale(0.8), 			-- 头像边框
			display.newSprite("Banner_Level.png"):pos(-40, 40):zorder(3):scale(0.8),
			base.Label.new({text=tostring(v.level), size=24, color=cc.c3b(250,250,250)}):align(display.CENTER):pos(-40, 40):zorder(4):scale(0.8),
			createStarIcon(v.starLv):pos(-50, -30):zorder(5):scale(0.8),
		})
	end
end

function UnionMemberNode:hideTeam()
	if self.teamLayer_ then
		for i,v in ipairs(self.teamView_) do
			v:removeItems()
		end
		self.teamLayer_:hide()
	end
end

-- 名称 战力 挑战按钮
function UnionMemberNode:createMemberInfo()
	self.memberName = display.newTTFLabel({text = self.memberData.name, color = cc.c3b(255, 231, 96), size = 22})
    self.memberName:pos(90,105)
    self.memberName:addTo(self.boardSprite)

    self.memberPower = display.newTTFLabel({text = self.memberData.combat, color = cc.c3b(255, 231, 96), size = 22})
    self.memberPower:pos(115,76)
    self.memberPower:addTo(self.boardSprite)

    self.fightBtn = CommonButton.yellow("挑战", {color = cc.c3b(252, 242, 181), size = 24})
    :onButtonClicked(function ()
    	if self.delegate.times > 0 then
    		-- 进入准备战斗界面
    		app:pushScene("UnionReadyScene", {{
				otherTeam 	= self.memberData,  -- 保存的对方战队
			}})
    	else
    	    -- 购买挑战次数
    		self:alertBuyTimes()
    	end
        print("挑战按钮")
    end)
    :pos(85, 32)
    :addTo(self.boardSprite)

end

function UnionMemberNode:alertBuyTimes()
	if UserData.diamond < UnionListData:getCostForBuyTimes() then  -- 购买次数需要的钻石数 是否读表
        GemsAlert:show()
    else
        if UnionListData.buyTimes <= VipData:getUnionArenaTimeMax() then
            local msg = {
                base.Label.new({text="是否花费", size=22}):pos(30, 150),
                base.Label.new({text=string.format("x%d来购买%d次", UnionListData.timesCost, 1), size=22}):pos(200, 150),
                base.Label.new({text="挑战次数", size=22}):pos(200, 110):align(display.CENTER),
                display.newSprite("Diamond.png"):pos(150, 150),
            }

            AlertShow.show2("友情提示", msg, "确定", function( ... )
                NetHandler.gameRequest("UnionCombatTime")
            end)
        else
            showToast({text = "购买次数已达上限！"})
            app:pushScene("RechargeScene")
        end
    end
end

function UnionMemberNode:nodeOnTouch(event)
	local  point = {x = event.x, y =event.y}
	if event.name == "began" then

	elseif event.name == "moved" then

	elseif event.name == "ended" then

	end
end

function UnionMemberNode:updateData()
	-- body
end

function UnionMemberNode:updateView()
	self:updateBattleNum()
end

function UnionMemberNode:onEnter()
end

function UnionMemberNode:onExit()
end

return UnionMemberNode
