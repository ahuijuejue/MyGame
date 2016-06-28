
local ArenaReadyScene = class("ArenaReadyScene", base.Scene)

function ArenaReadyScene:initData(options)	
	self.heroList_ = UserData:getArenaBattleList()
	self.otherTeam = options.otherTeam
	self.team = options.myTeam 
end 

function ArenaReadyScene:initView()
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)
	
	-- 选择层
	self.selectLayer_ = app:createView("readyplay.ArenaSelectHeroLayer"):addTo(self)
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
			base.Label.new({text="现在未满员出战，是否继续开始战斗？", size=20}):addTo(msg):align(display.CENTER):pos(0, 50)
			
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
		self:pop()
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
	
end 

function ArenaReadyScene:didStartGame()
	NetHandler.request("ArenaBegin", {
		onsuccess = function(data)	
			local hIds, heroList = self.selectLayer_:getHeroList()	
			UserData:setArenaBattleList(hIds)

			self.team:setRoleList(heroList) 

			app:enterScene("ArenaBattleScene", {{
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
									level = SealData:getSealLevel(), 			-- 封印等级 
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
	    								SceneData:pushScene("Arena", self)
	    							end,
	    		failedFunction 	= 	function()
	    								AudioManage.playMusic("Main.mp3",true)
	    								SceneData:pushScene("Arena", self)
	    							end,
			}})
		end
	}, self)
end

function ArenaReadyScene:updateView() 	
	local superCount, nextOpenLv = ArenaData:getSuperOpen(UserData:getUserLevel()) 	
	self.selectLayer_:setSuperCount(superCount) 
	if nextOpenLv then 
		self.superLabel_:setString(string.format("%d级开放第%d个变身位", nextOpenLv, superCount+1))
	else 
		self.superLabel_:setString("")
	end 
end 


return ArenaReadyScene