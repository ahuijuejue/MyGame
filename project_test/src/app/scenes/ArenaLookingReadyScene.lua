--[[
日月追缉 备战界面
]]

local ArenaLookingReadyScene = class("ArenaLookingReadyScene", base.Scene)

--[[
type 1:烈日追缉 2：皎月追缉
toScene 进入的战斗场景名
otherTeam 被挑战者 数据模型
myTeam 自己战队的信息
]]
function ArenaLookingReadyScene:initData(options)	
	self.playType = options.type or 1
	if self.playType == 1 then 
		self.heroList_ = UserData:getSunBattleList()
		self.sexType = 2 -- 排除性别
	else 
		self.heroList_ = UserData:getMoonBattleList()
		self.sexType = 1 -- 排除性别
	end 
	self.team = options.myTeam 
	self.otherTeam = options.otherTeam 
	self.toScene = options.toScene

end 

function ArenaLookingReadyScene:initView(options)
	
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)
	
	-- 选择层
	self.selectLayer_ = app:createView("readyplay.LookingForSelectLayer", {sexType=self.sexType}):addTo(self)
	:setHeroList(self.heroList_)
	:onTouch(function(event)
		local name = event.name 
		if name == "selected" then 
			self.startPlayBtn_:setButtonEnabled(true)
		elseif name == "unselected" then 
			if event.count <= 0 then 
				self.startPlayBtn_:setButtonEnabled(false)
			end 
		end 
		-- body
	end)

	-- 开始按钮
	self.startPlayBtn_ = CommonButton.start()
	:onButtonClicked(function(event)
		CommonSound.click() -- 音效
		print("kaishi")
		if self.selectLayer_:canSelected() then 			
			local msg = display.newNode():size(0, 100)
			base.Label.new({text="现在未满员出战，是否继续开始战斗？", size=20})
			:addTo(msg):align(display.CENTER):pos(0, 50)
			
			AlertShow.show2("友情提示", msg, "确定", function()
				self:didStartGame()
			end)
		else
			self:didStartGame()
		end 
	end)
	:addTo(self)
	:pos(display.cx + 400, 220)
	:zorder(10)
	:setButtonEnabled(false)

	-- 返回按钮
	CommonButton.back()
	:onButtonClicked(function(event)
		CommonSound.back() -- 音效
		app:popScene()
	end)
	:addTo(self)
	:pos(display.right - 90, display.top - 60)
	:zorder(10)

	-- label 变身数量
	self.superLabel_ = base.Label.new({
		color=cc.c3b(230,0,0),
		size = 20,
		})
	:addTo(self)
	:align(display.CENTER)
	:pos(display.cx, display.height-30)

	local flagname
	if self.playType == 1 then 
		flagname = "Wanted_Flag_Boy.png"
	else 
		flagname = "Wanted_Flag_Girl.png"
	end 

	display.newSprite(flagname)
	:addTo(self)
	:pos(display.cx - 400, 300)
	
end 

function ArenaLookingReadyScene:didStartGame() 	
	print("开始游戏")		
	
	local hIds, heroList = self.selectLayer_:getHeroList()	
	if self.playType == 1 then 
		UserData:setSunBattleList(hIds)
	else 
		UserData:setMoonBattleList(hIds)
	end 

	self.team:setRoleList(clone(heroList)) 
	self.team:setSealLevel(SealData:getSealLevel())

	app:enterScene(self.toScene, {{
		battleType 		= 	self.playType, -- 1:烈日追缉 2：皎月追缉
		heroIds 		= 	table.concat(hIds, ","), -- 英雄id，字符串逗号分开
		building 		= 	CityData:getBuilding(),
		seal_xing 		= 	SealData:getAttributeForBattle(),
		item          =   {},
	  	gold          =   0,
	  	skillValue    =   0,
	  	heroAppendExp =   0,
	  	teamTotalExp  =   UserData.totalExp,
	  	teamAppendExp =   0,

	  	left = { --己方
		    team 	  = clone(self.team:getRoleList()), 		-- 己方战队
		    tailSkill = {					
							level = self.team:getSealLevel(), 			-- 封印等级 
							skill = TailsData:getTailsSkillIdList(),	-- 尾兽技能id列表 
						},
		},
		right = { -- 对方
		    team 	  	= clone(self.otherTeam:getRoleList()), 	-- 对方战队
		    tailSkill 	= {					
							level = self.otherTeam:getSealLevel(), 			-- 封印等级 
							skill = self.otherTeam:getTailsSkillList(),		-- 尾兽技能id列表 
						},
		    userId 		= self.otherTeam.userId, 				-- 对方用户id 
		    teamId 		= self.otherTeam.teamId,				-- 对方战队id 
		},	
		winFunction 	= 	function()
								AudioManage.playMusic("Main.mp3",true)
								SceneData:pushScene("Wanted", self)
							end,
		failedFunction 	= 	function()
								AudioManage.playMusic("Main.mp3",true)
								SceneData:pushScene("Wanted", self)
							end,
	}})

end

function ArenaLookingReadyScene:updateView() 	
	local superCount, nextOpenLv = ArenaData:getSuperOpen(UserData:getUserLevel()) 	
	self.selectLayer_:setSuperCount(superCount) 
	if nextOpenLv then 
		self.superLabel_:setString(string.format("%d级开放第%d个变身位", nextOpenLv, superCount+1))
	else 
		self.superLabel_:setString("")
	end 

end 


return ArenaLookingReadyScene