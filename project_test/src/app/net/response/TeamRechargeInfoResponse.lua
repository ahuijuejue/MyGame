local TeamRechargeInfoResponse = class("TeamRechargeInfoResponse")
function TeamRechargeInfoResponse:TeamRechargeInfoResponse(data)
   if data.result == 1 then
      local rechargeId = tostring(data.param1)   -- 充值类型 int id号
      local cardMsg = data.param2     -- 月卡信息
      local firstCard = data.param3   -- 首充状态

      -- 修改VIP经验
      local expMax = VipData:getVipExpMax()
      local addExp = GameConfig["Recharge"][rechargeId].Diamond
      local vipExp = UserData:getVipExp()+tonumber(addExp)
      UserData:setVip(vipExp)

      -- 修改充值钱数
      UserData:addV5Rmb(GameConfig["Recharge"][rechargeId].Rmb)

      -- 增加钻石数量
      local arr = GameConfig["Recharge"]
      local firstCard_ = UserData:getFirstBuy()
      local addDiamond = 0
      local rechargeActivity = tonumber(arr[rechargeId].Diamond)
      if arr[rechargeId].Limit == "1" then  --非月卡
         if firstCard_[rechargeId] == 0 then
            addDiamond = tonumber(arr[rechargeId].Diamond) + tonumber(arr[rechargeId].Sale)
         else
            addDiamond = tonumber(arr[rechargeId].Diamond) --非首充
         end
      else
         addDiamond = tonumber(arr[rechargeId].Diamond)
      end

      UserData:addDiamond(addDiamond)
      ActivityUtil.addParams("rechargeDiamond", rechargeActivity) -- 充值钻石

      UserData:setFirstBuy(firstCard)

      if cardMsg then
         UserData:setEndTime(cardMsg)
      end

      ActivityUtil.addParams("sumRechargeTimes", 1) -- 累计充值%s次
      if data.param4 then
         ActivityUtil.addParams("rechargeDays", data.param4[1]) -- 连续充值天数
      end

      if SignInData.vipIsReward == 0 then
         SignInData.vipIsReward = 1
      end

      if FlopModel then
         FlopModel:setCostMoney(FlopModel.costMoney + arr[rechargeId].Rmb)
      end

      if FeedbackModel then
         FeedbackModel:setRechargeValue(FeedbackModel.rechargeValue + arr[rechargeId].Rmb)
      end

      GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
      GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})

      showToast({text="充值成功！"})
   else
      showToast({text="未充值成功！"})
   end
end
function TeamRechargeInfoResponse:ctor()
	--响应消息号
	self.order = 40000
	--返回结果,1 成功;2 失败
	self.result =  ""
end

return TeamRechargeInfoResponse
