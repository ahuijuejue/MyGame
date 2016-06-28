local GiftExchangeResponse = class("GiftExchangeResponse")
function GiftExchangeResponse:GiftExchangeResponse(data)
	if data.result == 1 then 
		showToast({text="兑换成功，请在邮箱查询", time=5})
		UserData.haveMail = true 

	elseif data.result == -1 then 	-- 兑换码已使用过
		showToast({text="此兑换码不存在", time=5})
	elseif data.result == -2 then 	-- 兑换码已过期
		showToast({text="已过期", time=5})
	elseif data.result == -3 then 	-- 参数错误
		showToast({text="已使用过", time=5})
	elseif data.result == -4 then 	-- 网络超时，请重试
		showToast({text="网络超时，请重试", time=5})
	end 

end
function GiftExchangeResponse:ctor()
	--响应消息号
	self.order = 11002
	--返回结果,1 成功;-1此兑换码已兑完；-2 已过期,-3 参数错误，-4 网络超时，请重试
	self.result =  ""	
end

return GiftExchangeResponse