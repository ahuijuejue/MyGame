local OpenSkillFrameResponse = class("OpenSkillFrameResponse")
function OpenSkillFrameResponse:OpenSkillFrameResponse(data)


end
function OpenSkillFrameResponse:ctor()
	--响应消息号
	self.order = 10016
	--返回结果,如果成功才会返回下面的参数：1 成功,
	self.result =  ""
	--已经学习的技能和id,格式：id_level,id_level
	self.param1 =  ""
	--英雄名镶嵌的信息：格式：碎片id_已镶嵌的个数,碎片id_已镶嵌的个数
	self.param2 =  ""	
end

return OpenSkillFrameResponse