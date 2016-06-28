local MailReadResponse = class("MailReadResponse")
function MailReadResponse:MailReadResponse(data)
	if data.result == 1 then 
		local mailId = data.param1
		local items  = data.a_param1 or {}
		
		local mail = MailData:getMail(mailId) 
		MailData:addReadMail(mail)

		-- 是否还有未读邮件 
		local list = MailData:getMails()
		local nList = table.nums(list) 
		UserData:setHaveMail(nList > 0)


--------------------------------------------------------------
-- 领取奖励前数据
		local power1 = UserData.power 			-- 升级前 体力
		local exp1 = UserData.totalExp  		-- 之前 经验值		
		local level1 = UserData:getUserLevel()	-- 之前 等级
		
--------------------------------------------------------------
-- 增加奖励物品
		PlayerData.addItem(items)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
--------------------------------------------------------------
-- 领取奖励后数据
		local exp2 = UserData.totalExp			-- 之后 经验值 
		local level2 = UserData:getUserLevel() 	-- 之后 等级
		local addLevel = level2 - level1 		-- 增加等级
		
--------------------------------------------------------------
		local levelUpData 
		if addLevel > 0 then  -- 升级了
			-- 升级奖励体力 
			UserData:addPower(GlobalData.addPower * addLevel)
			power2 = UserData.power 			-- 升级后 体力

			levelUpData = {
				teamTotalExp 	= 	exp1,
				teamAppendExp 	= 	exp2 - exp1,
			}

			-- 显示升级数据
			levelUpData.levelUp = {
				power1 = power1, 				-- 升级前 体力
				power2 = UserData.power, 		-- 升级后 体力
				powerMax1 = GameExp.getLimitPower(exp1), 		-- 升级前 体力上限
				powerMax2 = GameExp.getLimitPower(exp2),			-- 升级后 体力上限
				levelMax1 = GameExp.getHeroLimitLv(exp1), 			-- 升级前 英雄等级上限
				levelMax2 = GameExp.getHeroLimitLv(exp2), 			-- 升级后 英雄等级上限
			}
		end 

		local showItems = UserData:parseItems(items)
		return {mailId=mailId, items=showItems, levelUp = levelUpData}
		
	elseif data.result == 2 then 
		-- 邮件过期
		showToast({text="邮件过期"})
	end 

end
function MailReadResponse:ctor()
	--响应消息号
	self.order = 10012
	--返回结果,如果成功才会返回下面的参数：1 成功,
	self.result =  ""
	--邮件onlyid
	self.param1 =  ""	
end

return MailReadResponse