local SaveTailsFormationResponse = class("SaveTailsFormationResponse")
function SaveTailsFormationResponse:SaveTailsFormationResponse(data)
	if data.result == 1 then 

	elseif data.result == -1 then 	-- 尾兽不存在
		showToast({text="尾兽不存在"})
	end 

end
function SaveTailsFormationResponse:ctor()
	--响应消息号
	self.order = 10062
	--返回结果,1 成功;-1 ，尾兽不存在
	self.result =  ""	
end

return SaveTailsFormationResponse