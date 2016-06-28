--[[
引导进入1-1
]]

local GuideFightBase = import(".GuideFightBase")
local GuideClass = class("GuideClass", GuideFightBase)

-- overwrite
function GuideClass:guideMainScene(targetScene)
	showAside({key = "10004",callback = function ()
		GuideClass.super.guideMainScene(self, targetScene)
	end})
end 

function GuideClass:guideReadyScene(targetScene, params, outparams)
	outparams.param100 = self.data.name

	targetScene.selectLayer_:setHeroList({})
	targetScene.selectLayer_:updateData()
	targetScene.selectLayer_:updateView()

	self:showSelectIndex(targetScene, 2, "12", function()
		self:showSelectIndex(targetScene, 1, "13", function()
			self:showSelectIndex(targetScene, 3, "14", function()
				self:showStartButton(targetScene)
			end)
		end)
	end)
end 

return GuideClass
