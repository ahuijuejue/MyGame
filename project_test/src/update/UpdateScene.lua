-- local serverUrl = "http://182.92.238.147/gm/hahahero/"..device.platform.."/"
local serverUrl = "http://183.57.57.161:8088/gm/hahahero/"..device.platform.."/"

local UpdateScene = class("UpdateScene", function()
    return display.newScene("UpdateScene")
end)

local UpdateLayer = import(".UpdateLayer")
local SliderLayer = import(".SliderLayer")
local UpdateScript = import(".UpdateScriptN")
local UpdateResource = import(".UpdateResourceN")

function UpdateScene:ctor()
	local path1 = device.writablePath.."ress/images/Update"
	local path2 = "res/images/Update"
	cc.FileUtils:getInstance():addSearchPath(path1)
	cc.FileUtils:getInstance():addSearchPath(path2)

	local background = display.newSprite("Update_Background.jpg")	
	:center()
	:addTo(self)

	self.labelShow_ = self:label("检测更新中", 30):addTo(self):pos(display.cx, 80):align(display.CENTER)
	self.labelError_ = self:label("", 30):addTo(self):align(display.CENTER):pos(display.cx, display.cy - 100)
	self.processLabel_ = self:label("", 30):addTo(self):pos(display.cx + 90, 80)

    self.baseSize = 0 
    self.totalSize = 0

    self.isUpdateCode = false 
    self.isUpdateRes = false 

    self.index = 0
    self.totalIndex = 0

-- 更新通知层
    self.infoLayer_ = UpdateLayer.new()
    :addTo(self)
    :center()
    :hide()
    :onEvent(function(event)
    	if event.name == "clicked" then 
			self:onButtonOk(event)
		end 
	end)

-- 进度条
	self.sliderLayer_ = SliderLayer.new()
	:addTo(self)
	:pos(display.cx, 40)
	:hide()

    self.updateCode_ = UpdateScript.new({
    	server = serverUrl.."srcc/",
    	filename = "flist",
		path = "srcc/", 
		localpath = "res/plist/code/",
    })
    :onEvent(function(event)
    	if event.name == "error" then 
			-- print("error:", event.msg)
			self:showError(event.msg.."代码")
		end 
    end)

    self.updateRes_ = UpdateResource.new({
    	server = serverUrl.."ress/",
    	filename = "flist",
		path = "ress/", 
		localpath = "res/plist/res/",
    })
    :onEvent(function(event)
    	if event.name == "error" then 
			-- print("error:", event.msg)
			self:showError(event.msg.."资源")
		end 
    end)

end 

function UpdateScene:label(text, labelSize, color, params)
	params = params or {}	
	params.text = text or ""
	params.size = labelSize or 20
	params.color = color or cc.c3b(255,255,255)
	return cc.ui.UILabel.new(params)
end 

function UpdateScene:setSliderProcess(value, maxValue) 
	local per = 0 
	if maxValue ~= 0 then 
		per = value / maxValue
	end 

	self.slider_:setPercentage(math.min(per * 100, 100))
end 

function UpdateScene:showLabel(text)
	self.labelShow_:setString(text)
end

function UpdateScene:showLabelProcess(text)
	self.processLabel_:setString(text)
end

function UpdateScene:showCheckProcess(value, maxValue)
	local per = 0 
	if maxValue ~= 0 then 
		per = value / maxValue * 100
	end 
	local text= string.format("%.1f%%", per)
	self:showLabelProcess(text)
end
-- 
function UpdateScene:showError(text)
	local str = "网络错误！游戏即将退出！"
	device.showAlert("提示", str, "确定", function()		
		self:exit()	
	end)
end

function UpdateScene:onEnter()
	self:updateCode()
	-- self:updateRes()	
end

function UpdateScene:enterGame()
	require("app.GameInit")
	
	if not app then
		require("app.MyApp").new():run()
	end
	app:enterToScene("StartScene")
end

------------------------------------- 更新代码 ---------------------------------
function UpdateScene:updateCode()
	if not self.updateCode_:loadConfig() then
		return false 
	end 

	self.updateCode_:downloadConfig(function(event)
		if event.isNew then 
			-- print("有代码更新")
			self.isUpdateCode = true 
			event.target:checkLoadList()
			self:downloadCodeConfigEnd()
		else 
			-- print("没有代码更新")
			event.target:removeConfig()
			self:updateRes()
		end 
	end)
end 

function UpdateScene:downloadCodeConfigEnd()
	-- 检测文件总数
	self.totalIndex = self.totalIndex + self.updateCode_:getLoadListCount()

	self:updateRes()
end 

function UpdateScene:checkCode()
	if self.isUpdateCode then 
		self.updateCode_:checkDownloadList(function(event)
			if event.name == "process" then 
				self:checkCodeProcess(event)
			elseif event.name == "completed" then 
				self:checkCodeEnd(event)
			end 
		end)
	else 
		self:checkRes()
	end 
end 

function UpdateScene:checkCodeProcess(event)
	-- print(string.format("process:%d/%d", self.index + event.index, self.totalIndex))
	self:showCheckProcess(self.index + event.index, self.totalIndex)
end 

function UpdateScene:checkCodeEnd(event)
	self.baseSize = self.baseSize + event.downSize 
    self.totalSize = self.totalSize + event.totalSize 

    self.index = self.index + self.updateCode_:getLoadListCount()

    self:checkRes()

end 

function UpdateScene:downloadCode()
	-- print("downloadCode()")
	self.updateCode_:downloadFiles(function(event)
		if event.name == "process" then 
			self:downloadCodeProcess(event)
		elseif event.name == "completed" then 
			self:downloadCodeCompleted(event)
		end 
	end)
end 

function UpdateScene:downloadCodeProcess(event)
	local downSize = event.downSize 
	local totalSize = event.totalSize 
	downSize = FL.convertByteToMb(downSize)
	totalSize = FL.convertByteToMb(totalSize)

	self.sliderLayer_:setProcess(downSize, totalSize)
end

function UpdateScene:downloadCodeCompleted(event)
	-- print("下载完成")
	self:replaceCodeFile()
end

function UpdateScene:replaceCodeFile()
	-- print("replaceCodeFile")
	self.updateCode_:replaceFiles()
	self.updateCode_:replaceCofig()

	self:replaceCodeFileEnd()
end

function UpdateScene:replaceCodeFileEnd()
	-- print("文件替换完成")
	self:loadCode()
end 

-- 加载代码文件
function UpdateScene:loadCode()
	-- print("loadCode")
	self.updateCode_:loadSource(function()
		self:loadCodeEnd()
	end)	
end 

function UpdateScene:loadCodeEnd()
	-- print("加载代码文件完成")
	self:toDownloadRes()
end 

function UpdateScene:toDownloadCode()
	-- print("toDownloadCode")
	if self.isUpdateCode then 
		self:downloadCode()
	else 
		self:loadCode()
	end
end 
------------------------------------------------------------------------

------------------------------------- 更新资源 ---------------------------------
function UpdateScene:updateRes()
	if not self.updateRes_:loadConfig() then
		return false 
	end 

	self.updateRes_:downloadConfig(function(event)
		if event.isNew then 
			-- print("有资源更新")
			self.isUpdateRes = true 
			event.target:checkLoadList()
			self:downloadResConfigEnd()
		else 
			-- print("没有资源更新")
			event.target:removeConfig()
			self:checkCode()
		end 
	end)
end 

function UpdateScene:downloadResConfigEnd()
	-- 检测文件总数
	self.totalIndex = self.totalIndex + self.updateRes_:getLoadListCount()

	self:checkCode()
end 

function UpdateScene:checkRes()
	if self.isUpdateRes then 		
		self.updateRes_:checkDownloadList(function(event)
			if event.name == "process" then 
				self:checkResProcess(event)
			elseif event.name == "completed" then 
				self:checkResEnd(event)
			end 
		end)
	else 
		self:showInfoLayer()
	end 
end 

function UpdateScene:checkResProcess(event)
	-- print(string.format("process:%d/%d", self.index + event.index, self.totalIndex))
	self:showCheckProcess(self.index + event.index, self.totalIndex)
end 

function UpdateScene:checkResEnd(event)
	self.baseSize = self.baseSize + event.downSize 
    self.totalSize = self.totalSize + event.totalSize 

    self:showInfoLayer()
end 

function UpdateScene:downloadRes()
	-- print("downloadRes")
	self.updateRes_:downloadFiles(function(event)
		if event.name == "process" then 
			self:downloadResProcess(event)
		elseif event.name == "completed" then 
			self:downloadResCompleted(event)
		end 
	end)
end 

function UpdateScene:downloadResProcess(event)
	local downSize = event.downSize 
	local totalSize = event.totalSize 
	downSize = FL.convertByteToMb(downSize)
	totalSize = FL.convertByteToMb(totalSize)

	self.sliderLayer_:setProcess(downSize, totalSize)
end

function UpdateScene:downloadResCompleted(event)
	-- print("下载完成")
	self:replaceResFile()
end

function UpdateScene:replaceResFile()
	-- print("replaceResFile")
	self.updateRes_:replaceFiles()
	self.updateRes_:replaceCofig()

	self:replaceResFileEnd()
end

function UpdateScene:replaceResFileEnd()
	-- print("资源文件替换完成")
	self:loadRes()
end 

-- 加载代码文件
function UpdateScene:loadRes()
	-- print("loadRes")
	self.updateRes_:loadSource()
	self:loadResEnd()
end 

function UpdateScene:loadResEnd()
	-- print("加载资源文件完成，等待下一步")
	self:updateEnd()
end 

function UpdateScene:toDownloadRes()
	-- print("toDownloadRes")	
	if self.isUpdateRes then 
		self:downloadRes()
	else 
		self:loadRes()
	end
end 
------------------------------------------------------------------------

function UpdateScene:showInfoLayer()
	if self.isUpdateCode or self.isUpdateRes then 
		downSize = FL.convertByteToMb(self.baseSize)
		totalSize = FL.convertByteToMb(self.totalSize)

		local text = string.format("本次更新大小%.2fMB", totalSize)
		if downSize > 0 then 
			text = text..string.format("\n已经下载%.2fMB", downSize)
		end 
		self.infoLayer_:setSizeLabel(text)
		self.infoLayer_:show()
		self.labelShow_:hide()
		self.processLabel_:hide()

		self.sliderLayer_:setProcess(downSize, totalSize)
	else 
		self:loadCode()
	end 
end 

function UpdateScene:onButtonOk()
	self.infoLayer_:hide()
	self.sliderLayer_:show()

	self:toDownloadCode()
	-- self:toDownloadRes()
	-- self:toUpdateScript()
end

function UpdateScene:onButtonCancel()
	self:exit()
end

function UpdateScene:updateEnd()
	self:enterGame()
end

function UpdateScene:exit()	
    os.exit()    
end

function UpdateScene:onExit()
	
end

return UpdateScene
