--
-- Author: zsp
-- Date: 2015-07-28 10:52:52
--

--兼容之前版本的接口替换动画库，在lua层的动画封装

local AnimWrapper = require("app.util.AnimWrapper")

AssetWrapper = class("AssetWrapper",function()
	return display.newNode()
end)

function AssetWrapper:ctor()
	--lua没提供析构 ，只能先注册node对象，在onExit中释放native中的引用计数
	self:setNodeEventEnabled(true)
	local scene = display.getRunningScene()
	if scene then
		self:addTo(scene)
	else
		self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
			local scene = display.getRunningScene()
			self:addTo(scene)
		end)))
	end
	
	--self:retain()
	
end

function AssetWrapper:create()
	return AssetWrapper.new()
end

function AssetWrapper:load(name,callback)
	--GAFAsset 是native对象 所以需要保持引用计数
	self.asset = gaf.GAFAsset:create(name,function(path)

		if callback then
			callback(path)
		end
	end)

	self.asset:retain()
	--printInfo("AssetWrapper:load================%s======%d",self.asset:getGAFFileName(),self.asset:getReferenceCount())
end

function AssetWrapper:makeAnimatedObject()
	local object = self.asset:createObject()
	return AnimWrapper.new(object,self.asset:getSceneWidth(),self.asset:getSceneHeight())
end

function AssetWrapper:onEnter()
	--self:release()
	--printInfo("AssetWrapper:onEnter===================")
end

function AssetWrapper:onExit()
	--self:release()
	if self.asset then
		--todo
		--printInfo("AssetWrapper:onExit1=========%s===========%d",self.asset:getGAFFileName(),self.asset:getReferenceCount())
		--printInfo("asset release")
		self.asset:release()
		--printInfo("AssetWrapper:onExit2=========%s===========%d",self.asset:getGAFFileName(),self.asset:getReferenceCount())
		self.asset = nil
	end

	--self:release()
end


return AssetWrapper