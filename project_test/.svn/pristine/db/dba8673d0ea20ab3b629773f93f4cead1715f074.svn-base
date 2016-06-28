
local GuideNode = class("GuideNode", base.LinkNode)

function GuideNode:ctor(params)
	GuideNode.super.ctor(self, params)
	self.data = params
end

function GuideNode:makeGuide(targetScene, params, outparams)
	if self:makeGuide_(targetScene, params, outparams) then 
		return true 
	end 

	if self.nextNode then 
		return self.nextNode:makeGuide(targetScene, params, outparams)
	end 
	return false
end

-- overwrite
-- 引导操作
function GuideNode:makeGuide_(targetSceneName, params, outparams)
	return false
end

local sharedDirector = cc.Director:getInstance()
function GuideNode:getCurrentScene()
	return sharedDirector:getRunningScene()
end

return GuideNode 