local OpenJueXingFrameResponse = class("OpenJueXingFrameResponse")
function OpenJueXingFrameResponse:OpenJueXingFrameResponse(data)


end
function OpenJueXingFrameResponse:ctor()
	--响应消息号
	self.order = 10022
	--返回结果,1 成功
	self.result =  ""
	--觉醒镶嵌的宝石信息，格式：pos,itemid_pos,itemid(位置,物品id)
	self.param1 =  ""
	--药水的有效时间：物品id,剩余时间_物品id,剩余时间
	self.param2 =  ""	
end

return OpenJueXingFrameResponse