local ShowMainFrameResponse = class("ShowMainFrameResponse")

function ShowMainFrameResponse:ShowMainFrameResponse(data)
	if data.result == 1 then
		PlayerData.clean()
		PlayerData.updateGameData(data)

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	elseif data.result == 3 then
		hideLoading()
		showAlert(GET_TEXT_DATA("FRIEND_TIP"),"服务器正在维护。",{sure = function (alert)
	        hideAlert(alert)
	        GameConnection:disconnect()
	    end})
	end
end

function ShowMainFrameResponse:ctor()
	--响应消息号
	self.order = 10003
	--返回结果,如果成功才会返回下面的参数：1 成功,-3 服务器维护中,显示param1的信息
	self.result =  ""
	--战队id
	self.teamid =  ""
	--是否新用户，1，是，0，否
	self.isNew =  ""
	--金币
	self.gold =  ""
	--钻石
	self.diamond =  ""
	--vip等级
	self.viplevel =  ""
	--战队名
	self.name =  ""
	--战队等级
	self.exp =  ""
	--战队头像
	self.headSrc =  ""
	--体力
	self.power =  ""
	--抽卡积分
	self.choukaScore =  ""
	--竞技场币
	self.jingjiGold =  ""
	--竞技场积分
	self.jingjiScore =  ""
	--灵能值
	self.ling =  ""
	--城建币
	self.cityGold =  ""
	--技能点
	self.skillPower =  ""
	--公会币
	self.unionGold =  ""
	--神树币
	self.treeGold =  ""
	--购买体力的次数
	self.powerts =  ""
	--已购买的VIP礼包清单
	self.vipGiftList =  ""
	--首冲状态
	self.firstRechargeStatus =  ""
	--英雄列表
	self.a_param1 =  ""
	--背包数据
	self.a_param2 =  ""
	--每日任务完成度
	self.param1 =  ""
	--成就任务完成度
	self.param2 =  ""
	--已完成的每日任务id,多个以逗号分开
	self.param3 =  ""
	--已完成的成就任务，多人以逗号分开
	self.param4 =  ""
	--关卡信息
	self.a_param3 =  ""
	--服务器时间秒数
	self.param9 =  ""
	--封印总经验
	self.param10 =  ""
	--尾兽信息：id,id,id,_star,star,star,
	self.param11 =  ""
	--已兑换过的积分，多个以逗号分开
	self.param12 =  ""
	--尾兽阵形，多个尾兽以逗号分隔
	self.param13 =  ""
	--七天签到天数
	self.param14 =  ""
	--七天奖励最近领取的时间
	self.param15 =  ""
	--1 有未读取的邮件
	self.param16 =  ""
	--已过的新手引导
	self.param17 =  ""
	--上次上阵的英雄
	self.param18 =  ""
	--签到信息
	self.param19 =  ""
	--抽卡信息
	self.param20 =  ""
	--体力开始恢复的时间,时间是秒
	self.param21 =  ""
	--聊天服务器ip
	self.param22 =  ""
	--聊天服务器端口
	self.param23 =  ""
	--技能点开始恢复时间,秒
	self.param24 =  ""
	--已经购买的技能点次数
	self.param25 =  ""
	--城建信息：类型（1，主建筑,2 攻击，3 防御）_强化等级_星星数,类型（1，主建筑,2 攻击，3 防御）_强化等级_星星数
	self.param26 =  ""
	--活动信息
	self.param27 =  ""
	--通用活动进度信息
	self.param28 =  ""
	--充值信息
	self.param29 =  ""
	--神秘商店关闭时间，-1:永不关闭(VIP),0：已经关闭,其他：商店关闭时间(返回关闭时间戳)
	self.param30 =  ""
	--战力活动是否开启， 0：关闭,非0：活动到期时间
	self.param31 =  ""
	--打折商店开启状态 -1：未开启(已关闭),其他：关闭时间
	self.param32 =  ""
	--banner信息
	self.param33 =  ""
	--活动关闭时间,0:活动未开启或一结束,其他：剩余时间
	self.param34 =  ""
	--是否购买了开服基金
	self.param35 =  ""	
end

return ShowMainFrameResponse